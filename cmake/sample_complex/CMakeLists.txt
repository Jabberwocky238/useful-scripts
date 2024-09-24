cmake_minimum_required(VERSION 3.20.0)

project(
    demos   
    VERSION 1.0.0
    DESCRIPTION "666666"
    HOMEPAGE_URL "http://github.com/jabberwocky238/useful-scripts"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)
# CMAKE_LIBRARY_OUTPUT_DIRECTORY
# CMAKE_ARCHIVE_OUTPUT_DIRECTORY
set(LIB1_DIR ${CMAKE_SOURCE_DIR}/src/lib1)
set(LIB2_DIR ${CMAKE_SOURCE_DIR}/src/lib2)

add_subdirectory(src)

aux_source_directory(${CMAKE_SOURCE_DIR}/src SRC_LIST)
add_library(demo_lib SHARED ${SRC_LIST})
target_include_directories(demo_lib PUBLIC ${CMAKE_SOURCE_DIR}/include)

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/bin)
add_executable(demo main.cpp)
target_include_directories(demo PUBLIC ${CMAKE_SOURCE_DIR}/include)
target_link_libraries(demo PUBLIC demo_lib)