#!/bin/bash

module load toolchain/foss/2023b devel/CMake/3.27.6-GCCcore-13.2.0 data/PnetCDF
export TEST_MPI_COMMAND="mpirun -n 1"
unset CUDAFLAGS
unset CXXFLAGS

unset OMPI_CXX
unset OMPI_CC
unset OMPI_F90
unset OMPI_FC

./cmake_clean.sh

cmake -DCMAKE_CXX_COMPILER=mpic++         \
      -DCMAKE_C_COMPILER=mpicc            \
      -DCMAKE_Fortran_COMPILER=mpif90     \
      -DYAKL_CXX_FLAGS="-DSIMD_LEN=4 -Ofast -march=native -mtune=native -DNO_INFORM -I${OLCF_PARALLEL_NETCDF_ROOT}/include"   \
      -DLDFLAGS="-L${OLCF_PARALLEL_NETCDF_ROOT}/lib -lpnetcdf"  \
      -DNX=2048                           \
      -DNZ=1024                           \
      -DSIM_TIME=200                      \
      -DOUT_FREQ=2000                     \
      ..

