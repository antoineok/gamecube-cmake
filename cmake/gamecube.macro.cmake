# Set up a GameCube target
# Add the definition for the libogc headers
function(setup_gamecube_target target_name libogc_libs)

    setup_libogc("${target_name}" "${libogc_libs}" "cube")

    # Setup linker and compiler flags
    set(arch_flags "-DGEKKO -mogc -mcpu=750 -meabi -mhard-float")
    set_target_properties(${target_name} PROPERTIES
            LINK_FLAGS "${arch_flags}"
            COMPILE_FLAGS "${arch_flags}")

endfunction(setup_gamecube_target)

# Set up a Wii target
# Add the definition for the libogc headers
function(setup_wii_target target_name libogc_libs)

    setup_libogc("${target_name}" "${libogc_libs}" "wii")

    # Setup linker and compiler flags
    set(arch_flags "-DGEKKO -mrvl -mcpu=750 -meabi -mhard-float")
    set_target_properties(${target_name} PROPERTIES
            LINK_FLAGS "${arch_flags}"
            COMPILE_FLAGS "${arch_flags}")

endfunction(setup_wii_target)

# Used to set information for GameCube targets
function(setup_libogc target_name libogc_libs path_suffixes)

    # Uncomment the following line for debugging find_library
    #set(CMAKE_FIND_DEBUG_MODE 1)

    # Link all libogc libraries
    set(CMAKE_FIND_LIBRARY_PREFIXES lib)
    set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
    foreach(libogc_lib ${libogc_libs})
        if(NOT DEFINED LIBOGC_${libogc_lib})
            message(STATUS "Looking for libogc's ${libogc_lib}")
            find_library(LIBOGC_${libogc_lib} ${libogc_lib} PATH_SUFFIXES ${path_suffixes})
            if(LIBOGC_${libogc_lib})
                message(STATUS "    Found -- ${LIBOGC_${libogc_lib}}")
            else()
                message(FATAL_ERROR "    Could not find ${libogc_lib}")
            endif()
        endif()

        target_link_libraries(${target_name} ${LIBOGC_${libogc_lib}})
    endforeach(libogc_lib)

endfunction(setup_libogc)


