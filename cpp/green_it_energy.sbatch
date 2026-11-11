#!/bin/bash -l
#SBATCH --job-name=miniWeather_mpi_energy
#SBATCH --output=output/miniWeather_energy_%j.out
#SBATCH --error=errors/miniWeather_energy_%j.err

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=128
#SBATCH --time=00:45:00
#SBATCH --partition=batch
#SBATCH --exclusive

# -----------------------------------------------------------------------------
# Energy-focused benchmark script (single node, 128 MPI ranks).
#
# Differences vs green_it.sbatch:
#   1. MEASUREMENT: does NOT charge the build; runs warm-ups, then multiple timed
#      runs, and reports the MEDIAN energy/runtime/power (robust to single noisy
#      runs). Handles RAPL energy_uj counter rollover via max_energy_range_uj.
#   2. FREQUENCY SWEEP: set FREQ_MIN / FREQ_MAX below and re-submit (or loop over
#      values with an outer job array). For MIN-ABSOLUTE-ENERGY you want to LOWER
#      the cap, not force the max like green_it.sbatch does.
#   3. MPI BINDING: pins ranks to cores to stop migration / idle-spin, which both
#      wastes time and burns power.
#   4. CHOOSE THE BUILD SCRIPT: point BUILD_SCRIPT at the energy-optimised CMake
#      script (LTO enabled) for the compiler-level win, or the stock one for an
#      apples-to-apples baseline.
# -----------------------------------------------------------------------------

BUILD_SCRIPT="cmake_aion_foss_cpu_energy.sh"   # energy-optimised (LTO)
# BUILD_SCRIPT="cmake_aion_foss_cpu.sh"        # stock baseline

# --- Frequency window (MHz). SWEEP THESE. ---
# Start high (near stock) and step down: 2200000, 2000000, 1800000, 1600000, 1400000
# Available governors on this node (from scaling_available_governors): "performance"
# and "powersave" ONLY. "conservative" is NOT available and Slurm will reject it.
#   * "powersave" with a min-max range = run at the floor, boost only when needed.
#     This is the energy-favourable choice for this memory-bound kernel, and the
#     only non-max governor available.
#   * "performance" with min==max == hard-lock to that frequency (good for precise
#     sweeps, but intentionally higher power).
# A plain min-max range (no :governor) is also accepted by Slurm.
FREQ_MIN=2000000
FREQ_MAX=2400000
FREQ_GOV=powersave      # powersave (available & energy-best) or performance

# --- Benchmark control ---
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

cd "$SLURM_SUBMIT_DIR"
cd build

source "$BUILD_SCRIPT"
make -j

echo "============================================================"
echo "Config: ${FREQ_MIN}-${FREQ_MAX} MHz, governor ${FREQ_GOV}, build=${BUILD_SCRIPT}"
echo "============================================================"

echo "--------------------------------------------"
echo "Warmup runs (${WARMUP_RUNS})"
echo "--------------------------------------------"
for ((i=1; i<=WARMUP_RUNS; i++)); do
    echo "Warmup run $i/$WARMUP_RUNS"
    srun --cpu-freq="${FREQ_MIN}-${FREQ_MAX}:${FREQ_GOV}" \
         --cpu-bind=cores -n 128 ./mpi
done

# Capture the RAPL rollover ceiling once after warm-up settles caches/DVFS.
MAX_ENERGY=$(max_energy_sum_nodes)

echo "--------------------------------------------"
echo "Benchmark runs (${BENCH_RUNS})"
echo "--------------------------------------------"

RUNTIMES=()
ENERGIES=()

for ((i=1; i<=BENCH_RUNS; i++)); do
    echo
    echo "Benchmark run $i/$BENCH_RUNS"
    E0=$(energy_sum_nodes)
    T0=$(date +%s.%N)

    srun --cpu-freq="${FREQ_MIN}-${FREQ_MAX}:${FREQ_GOV}" \
         --cpu-bind=cores -n 128 ./mpi

    T1=$(date +%s.%N)
    E1=$(energy_sum_nodes)

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
echo "============ Energy Report MPI ======================================="
echo "Config       : ${FREQ_MIN}-${FREQ_MAX} MHz (${FREQ_GOV}), 128 ranks, build=${BUILD_SCRIPT}"
echo "Benchmark runs : $BENCH_RUNS (median reported)"
echo "Median runtime : $MED_RUNTIME s"
echo "Median energy  : $MED_ENERGY J"
echo "Median power   : $MED_POWER W"
echo "Energy-delay product (EDP) : $EDP J.s  (sanity metric)"
echo "======================================================================"
