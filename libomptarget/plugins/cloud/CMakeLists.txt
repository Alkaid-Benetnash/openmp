##===----------------------------------------------------------------------===##
#
#                     The LLVM Compiler Infrastructure
#
# This file is dual licensed under the MIT and the University of Illinois Open
# Source Licenses. See LICENSE.txt for details.
#
##===----------------------------------------------------------------------===##
#
# Build a plugin for a cloud machine if available.
#
##===----------------------------------------------------------------------===##
if(LIBOMPTARGET_DEP_LIBELF_FOUND)
  if(LIBOMPTARGET_DEP_LIBSSH_FOUND)
    if(LIBOMPTARGET_DEP_ZLIB_FOUND)
      if(LIBOMPTARGET_DEP_LIBHDFS3_FOUND)

        libomptarget_say("Building cloud offloading plugin")

        include_directories(src/)
        include_directories(src/providers)
        include_directories(src/util)
        include_directories(inih)
        include_directories(${LIBOMPTARGET_DEP_LIBSSH_INCLUDE_DIRS})
        include_directories(${LIBOMPTARGET_DEP_LIBELF_INCLUDE_DIRS})
        include_directories(${LIBOMPTARGET_DEP_LIBHDFS3_INCLUDE_DIRS})
        include_directories(${LIBOMPTARGET_DEP_ZLIB_INCLUDE_DIRS})
        include_directories(${LIBOMPTARGET_DEP_LIBFFI_INCLUDE_DIR})

        add_library(
            inih SHARED inih/ini.c inih/INIReader.cpp)

        add_library(
            omptarget.rtl.cloud
            SHARED
            src/rtl.cpp
            src/providers/amazon.cpp
            src/providers/azure.cpp
            src/providers/generic.cpp
            src/providers/local.cpp
            src/util/cloud_ssh.cpp
            src/util/cloud_compression.cpp
            src/util/cloud_util.cpp)

        # Install plugin under the lib destination folder.
        install(TARGETS omptarget.rtl.cloud LIBRARY DESTINATION lib${LIBOMPTARGET_LIBDIR_SUFFIX})

        if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
           target_link_libraries(omptarget.rtl.cloud
              inih
              ${LIBOMPTARGET_DEP_LIBHDFS3_LIBRARIES}
              ${LIBOMPTARGET_DEP_LIBELF_LIBRARIES}
              ${LIBOMPTARGET_DEP_LIBSSH_LIBRARIES}
              ${LIBOMPTARGET_DEP_ZLIB_LIBRARIES}
              ${LIBOMPTARGET_DEP_LIBFFI_LIBRARIES}
              ${CMAKE_THREAD_LIBS_INIT}
              dl)
        else()
           target_link_libraries(omptarget.rtl.cloud
              inih
              ${LIBOMPTARGET_DEP_LIBHDFS3_LIBRARIES}
              ${LIBOMPTARGET_DEP_LIBELF_LIBRARIES}
              ${LIBOMPTARGET_DEP_LIBSSH_LIBRARIES}
              ${LIBOMPTARGET_DEP_ZLIB_LIBRARIES}
              ${LIBOMPTARGET_DEP_LIBFFI_LIBRARIES}
              ${CMAKE_THREAD_LIBS_INIT}
              dl
              "-Wl,--version-script=${CMAKE_CURRENT_SOURCE_DIR}/../exports")
        endif()

        # Report to the parent scope that we are building a plugin.
        set(LIBOMPTARGET_SYSTEM_TARGETS
          "${LIBOMPTARGET_SYSTEM_TARGETS} x86_64-unkown-linux-spark" PARENT_SCOPE)

      else()
        libomptarget_say("Not building cloud offloading plugin: libhdfs3 not found in system.")
      endif()
    else()
      libomptarget_say("Not building cloud offloading plugin: zlib not found in system.")
    endif()
  else()
    libomptarget_say("Not building cloud offloading plugin: libssh not found in system.")
  endif()
else()
  libomptarget_say("Not building cloud offloading plugin: libelf dependency not found.")
endif()
