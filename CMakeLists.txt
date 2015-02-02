# CMake Version
cmake_minimum_required(VERSION 2.8)

# Project Name
project(GameWrapper)
set(OutputName "GameWrapper.app")

# Build Directory
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/Build)

# Apple Boost
if (APPLE)
    link_directories(/usr/local/include)
    include_directories(/usr/local/include)
endif()

# CMake Flags
if (WIN32)
    # C++11
else()    
    if (APPLE)
        # C++11
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++11 --stdlib=libc++ -m64")
        set(EXTRA_FLAGS " -x objective-c++")   
     elseif (UNIX)
        # C++11
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++11 -m64")        
        set(EXTRA_FLAGS "")
    endif()
endif()

# Engine Options
option(NordicEngine_OSOnly "Setting OS Only OFF" OFF)
option(NordicEngine_UnitTests "Setting Unit Tests OFF" OFF)
option(NordicEngine_FullEngine "Setting Full Engine ON" ON)

option(ASSIMP_BUILD_ASSIMP_TOOLS "Settings AssImp Tools OFF" OFF)
option(ASSIMP_BUILD_SAMPLES "Settings AssImp Samples OFF" OFF)
option(ASSIMP_BUILD_TESTS "Setting AssImp Tests OFF" OFF)

option(GLFW_BUILD_EXAMPLES "Setting GLFW Examples OFF" OFF)
option(GLFW_BUILD_TESTS "Setting GLFW Tests OFF" OFF)
option(GLFW_BUILD_DOCS "Settings GLFW Docs OFF" OFF)

# Standard Include
include_directories(${PROJECT_SOURCE_DIR}/GameWrapper)

# Set Source
set(Wrap ${PROJECT_SOURCE_DIR}/GameWrapper)
set(WrapperHeaders ${Wrap}/Main.hpp)
set(WrapperSources ${Wrap}/Main.cpp)

# Standard Includes
list(APPEND GameHeaders ${Wrap}/Includes.hpp)

# Build Number
list(APPEND GameHeaders ${Wrap}/buildNumber.hpp)

# NordicEngine
link_directories(${Wrap}/NordicEngine)
include_directories(${Wrap}/NordicEngine)
add_subdirectory(${Wrap}/NordicEngine)

# Game
link_directories(${Wrap}/Game)
include_directories(${Wrap}/Game)
add_subdirectory(${Wrap}/Game)

# Compile
add_executable(GameWrapper ${WrapperSources} ${WrapperHeaders})
set_target_properties(GameWrapper PROPERTIES LINKER_LANGUAGE CXX)
set_target_properties(GameWrapper PROPERTIES OUTPUT_NAME ${OutputName})

# Link
target_link_libraries(GameWrapper NordicEngine)
target_link_libraries(GameWrapper GameLibrary)
