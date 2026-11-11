#!/bin/bash

source /usr/share/modules/init/bash
module purge
module load toolchain/intel/2023b devel/CMake/3.27.6-GCCcore-13.2.0 data/PnetCDF/1.13.0-gompi-2023b

export TEST_MPI_COMMAND="mpirun -n 1"
unset CUDAFLAGS
unset CXXFLAGS
unset CXX

export OMPI_CXX=icpc
export OMPI_FC=ifort
export OMPI_F90=ifort
export OMPI_CC=icc

./cmake_clean.sh

cmake -DCMAKE_CXX_COMPILER=mpicxx                        \
      -DCMAKE_Fortran_COMPILER=mpif90                    \
      -DCMAKE_C_COMPILER=mpicc                           \
      -DYAKL_CXX_FLAGS="-Ofast -march=native -ffast-math -DNO_INFORM -DHAVE_MPI -DSIMD_LEN=32 -I/usr/lib/x86_64-linux-gnu/fortran/gfortran-mod-15"  \
      -DLDFLAGS="-L/usr/lib/x86_64-linux-gnu -lpnetcdf"  \
      -DNX=256                                           \
      -DNZ=128                                           \
      -DSIM_TIME=250                                    \
      -DOUT_FREQ=-1                                     \
      

