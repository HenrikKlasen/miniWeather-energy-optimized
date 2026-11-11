set(CMAKE_Fortran_COMPILER "/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/OpenMPI/4.1.6-GCC-13.2.0/bin/mpif90")
set(CMAKE_Fortran_COMPILER_ARG1 "")
set(CMAKE_Fortran_COMPILER_ID "GNU")
set(CMAKE_Fortran_COMPILER_VERSION "13.2.0")
set(CMAKE_Fortran_COMPILER_WRAPPER "")
set(CMAKE_Fortran_PLATFORM_ID "")
set(CMAKE_Fortran_SIMULATE_ID "")
set(CMAKE_Fortran_COMPILER_FRONTEND_VARIANT "GNU")
set(CMAKE_Fortran_SIMULATE_VERSION "")




set(CMAKE_AR "/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/binutils/2.40-GCCcore-13.2.0/bin/ar")
set(CMAKE_Fortran_COMPILER_AR "/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/GCCcore/13.2.0/bin/gcc-ar")
set(CMAKE_RANLIB "/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/binutils/2.40-GCCcore-13.2.0/bin/ranlib")
set(CMAKE_TAPI "CMAKE_TAPI-NOTFOUND")
set(CMAKE_Fortran_COMPILER_RANLIB "/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/GCCcore/13.2.0/bin/gcc-ranlib")
set(CMAKE_COMPILER_IS_GNUG77 1)
set(CMAKE_Fortran_COMPILER_LOADED 1)
set(CMAKE_Fortran_COMPILER_WORKS TRUE)
set(CMAKE_Fortran_ABI_COMPILED TRUE)

set(CMAKE_Fortran_COMPILER_ENV_VAR "FC")

set(CMAKE_Fortran_COMPILER_SUPPORTS_F90 1)

set(CMAKE_Fortran_COMPILER_ID_RUN 1)
set(CMAKE_Fortran_SOURCE_FILE_EXTENSIONS f;F;fpp;FPP;f77;F77;f90;F90;for;For;FOR;f95;F95;f03;F03;f08;F08)
set(CMAKE_Fortran_IGNORE_EXTENSIONS h;H;o;O;obj;OBJ;def;DEF;rc;RC)
set(CMAKE_Fortran_LINKER_PREFERENCE 20)
set(CMAKE_Fortran_LINKER_DEPFILE_SUPPORTED TRUE)
if(UNIX)
  set(CMAKE_Fortran_OUTPUT_EXTENSION .o)
else()
  set(CMAKE_Fortran_OUTPUT_EXTENSION .obj)
endif()

# Save compiler ABI information.
set(CMAKE_Fortran_SIZEOF_DATA_PTR "8")
set(CMAKE_Fortran_COMPILER_ABI "")
set(CMAKE_Fortran_LIBRARY_ARCHITECTURE "")

if(CMAKE_Fortran_SIZEOF_DATA_PTR AND NOT CMAKE_SIZEOF_VOID_P)
  set(CMAKE_SIZEOF_VOID_P "${CMAKE_Fortran_SIZEOF_DATA_PTR}")
endif()

if(CMAKE_Fortran_COMPILER_ABI)
  set(CMAKE_INTERNAL_PLATFORM_ABI "${CMAKE_Fortran_COMPILER_ABI}")
endif()

if(CMAKE_Fortran_LIBRARY_ARCHITECTURE)
  set(CMAKE_LIBRARY_ARCHITECTURE "")
endif()





set(CMAKE_Fortran_IMPLICIT_INCLUDE_DIRECTORIES "/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/OpenMPI/4.1.6-GCC-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/OpenMPI/4.1.6-GCC-13.2.0/lib;/mnt/aiongpfs/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/GCCcore/13.2.0/lib/gcc/x86_64-pc-linux-gnu/13.2.0/finclude;/home/users/hklasen/.local/easybuild/software/PnetCDF/1.13.0-gompi-2023b/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libarchive/3.7.2-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/cURL/8.3.0-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/bzip2/1.0.8-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/ncurses/6.4-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/FFTW.MPI/3.3.10-gompi-2023b/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/FFTW/3.3.10-GCC-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/FlexiBLAS/3.3.1-GCC-13.2.0/include/flexiblas;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/FlexiBLAS/3.3.1-GCC-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/OpenBLAS/0.3.24-GCC-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/UCC/1.2.0-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/PMIx/4.2.6-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libfabric/1.19.0-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/UCX/1.15.0-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libevent/2.1.12-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/hwloc/2.9.2-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libpciaccess/0.17-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libxml2/2.11.5-GCCcore-13.2.0/include/libxml2;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libxml2/2.11.5-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/numactl/2.0.16-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/binutils/2.40-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/OpenSSL/1.1/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/XZ/5.4.4-GCCcore-13.2.0/include;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/zlib/1.2.13-GCCcore-13.2.0/include;/mnt/aiongpfs/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/GCCcore/13.2.0/lib/gcc/x86_64-pc-linux-gnu/13.2.0/include;/mnt/aiongpfs/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/GCCcore/13.2.0/lib/gcc/x86_64-pc-linux-gnu/13.2.0/include-fixed;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/GCCcore/13.2.0/include;/usr/include")
set(CMAKE_Fortran_IMPLICIT_LINK_LIBRARIES "mpi_usempif08;mpi_usempi_ignore_tkr;mpi_mpifh;mpi;gfortran;m;gcc_s;gcc;quadmath;m;gcc_s;gcc;c;gcc_s;gcc")
set(CMAKE_Fortran_IMPLICIT_LINK_DIRECTORIES "/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/OpenMPI/4.1.6-GCC-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/hwloc/2.9.2-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libevent/2.1.12-GCCcore-13.2.0/lib;/mnt/aiongpfs/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/GCCcore/13.2.0/lib/gcc/x86_64-pc-linux-gnu/13.2.0;/mnt/aiongpfs/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/GCCcore/13.2.0/lib/gcc;/home/users/hklasen/.local/easybuild/software/PnetCDF/1.13.0-gompi-2023b/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libarchive/3.7.2-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/cURL/8.3.0-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/bzip2/1.0.8-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/ncurses/6.4-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/ScaLAPACK/2.2.0-gompi-2023b-fb/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/FFTW.MPI/3.3.10-gompi-2023b/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/FFTW/3.3.10-GCC-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/FlexiBLAS/3.3.1-GCC-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/OpenBLAS/0.3.24-GCC-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/OpenMPI/4.1.6-GCC-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/UCC/1.2.0-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/PMIx/4.2.6-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libfabric/1.19.0-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/UCX/1.15.0-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libevent/2.1.12-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/hwloc/2.9.2-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libpciaccess/0.17-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libxml2/2.11.5-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/numactl/2.0.16-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/binutils/2.40-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/OpenSSL/1.1/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/XZ/5.4.4-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/zlib/1.2.13-GCCcore-13.2.0/lib64;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/GCCcore/13.2.0/lib64;/mnt/aiongpfs/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/GCCcore/13.2.0/lib64;/lib64;/usr/lib64;/home/users/hklasen/.local/easybuild/software/PnetCDF/1.13.0-gompi-2023b/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libarchive/3.7.2-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/cURL/8.3.0-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/bzip2/1.0.8-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/ncurses/6.4-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/ScaLAPACK/2.2.0-gompi-2023b-fb/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/FFTW.MPI/3.3.10-gompi-2023b/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/FFTW/3.3.10-GCC-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/FlexiBLAS/3.3.1-GCC-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/OpenBLAS/0.3.24-GCC-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/UCC/1.2.0-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/PMIx/4.2.6-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libfabric/1.19.0-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/UCX/1.15.0-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libpciaccess/0.17-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/libxml2/2.11.5-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/numactl/2.0.16-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/binutils/2.40-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/XZ/5.4.4-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/zlib/1.2.13-GCCcore-13.2.0/lib;/opt/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/GCCcore/13.2.0/lib;/mnt/aiongpfs/apps/easybuild/systems/aion/rhel810-20250803/2023b/epyc/software/GCCcore/13.2.0/lib")
set(CMAKE_Fortran_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")
