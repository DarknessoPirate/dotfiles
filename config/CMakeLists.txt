cmake_minimum_required(VERSION 3.31)
# sets the name of the project
project(the_project_name) # stores the project name in the PROJECT_NAME variable

set(CMAKE_CXX_STANDARD 17) # cpp standard definition used in project
set(CMAKE_CXX_STANDARD_REQUIRED True) # whether the CXX_STANDARD above is required to compile the project properly
# export compile commands for clangd
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


# define paths to folders
set(INCLUDE_DIR "${CMAKE_SOURCE_DIR}/include")
set(BUILD_DIR "${CMAKE_SOURCE_DIR}/build")
set(BIN_DIR "${CMAKE_SOURCE_DIR}/bin")
set(SRC_DIR "${CMAKE_SOURCE_DIR}/src")

# set where executables appear when built
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BIN_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${BIN_DIR}/debug)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${BIN_DIR}/release)

# create directories
file(MAKE_DIRECTORY ${INCLUDE_DIR})
# cmake -B build to create build when running cmake
file(MAKE_DIRECTORY ${BIN_DIR})
file(MAKE_DIRECTORY ${SRC_DIR})

find_package(OpenGL REQUIRED)
find_package(glfw3 REQUIRED)

# Automatically collects source files
file(GLOB_RECURSE CPP_SOURCES "${SRC_DIR}/*.cpp")    
file(GLOB_RECURSE C_SOURCES "${SRC_DIR}/*.c")

# combine all sources
set(ALL_SOURCES ${CPP_SOURCES} ${C_SOURCES})

add_executable(${PROJECT_NAME} ${ALL_SOURCES})

target_include_directories(${PROJECT_NAME} PRIVATE 
    ${INCLUDE_DIR}
    ${OPENGL_INCLUDE_DIRS}
)


target_link_libraries(${PROJECT_NAME} 
    glfw
    ${OPENGL_LIBRARIES}
    ${CMAKE_DL_LIBS}  # required for GLAD on Linux
)

target_compile_options(${PROJECT_NAME} PRIVATE
    -Wall -Wextra 
    $<$<CONFIG:Debug>:-g -O0>
    $<$<CONFIG:Release>:-O3>
)
