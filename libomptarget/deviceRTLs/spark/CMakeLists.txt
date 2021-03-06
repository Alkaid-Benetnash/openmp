##===----------------------------------------------------------------------===##
#
#                     The LLVM Compiler Infrastructure
#
# This file is dual licensed under the MIT and the University of Illinois Open
# Source Licenses. See LICENSE.txt for details.
#
##===----------------------------------------------------------------------===##
#
# Build the Spark Device RTL if SBT is available
#
##===----------------------------------------------------------------------===##)

if(LIBOMPTARGET_DEP_SBT_FOUND)
  libomptarget_say("Building Spark offloading device RTL.")

  add_custom_target(omptarget-spark ALL
      COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR} && ${LIBOMPTARGET_DEP_SBT_EXECUTABLE} publishLocal < /dev/null)

  set_property(DIRECTORY PROPERTY ADDITIONAL_MAKE_CLEAN_FILES
     "${CMAKE_CURRENT_SOURCE_DIR}/project"
     "${CMAKE_CURRENT_SOURCE_DIR}/target")

else()
  libomptarget_say("Not building Spark offloading device RTL: SBT not found in the system.")
endif()
