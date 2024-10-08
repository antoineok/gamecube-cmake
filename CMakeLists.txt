cmake_minimum_required(VERSION 3.20.0)

# Enable new optimized variable evaluation
if(POLICY CMP0053)
    cmake_policy(SET CMP0053 NEW)
endif()

# Enable global GENERATED property
if(POLICY CMP0118)
    cmake_policy(SET CMP0118 NEW)
endif()

# Log active toolchain
message(STATUS "Using toolchain file: ${CMAKE_TOOLCHAIN_FILE}")
message(STATUS "Using C compiler: " ${CMAKE_C_COMPILER})
message(STATUS "Using C++ compiler: " ${CMAKE_CXX_COMPILER})

# PROJECT #
if(NOT DEFINED ENV{PROJECT})
    message(FATAL_ERROR "Please set PROJECT in your environment")
endif()
project("$ENV{PROJECT}" LANGUAGES CXX C ASM)

# Enable the next line to see the actual commands run when building etc.
set(CMAKE_VERBOSE_MAKEFILE ON)

# Set the default search path for modules when using include / find_package
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Set to 1 when target system is Wii
set(WII 0)

# Compiler Flags
set(warning_flags "-Winline -Wall -Wextra")
set(cpp_flags "-fno-rtti -fno-exceptions")
set(debug_flags "-O0 -g -DDEBUG")
set(release_flags "-O3 -fomit-frame-pointer -ffast-math")

set(CMAKE_ASM_FLAGS_DEBUG "${CMAKE_ASM_FLAGS} ${warning_flags} ${debug_flags}")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS} ${warning_flags} ${debug_flags}")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS} ${warning_flags} ${cpp_flags} ${debug_flags}")
set(CMAKE_ASM_FLAGS_RELEASE "${CMAKE_ASM_FLAGS} ${warning_flags} ${release_flags}")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS} ${warning_flags} ${release_flags}")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS} ${warning_flags} ${cpp_flags} ${release_flags}")

# Defines bin2s_library
add_subdirectory(assets)

# Defines gamecube_executable
add_subdirectory(source)
target_link_libraries(gamecube_executable PUBLIC bin2s_library)

# elf2dol - .dol executable
include(devkitpro.elf2dol)
add_dol_target(${PROJECT_NAME} gamecube_executable "FALSE" "source/gamecube_executable") # TODO: Determine approach for parameterizing copy_dol_to_source_dir option
