#!/bin/bash -l
#SBATCH --job-name=miniWeather_mpi
#SBATCH --output=output/miniWeather_%j.out
#SBATCH --error=errors/miniWeather_%j.err

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=128
#SBATCH --time=00:45:00
#SBATCH --partition=batch
#SBATCH --exclusive
#SBATCH --cpu-freq=2600000-2650000:conservative

energy_sum_nodes() {

    srun -N $SLURM_JOB_NUM_NODES \
         -n $SLURM_JOB_NUM_NODES \
         bash -c '
             cat /sys/class/powercap/intel-rapl:0/energy_uj
             ' | awk '{sum += $1} END {print sum}'
}
T0=$(date +%s.%N)
E0=$(energy_sum_nodes)

module purge
module load toolchain/foss/2023b devel/CMake/3.27.6-GCCcore-13.2.0

cd $SLURM_SUBMIT_DIR
cd build
source cmake_aion_foss_cpu.sh
make
T0=$(date +%s.%N)
E0=$(energy_sum_nodes)
srun -n 128 ./mpi
T1=$(date +%s.%N)
E1=$(energy_sum_nodes)
RUNTIME=$(awk "BEGIN{print $T1-$T0}")       
ENERGY=$(awk "BEGIN{print ($E1-$E0)/1000000}")
POWER=$(awk "BEGIN{print $ENERGY/$RUNTIME}")
echo "============Energy Report MPI======================================"
echo "Program ran for $RUNTIME sec"
echo "Used Energy: $ENERGY J"
echo "Avg. Power: $POWER W"
