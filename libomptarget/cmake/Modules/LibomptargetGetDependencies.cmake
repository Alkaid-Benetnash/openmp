#
#//===----------------------------------------------------------------------===//
#//
#//                     The LLVM Compiler Infrastructure
#//
#// This file is dual licensed under the MIT and the University of Illinois Open
#// Source Licenses. See LICENSE.txt for details.
#//
#//===----------------------------------------------------------------------===//
#

# Try to detect in the system several dependencies required by the different
# components of libomptarget. These are the dependencies we have:
#
# libelf : required by some targets to handle the ELF files at runtime.
# libffi : required to launch target kernels given function and argument
#          pointers.
# CUDA : required to control offloading to NVIDIA GPUs.

# Intel AAL
# Intel AAL SDK: required to control offloading to Intel HARP FPGAs.

# Intel OPAE
# Intel OPAE: required to control offloading to Intel HARP FPGAs.
# Intel OPAE ASE + BBB_CCI_MPF: required to control Intel ASE.
# UUID : required by OPAE
# boost program_options : required by OPAE
# JSON-C : required by OPAE

include (FindPackageHandleStandardArgs)
include (FindUUID)
include (FindJSON-C)

################################################################################
# Looking for libelf...
################################################################################

find_path (
  LIBOMPTARGET_DEP_LIBELF_INCLUDE_DIR
  NAMES
    libelf.h
  PATHS
    /usr/include
    /usr/local/include
    /opt/local/include
    /sw/include
    ENV CPATH
  PATH_SUFFIXES
    libelf)

find_library (
  LIBOMPTARGET_DEP_LIBELF_LIBRARIES
  NAMES
    elf
  PATHS
    /usr/lib
    /usr/local/lib
    /opt/local/lib
    /sw/lib
    ENV LIBRARY_PATH
    ENV LD_LIBRARY_PATH)

set(LIBOMPTARGET_DEP_LIBELF_INCLUDE_DIRS ${LIBOMPTARGET_DEP_LIBELF_INCLUDE_DIR})
find_package_handle_standard_args(
  LIBOMPTARGET_DEP_LIBELF
  DEFAULT_MSG
  LIBOMPTARGET_DEP_LIBELF_LIBRARIES
  LIBOMPTARGET_DEP_LIBELF_INCLUDE_DIRS)

mark_as_advanced(
  LIBOMPTARGET_DEP_LIBELF_INCLUDE_DIRS
  LIBOMPTARGET_DEP_LIBELF_LIBRARIES)

################################################################################
# Looking for libffi...
################################################################################
find_package(PkgConfig)

pkg_check_modules(LIBOMPTARGET_SEARCH_LIBFFI QUIET libffi)

find_path (
  LIBOMPTARGET_DEP_LIBFFI_INCLUDE_DIR
  NAMES
    ffi.h
  HINTS
    ${LIBOMPTARGET_SEARCH_LIBFFI_INCLUDEDIR}
    ${LIBOMPTARGET_SEARCH_LIBFFI_INCLUDE_DIRS}
  PATHS
    /usr/include
    /usr/local/include
    /opt/local/include
    /sw/include
    ENV CPATH)

# Don't bother look for the library if the header files were not found.
if (LIBOMPTARGET_DEP_LIBFFI_INCLUDE_DIR)
  find_library (
      LIBOMPTARGET_DEP_LIBFFI_LIBRARIES
    NAMES
      ffi
    HINTS
      ${LIBOMPTARGET_SEARCH_LIBFFI_LIBDIR}
      ${LIBOMPTARGET_SEARCH_LIBFFI_LIBRARY_DIRS}
    PATHS
      /usr/lib
      /usr/local/lib
      /opt/local/lib
      /sw/lib
      ENV LIBRARY_PATH
      ENV LD_LIBRARY_PATH)
endif()

set(LIBOMPTARGET_DEP_LIBFFI_INCLUDE_DIRS ${LIBOMPTARGET_DEP_LIBFFI_INCLUDE_DIR})
find_package_handle_standard_args(
  LIBOMPTARGET_DEP_LIBFFI
  DEFAULT_MSG
  LIBOMPTARGET_DEP_LIBFFI_LIBRARIES
  LIBOMPTARGET_DEP_LIBFFI_INCLUDE_DIRS)

mark_as_advanced(
  LIBOMPTARGET_DEP_LIBFFI_INCLUDE_DIRS
  LIBOMPTARGET_DEP_LIBFFI_LIBRARIES)

################################################################################
# Looking for CUDA...
################################################################################
find_package(CUDA QUIET)

set(LIBOMPTARGET_DEP_CUDA_FOUND ${CUDA_FOUND})
set(LIBOMPTARGET_DEP_CUDA_LIBRARIES ${CUDA_LIBRARIES})
set(LIBOMPTARGET_DEP_CUDA_INCLUDE_DIRS ${CUDA_INCLUDE_DIRS})

mark_as_advanced(
  LIBOMPTARGET_DEP_CUDA_FOUND
  LIBOMPTARGET_DEP_CUDA_INCLUDE_DIRS
  LIBOMPTARGET_DEP_CUDA_LIBRARIES)

################################################################################
# Looking for Intel AAL SDK...
################################################################################
find_path (
    LIBOMPTARGET_DEP_AALSDK_INCLUDE_DIRS
  NAMES
    aalsdk/Runtime.h
    aalsdk/AALTypes.h
    aalsdk/Runtime.h
    aalsdk/AALLoggerExtern.h
    aalsdk/service/IALIAFU.h
  PATHS
    /usr/include
    /usr/local/include
    /opt/local/include
    /sw/include
    ${AALSDK}/include
    ENV CPATH)

find_library (
    LIBOMPTARGET_DEP_AALSDK_AALRT_LIBRARY
  NAMES
    aalrt
  PATHS
    /usr/lib
    /usr/local/lib
    /opt/local/lib
    /sw/lib
    ${AALSDK}/lib
    ENV LIBRARY_PATH
    ENV LD_LIBRARY_PATH)

find_library (
    LIBOMPTARGET_DEP_AALSDK_AALCLP_LIBRARY
  NAMES
    aalclp
  PATHS
    /usr/lib
    /usr/local/lib
    /opt/local/lib
    /sw/lib
    ${AALSDK}/lib
    ENV LIBRARY_PATH
    ENV LD_LIBRARY_PATH)

find_library (
    LIBOMPTARGET_DEP_AALSDK_OSAL_LIBRARY
  NAMES
    OSAL
  PATHS
    /usr/lib
    /usr/local/lib
    /opt/local/lib
    /sw/lib
    ${AALSDK}/lib
    ENV LIBRARY_PATH
    ENV LD_LIBRARY_PATH)

find_library (
    LIBOMPTARGET_DEP_AALSDK_AAS_LIBRARY
  NAMES
    AAS
  PATHS
    /usr/lib
    /usr/local/lib
    /opt/local/lib
    /sw/lib
    ${AALSDK}/lib
    ENV LIBRARY_PATH
    ENV LD_LIBRARY_PATH)

set(LIBOMPTARGET_DEP_AALSDK_LIBRARIES
  ${LIBOMPTARGET_DEP_AALSDK_LIBRARIES}
  ${LIBOMPTARGET_DEP_AALSDK_AALRT_LIBRARY})

set(LIBOMPTARGET_DEP_AALSDK_LIBRARIES
  ${LIBOMPTARGET_DEP_AALSDK_LIBRARIES}
  ${LIBOMPTARGET_DEP_AALSDK_AALCLP_LIBRARY})

set(LIBOMPTARGET_DEP_AALSDK_LIBRARIES
  ${LIBOMPTARGET_DEP_AALSDK_LIBRARIES}
  ${LIBOMPTARGET_DEP_AALSDK_OSAL_LIBRARY})

set(LIBOMPTARGET_DEP_AALSDK_LIBRARIES
  ${LIBOMPTARGET_DEP_AALSDK_LIBRARIES}
  ${LIBOMPTARGET_DEP_AALSDK_AAS_LIBRARY})

#find_package_handle_standard_args(
#  LIBOMPTARGET_DEP_AALSDK
#  DEFAULT_MSG
#  LIBOMPTARGET_DEP_AALSDK_LIBRARIES
#  LIBOMPTARGET_DEP_AALSDK_INCLUDE_DIRS)
#
#mark_as_advanced(
#  LIBOMPTARGET_DEP_AALSDK_INCLUDE_DIRS
#  LIBOMPTARGET_DEP_AALSDK_LIBRARIES)

################################################################################
# Looking for Intel OPAE ...
################################################################################
find_path (
    LIBOMPTARGET_DEP_OPAE_INCLUDE_DIRS
  NAMES
    vai/fpga.h
  PATHS
    /usr/include
    /usr/local/include
    /opt/local/include
    /sw/include
    ${OPAE}/include
    ENV CPATH)

find_library (
  LIBOMPTARGET_DEP_OPAE_OPAE_C_LIBRARY
  NAMES
    vai-c
  PATHS
    /usr/lib
    /usr/local/lib
    /opt/local/lib
    /sw/lib
    ${OPAE}/lib
    ENV LIBRARY_PATH
    ENV LD_LIBRARY_PATH)

set(LIBOMPTARGET_DEP_OPAE_LIBRARIES
  ${LIBOMPTARGET_DEP_OPAE_LIBRARIES}
  ${LIBOMPTARGET_DEP_OPAE_OPAE_C_LIBRARY})

find_package_handle_standard_args(
  LIBOMPTARGET_DEP_OPAE
  DEFAULT_MSG
  LIBOMPTARGET_DEP_OPAE_LIBRARIES
  LIBOMPTARGET_DEP_OPAE_INCLUDE_DIRS)

mark_as_advanced(
  LIBOMPTARGET_DEP_OPAE_INCLUDE_DIRS
  LIBOMPTARGET_DEP_OPAE_LIBRARIES)

################################################################################
# Looking for Intel OPAE ASE ...
################################################################################
find_path (
    LIBOMPTARGET_DEP_OPAE_ASE_INCLUDE_DIRS
  NAMES
    vai/fpga.h
  PATHS
    /usr/include
    /usr/local/include
    /opt/local/include
    /sw/include
    ${OPAE}/include
    ENV CPATH)

find_library (
  LIBOMPTARGET_DEP_OPAE_ASE_C_LIBRARY
  NAMES
    vai-c-ase
  PATHS
    /usr/lib
    /usr/local/lib
    /opt/local/lib
    /sw/lib
    ${OPAE}/lib
    ENV LIBRARY_PATH
    ENV LD_LIBRARY_PATH)

set(LIBOMPTARGET_DEP_OPAE_ASE_LIBRARIES
  ${LIBOMPTARGET_DEP_OPAE_ASE_LIBRARIES}
  ${LIBOMPTARGET_DEP_OPAE_ASE_C_LIBRARY})

find_package_handle_standard_args(
  LIBOMPTARGET_DEP_OPAE_ASE
  DEFAULT_MSG
  LIBOMPTARGET_DEP_OPAE_ASE_LIBRARIES
  LIBOMPTARGET_DEP_OPAE_ASE_INCLUDE_DIRS)

mark_as_advanced(
  LIBOMPTARGET_DEP_OPAE_ASE_INCLUDE_DIRS
  LIBOMPTARGET_DEP_OPAE_ASE_LIBRARIES)

################################################################################
# Looking for Intel BBB_CCI_MPF ...
################################################################################
find_path (
    LIBOMPTARGET_DEP_BBB_CCI_MPF_INCLUDE_DIRS
  NAMES
    vai/mpf/mpf.h
  PATHS
    /usr/include
    /usr/local/include
    /opt/local/include
    /sw/include
    ${BBB_CCI_MPF}/include
    ENV CPATH)

find_library (
  LIBOMPTARGET_DEP_BBB_CCI_MPF_MPF_LIBRARY
  NAMES
    MPF_VAI
  PATHS
    /usr/lib
    /usr/local/lib
    /opt/local/lib
    /sw/lib
    ${BBB_CCI_MPF}/lib
    ENV LIBRARY_PATH
    ENV LD_LIBRARY_PATH)

set(LIBOMPTARGET_DEP_BBB_CCI_MPF_LIBRARIES
  ${LIBOMPTARGET_DEP_BBB_CCI_MPF_LIBRARIES}
  ${LIBOMPTARGET_DEP_BBB_CCI_MPF_MPF_LIBRARY})

find_package_handle_standard_args(
  LIBOMPTARGET_DEP_BBB_CCI_MPF
  DEFAULT_MSG
  LIBOMPTARGET_DEP_BBB_CCI_MPF_LIBRARIES
  LIBOMPTARGET_DEP_BBB_CCI_MPF_INCLUDE_DIRS)

mark_as_advanced(
  LIBOMPTARGET_DEP_BBB_CCI_MPF_INCLUDE_DIRS
  LIBOMPTARGET_DEP_BBB_CCI_MPF_LIBRARIES)

################################################################################
# Looking for UUID ...
################################################################################
find_package(UUID QUIET)

set(LIBOMPTARGET_DEP_UUID_FOUND ${UUID_FOUND})
set(LIBOMPTARGET_DEP_UUID_LIBRARIES ${UUID_LIBRARIES})
set(LIBOMPTARGET_DEP_UUID_INCLUDE_DIRS ${UUID_INCLUDE_DIRS})

mark_as_advanced(
  LIBOMPTARGET_DEP_UUID_FOUND
  LIBOMPTARGET_DEP_UUID_INCLUDE_DIRS
  LIBOMPTARGET_DEP_UUID_LIBRARIES)

################################################################################
# Looking for BOOST ...
################################################################################
find_package(Boost COMPONENTS program_options QUIET)

set(LIBOMPTARGET_DEP_BOOST_FOUND ${Boost_FOUND})
set(LIBOMPTARGET_DEP_BOOST_LIBRARIES ${Boost_LIBRARIES})
set(LIBOMPTARGET_DEP_BOOST_INCLUDE_DIRS ${Boost_INCLUDE_DIRS})

mark_as_advanced(
  LIBOMPTARGET_DEP_BOOST_FOUND
  LIBOMPTARGET_DEP_BOOST_INCLUDE_DIRS
  LIBOMPTARGET_DEP_BOOST_LIBRARIES)

################################################################################
# Looking for JSON-C ...
################################################################################
find_package(JSON-C QUIET)

set(LIBOMPTARGET_DEP_JSON-C_FOUND ${JSON-C_FOUND})
set(LIBOMPTARGET_DEP_JSON-C_LIBRARIES ${JSON-C_LIBRARIES})
set(LIBOMPTARGET_DEP_JSON-C_INCLUDE_DIRS ${JSON-C_INCLUDE_DIRS})

mark_as_advanced(
  LIBOMPTARGET_DEP_JSON-C_FOUND
  LIBOMPTARGET_DEP_JSON-C_INCLUDE_DIRS
  LIBOMPTARGET_DEP_JSON-C_LIBRARIES)

