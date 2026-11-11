#!/bin/bash

# -----------------------------------------------------------------------------
# PROFILE build for hotspot analysis (gprof -pg). NOT for energy benchmarking.
# -----------------------------------------------------------------------------
# Use this to find WHERE the MPI program spends its time. It builds the MPI
# executable with -pg (gprof instrumentation) plus a modest optimization level
# (-O2, no -Ofast/-flto) so the profile reflects the real hot loops rather than
# inlined/LTO-distorted accounting.
#
# Usage on Aion:
#   source cmake_aion_foss_cpu_prof.sh
#   make -j
#   srun -n 128 ./mpi          # produces gmon.out (or gmon.out.<rank> if SLURM)
#   gprof ./mpi gmon.out       # flat + call-graph profile
#
# For a per-rank profile (128 ranks = 128 gmon.out.*), aggregate with:
#   for f in gmon.out.*; do gprof ./mpi "$f"; done | ...   # or single-rank run:
#   srun -n 1 ./mpi                                      # simplest first look
#
# Known MPI caveat: with 128 ranks the largest per-rank file wins when using a
# single gprof. For an energy-relevant picture, run a SMALL number of ranks
# (e.g. -n 4) with the full domain partition so the profile is representative of
# one rank's steady-state work without spawning 128 gmon files.
# -----------------------------------------------------------------------------

module load toolchain/foss/2023b devel/CMake/3.27.6-GCCcore-13.2.0 data/PnetCDF
export TEST_MPI_COMMAND="mpirun -n 1"
unset CUDAFLAGS
unset CXXFLAGS

unset OMPI_CXX
unset OMPI_CC
unset OMPI_F90
unset OMPI_FC

./cmake_clean.sh

# -pg adds gprof instrumentation.
# -O2 (not -Ofast) keeps the profile meaningful. -march=native is fine.
# -DNO_INFORM removes per-step printf so it doesn't skew timing.
PROF_FLAGS="-DSIMD_LEN=4 -O2 -pg -march=native -mtune=native -DNO_INFORM -I${OLCF_PARALLEL_NETCDF_ROOT}/include"

cmake -DCMAKE_CXX_COMPILER=mpic++         \
      -DCMAKE_C_COMPILER=mpicc            \
      -DCMAKE_Fortran_COMPILER=mpif90     \
      -DYAKL_CXX_FLAGS="${PROF_FLAGS}"    \
      -DLDFLAGS="-pg -L${OLCF_PARALLEL_NETCDF_ROOT}/lib -lpnetcdf" \
      -DNX=2048                           \
      -DNZ=1024                           \
      -DSIM_TIME=200                      \
      -DOUT_FREQ=2000                     \
      ..
