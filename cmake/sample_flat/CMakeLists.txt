cmake_minimum_required(VERSION 3.20.0)

project(demos)

set(CMAKE_CXX_STANDARD 17)

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/bin)

aux_source_directory(. SRC_LIST)

add_executable(demo ${SRC_LIST})