# CMake Version
cmake_minimum_required(VERSION 2.8)

# Project Name
project(Valkyrie)

# C++11
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++11 -m64")

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
include_directories(${PROJECT_SOURCE_DIR}/Valkyrie)

# Set Source
set(Game ${PROJECT_SOURCE_DIR}/Valkyrie)
set(GameHeaders ${Game}/Main.hpp)
set(GameSources ${Game}/Main.cpp)

# Standard Includes
list(APPEND GameHeaders ${Game}/Includes.hpp)

# NordicEngine
link_directories(${Game}/NordicEngine)
include_directories(${Game}/NordicEngine)
add_subdirectory(${Game}/NordicEngine)

# Game
link_directories(${Game}/Game)
include_directories(${Game}/Game)
add_subdirectory(${Game}/Game)

# Compile
add_executable(Valkyrie ${GameSources} ${GameHeaders})
set_target_properties(Valkyrie PROPERTIES LINKER_LANGUAGE CXX)
set_target_properties(Valkyrie PROPERTIES OUTPUT_NAME "Valkyrie.app")

# Link
target_link_libraries(Valkyrie NordicEngine)
target_link_libraries(Valkyrie GameLib)
