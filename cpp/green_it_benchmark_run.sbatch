#!/bin/bash -l
#SBATCH --job-name=green_it_benchmark_run
#SBATCH --output=output/green_it_%j.out
#SBATCH --error=errors/green_it_%j.err

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=128
#SBATCH --time=1:00:00
#SBATCH --partition=batch
#SBATCH --exclusive

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

source cmake_aion_foss_cpu.sh
make -j

echo "============================================================"
echo "Warmup runs"
echo "============================================================"

for ((i=1; i<=WARMUP_RUNS; i++)); do
    echo "Warmup run $i/$WARMUP_RUNS"
    srun -n 128 ./mpi
done
MAX_ENERGY=$(max_energy_sum_nodes)

echo "============================================================"
echo "Benchmark runs"
echo "============================================================"

TOTAL_RUNTIME=0
TOTAL_ENERGY=0

for ((i=1; i<=BENCH_RUNS; i++)); do

    echo
    echo "Benchmark run $i/$BENCH_RUNS"
    E0=$(energy_sum_nodes)
    T0=$(date +%s.%N)

    srun -n 128 ./mpi

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

    TOTAL_RUNTIME=$(awk "BEGIN{print $TOTAL_RUNTIME+$RUNTIME}")
    TOTAL_ENERGY=$(awk "BEGIN{print $TOTAL_ENERGY+$ENERGY}")

    echo "Runtime : $RUNTIME s"
    echo "Energy  : $ENERGY J"
    echo "Power   : $POWER W"
done

AVG_RUNTIME=$(awk "BEGIN{print $TOTAL_RUNTIME/$BENCH_RUNS}")
AVG_ENERGY=$(awk "BEGIN{print $TOTAL_ENERGY/$BENCH_RUNS}")
AVG_POWER=$(awk "BEGIN{print $AVG_ENERGY/$AVG_RUNTIME}")

echo
echo "============ Energy Report MPI ============================="
echo "Benchmark runs : $BENCH_RUNS"
echo "Average runtime: $AVG_RUNTIME s"
echo "Average energy : $AVG_ENERGY J"
echo "Average power  : $AVG_POWER W"
echo "Total energy   : $TOTAL_ENERGY J"
echo "============================================================"
