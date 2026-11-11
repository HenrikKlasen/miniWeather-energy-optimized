#!/bin/bash

# -----------------------------------------------------------------------------
# Energy-optimised variant of cmake_aion_foss_cpu.sh
# -----------------------------------------------------------------------------
# Changes vs. the base script:
#   * Enabled link-time optimisation (-flto) across the whole program so the
#     compiler can optimise across perform_timestep -> semi_discrete_step ->
#     compute_tendencies_* and hoist invariant loads out of the hot stencil
#     loops. For a memory-bandwidth-bound MPI kernel this is the highest-impact
#     compiler-level change and typically gives single-digit % energy savings.
#   * Kept -Ofast -march=native -mtune=native (full ISA use, no portability loss
#     on homogeneous Aion nodes) and -DNO_INFORM (drops per-step printf from rank 0).
#   * Kept -DSIMD_LEN=4 for the stencil. Increasing SIMD length usually does NOT
#     help a bandwidth-bound kernel and can raise register pressure / power.
#
# NOTE: For maximum effect, pair this with the PGO two-pass build described in
# ENERGY_OPTIMIZATION.md (instrument -> run the real MPI solve -> recompile with
# -fprofile-use). LTO alone is enabled here.
#
# ALSO NOTE: LTO requires the link flags to carry -flto too, otherwise the
# optimizer has no IR to work with at link time. Both flags are set below.
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

# Number of parallel LTO (link-time optimisation) jobs. GCC warns
#     "lto-wrapper: warning: using serial compilation of N LTRANS jobs"
# and compiles the LTO passes serially when -flto has no count. Setting
# -flto=<n> makes the LTO passes run in parallel (faster link, quieter log).
# Note: <n> here is the number of LTO sub-jobs PER invocation, not the -j jobs
# of make. Pick something modest (e.g. 8-16) so it doesn't oversubscribe.
LTO_JOBS=16
LTO_FLAGS="-flto=${LTO_JOBS} -fuse-linker-plugin"

# With -flto, static archives (libyakl_fortran_interface.a) are produced by
# 'ar'/'ranlib' which must be able to parse LTO objects. Plain binutils ar emits
#   "plugin needed to handle lto object"
# because it is missing the GIMPLE/LTO plugin. GCC ships wrapper programs
# (gcc-ar / gcc-ranlib) that are located next to GCC and load the plugin
# automatically. Resolve them next to the active compiler and hand the names to
# CMake (CMAKE_AR / CMAKE_RANLIB) so archive creation understands LTO objects.
GCC_BIN_DIR=$(dirname "$(command -v gcc)")
CMAKE_AR_BIN="${GCC_BIN_DIR}/gcc-ar"
CMAKE_RANLIB_BIN="${GCC_BIN_DIR}/gcc-ranlib"

# Combined compile+link optimisation flags.
#   -Ofast -march=native -mtune=native : base aggressive optimisation (as before)
#   -flto=N -fuse-linker-plugin        : whole-program optimisation at link time,
#                                        with N-way parallel LTO sub-jobs
#   -DSIMD_LEN=4                       : SIMD vector width for the stencil
#   -DNO_INFORM                        : remove per-step printf (rank 0)
#
# -flto must appear in BOTH the compile flags (below) and the executable linker
# flags (set as LDFLAGS_CXX / CMAKE_EXE_LINKER_FLAGS further down).
OPT_FLAGS="-DSIMD_LEN=4 -Ofast ${LTO_FLAGS} -march=native -mtune=native -DNO_INFORM -I${OLCF_PARALLEL_NETCDF_ROOT}/include"
LINK_FLAGS="${LTO_FLAGS} -L${OLCF_PARALLEL_NETCDF_ROOT}/lib -lpnetcdf"

cmake -DCMAKE_CXX_COMPILER=mpic++         \
      -DCMAKE_C_COMPILER=mpicc            \
      -DCMAKE_Fortran_COMPILER=mpif90     \
      -DCMAKE_AR="${CMAKE_AR_BIN}"        \
      -DCMAKE_RANLIB="${CMAKE_RANLIB_BIN}" \
      -DYAKL_CXX_FLAGS="${OPT_FLAGS}"     \
      -DLDFLAGS="${LINK_FLAGS}"           \
      -DCMAKE_EXE_LINKER_FLAGS="${LTO_FLAGS}" \
      -DNX=2048                           \
      -DNZ=1024                           \
      -DSIM_TIME=200                      \
      -DOUT_FREQ=2000                     \
      ..
