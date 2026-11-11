#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "yakl::yakl_fortran_interface" for configuration ""
set_property(TARGET yakl::yakl_fortran_interface APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(yakl::yakl_fortran_interface PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "CXX;Fortran"
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib64/libyakl_fortran_interface.a"
  )

list(APPEND _cmake_import_check_targets yakl::yakl_fortran_interface )
list(APPEND _cmake_import_check_files_for_yakl::yakl_fortran_interface "${_IMPORT_PREFIX}/lib64/libyakl_fortran_interface.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
