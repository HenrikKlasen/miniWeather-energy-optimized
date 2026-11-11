#!/bin/bash -l
#SBATCH --job-name=miniWeather_mpi
#SBATCH --output=output/miniWeather_%j.out
#SBATCH --error=errors/miniWeather_%j.err

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=128
#SBATCH --time=00:45:00
#SBATCH --partition=batch
#SBATCH --exclusive

# -----------------------------------------------------------------------------
# Baseline benchmark script.
# This is green_it.sbatch with the genuine bugs fixed, keeping the STOCK build
# (cmake_aion_foss_cpu.sh). CPU frequency is left UNRESTRICTED -- i.e. no
# --cpu-freq cap is applied, so the node runs at its default governor / max
# frequency. This represents the stock "no intervention" behaviour, and is the
# reference against which the frequency-capped energy runs are compared.
#
# Fixes vs green_it.sbatch:
#   1. Removed the dead T0/E0 assignments before module load / cd (lines 21-22
#      in the original were overwritten and never used). The energy window now
#      starts once, after the build completes, so reported energy is run-only.
#   2. Added RAPL energy_uj rollover handling via max_energy_range_uj (the
#      original could report a wrong value if the counter wrapped).
#   3. Added warm-up runs, then BENCH_RUNS timed runs, reporting the MEDIAN
#      energy/runtime/power -- same methodology as green_it_energy.sbatch so the
#      numbers are comparable.
# Everything else mirrors the original: stock build script, 128 ranks,
# unrestricted frequency.
# -----------------------------------------------------------------------------

WARMUP_RUNS=2
BENCH_RUNS=5

energy_sum_nodes() {
    srun -N $SLURM_JOB_NUM_NODES \
         -n $SLURM_JOB_NUM_NODES \
         bash -c '
             cat /sys/class/powercap/intel-rapl:0/energy_uj
             ' | awk '{sum += $1} END {print sum}'
}

max_energy_sum_nodes() {
    srun -N $SLURM_JOB_NUM_NODES \
         -n $SLURM_JOB_NUM_NODES \
         bash -c '
             cat /sys/class/powercap/intel-rapl:0/max_energy_range_uj
             ' | awk '{sum += $1} END {print sum}'
}

module purge
module load toolchain/foss/2023b devel/CMake/3.27.6-GCCcore-13.2.0

cd $SLURM_SUBMIT_DIR
cd build
source cmake_aion_foss_cpu.sh
make

# A couple of warm-up runs to settle caches and DVFS before timing.
for ((i=1; i<=WARMUP_RUNS; i++)); do
    echo "Warmup run $i/$WARMUP_RUNS"
    srun -n 128 ./mpi
done

# Capture the RAPL rollover ceiling once, after warm-ups settle.
MAX_ENERGY=$(max_energy_sum_nodes)

echo "--------------------------------------------"
echo "Benchmark runs (${BENCH_RUNS})"
echo "--------------------------------------------"

RUNTIMES=()
ENERGIES=()

for ((i=1; i<=BENCH_RUNS; i++)); do
    echo
    echo "Benchmark run $i/$BENCH_RUNS"
    T0=$(date +%s.%N)
    E0=$(energy_sum_nodes)

    srun -n 128 ./mpi

    T1=$(date +%s.%N)
    E1=$(energy_sum_nodes)

    # Handle RAPL counter rollover (energy_uj wraps at max_energy_range_uj).
    ENERGY_UJ=$(awk \
        -v e0="$E0" \
        -v e1="$E1" \
        -v max="$MAX_ENERGY" '
    BEGIN {
        if (e1 >= e0)
            print e1 - e0;
        else
            print (max - e0) + e1;
    }')

    RUNTIME=$(awk "BEGIN{print $T1-$T0}")
    ENERGY=$(awk "BEGIN{print $ENERGY_UJ/1000000}")
    POWER=$(awk "BEGIN{print $ENERGY/$RUNTIME}")

    RUNTIMES+=("$RUNTIME")
    ENERGIES+=("$ENERGY")

    echo "Runtime : $RUNTIME s"
    echo "Energy  : $ENERGY J"
    echo "Power   : $POWER W"
done

# --- Median helper (robust to one noisy run) ---
median() {
    printf '%s\n' "$@" | sort -n | awk '{a[NR]=$1} END {print (NR%2)? a[(NR+1)/2] : (a[NR/2]+a[NR/2+1])/2}'
}

MED_RUNTIME=$(median "${RUNTIMES[@]}")
MED_ENERGY=$(median "${ENERGIES[@]}")
MED_POWER=$(awk "BEGIN{print $MED_ENERGY/$MED_RUNTIME}")
EDP=$(awk "BEGIN{print $MED_ENERGY*$MED_RUNTIME}")

echo
echo "============ Energy Report MPI (BASELINE) ==============================="
echo "Config       : unrestricted frequency, stock build, 128 ranks"
echo "Benchmark runs : $BENCH_RUNS (median reported)"
echo "Median runtime : $MED_RUNTIME s"
echo "Median energy  : $MED_ENERGY J"
echo "Median power   : $MED_POWER W"
echo "Energy-delay product (EDP) : $EDP J.s  (sanity metric)"
echo "========================================================================="

