#
# Find the native FLTK includes and library
#
# The following settings are defined
# FLTK_FLUID_EXECUTABLE, where to find the Fluid tool
# FLTK_INCLUDE_DIR, where to find include files
# FLTK_LIBRARIES, list of fltk libraries
# FLTK_VERSION_1.0.11 Use this Version
# FLTK_VERSION_1.1 Use this Version
# FLTK_FOUND, Don't use FLTK if false.

# this is around for backwards compatibility 
# FLTK_WRAP_UI set to true if FLTK_FLUID_EXECUTABLE is found



# The following settings should not be used in general.
# FLTK_BASE_LIBRARY    = the full path to fltk.lib
# FLTK_GL_LIBRARY      = the full path to fltk_gl.lib
# FLTK_FORMS_LIBRARY   = the full path to fltk_forms.lib
# FLTK_IMAGES_LIBRARY  = the full path to fltk_images.lib

OPTION(FLTK_VERSION_1.1    "Use FLTK version 1.1"    1)
OPTION(FLTK_VERSION_1.0.11 "Use FLTK version 1.0.11" 0)

# Exclusion between the two version

IF(FLTK_VERSION_1.1)
  SET(FLTK_VERSION_1.0.11 0)
ENDIF(FLTK_VERSION_1.1)

# look for both Fl.h and Fl.H
FIND_PATH(FLTK_INCLUDE_DIR FL/Fl.h
  /usr/local/include
  /usr/include
  /usr/local/fltk
  /usr/X11R6/include
)

FIND_PATH(FLTK_INCLUDE_DIR FL/Fl.H
  /usr/local/include
  /usr/include
  /usr/local/fltk
  /usr/X11R6/include
)

# Platform dependent libraries required by FLTK

IF(WIN32)
  IF(NOT CYGWIN)
    IF(BORLAND)
      SET( FLTK_PLATFORM_DEPENDENT_LIBS import32 )
    ELSE(BORLAND)
      SET( FLTK_PLATFORM_DEPENDENT_LIBS wsock32 comctl32 )
    ENDIF(BORLAND)
  ENDIF(NOT CYGWIN)
ENDIF(WIN32)

IF(UNIX)
  INCLUDE(${CMAKE_ROOT}/Modules/FindX11.cmake)
  SET( FLTK_PLATFORM_DEPENDENT_LIBS ${X11_LIBRARIES} -lm)
ENDIF(UNIX)

IF(APPLE)
  SET( FLTK_PLATFORM_DEPENDENT_LIBS  "-framework Carbon -framework Cocoa -framework ApplicationServices -lz")
ENDIF(APPLE)

# Make sure that the FLTK include path has been set
# So the FLTK_LIBRARY does not appear the first time
IF(FLTK_INCLUDE_DIR)
  IF(FLTK_VERSION_1.0.11)
      FIND_LIBRARY(FLTK_BASE_LIBRARY  NAMES fltk fltkd
           PATHS /usr/lib /usr/local/lib
           /usr/local/lib/fltk
           /usr/local/fltk/lib
           /usr/X11R6/lib ${FLTK_INCLUDE_DIR}/lib
      )
  ENDIF(FLTK_VERSION_1.0.11)
  IF(FLTK_VERSION_1.1)
    FIND_LIBRARY(FLTK_BASE_LIBRARY  NAMES fltk fltkd
      PATHS /usr/lib /usr/local/lib /usr/local/fltk/lib
      /usr/X11R6/lib  ${FLTK_INCLUDE_DIR}/lib
    )
    FIND_LIBRARY(FLTK_GL_LIBRARY NAMES fltkgl fltkgld fltk_gl
      PATHS /usr/lib /usr/local/lib /usr/local/fltk/lib
      /usr/X11R6/lib ${FLTK_INCLUDE_DIR}/lib
    )
    FIND_LIBRARY(FLTK_FORMS_LIBRARY NAMES fltkforms fltkformsd fltk_forms
      PATHS /usr/lib /usr/local/lib /usr/local/fltk/lib
      /usr/X11R6/lib  ${FLTK_INCLUDE_DIR}/lib
    )
    FIND_LIBRARY(FLTK_IMAGES_LIBRARY NAMES fltkimages fltkimagesd fltk_images
      PATHS /usr/lib /usr/local/lib /usr/local/fltk/lib
      /usr/X11R6/lib  ${FLTK_INCLUDE_DIR}/lib
    )
  ENDIF(FLTK_VERSION_1.1)
  SET( FLTK_LIBRARIES 
    ${FLTK_GL_LIBRARY}
    ${FLTK_FORMS_LIBRARY}
    ${FLTK_IMAGES_LIBRARY}
    ${FLTK_BASE_LIBRARY}
    ${FLTK_PLATFORM_DEPENDENT_LIBS}
  )
ENDIF(FLTK_INCLUDE_DIR)
# Find Fluid
FIND_PROGRAM(FLTK_FLUID_EXECUTABLE fluid
  ${path} ${FLTK_INCLUDE_DIR}/fluid
)

#
#  Set FLTK_FOUND
#  This is the final flag that will be checked by
#  other code that requires FLTK for compile/run.
#

IF(FLTK_FLUID_EXECUTABLE)
  IF(FLTK_INCLUDE_DIR)
    IF(FLTK_LIBRARIES)

      # The fact that it is in the cache is deprecated.
      SET (FLTK_FOUND 1 CACHE INTERNAL "FLTK library, headers and Fluid are available")

      # The following deprecated settings are for compatibility with CMake 1.4
      SET (HAS_FLTK ${FLTK_FOUND})
      SET (FLTK_INCLUDE_PATH ${FLTK_INCLUDE_DIR})
      SET (FLTK_FLUID_EXE ${FLTK_FLUID_EXECUTABLE})
      SET (FLTK_LIBRARY ${FLTK_LIBRARIES})
    ENDIF(FLTK_LIBRARIES)
  ENDIF(FLTK_INCLUDE_DIR)
ENDIF(FLTK_FLUID_EXECUTABLE)


IF (FLTK_FLUID_EXECUTABLE)   
  SET ( FLTK_WRAP_UI 1 CACHE INTERNAL "Do we have the fluid executable" )   
ENDIF (FLTK_FLUID_EXECUTABLE) 

MARK_AS_ADVANCED(
  FLTK_VERSION_1.0.11
  FLTK_VERSION_1.1
  FLTK_WRAP_UI
)
