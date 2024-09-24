project(demo_complex)

add_subdirectory(lib1)
add_subdirectory(lib2)

add_executable(${PROJECT_NAME} main.cpp)
target_include_directories(
    ${PROJECT_NAME} 
    PUBLIC 
    ${LIB1_DIR}
    ${LIB2_DIR}
)
target_link_libraries(
    ${PROJECT_NAME} 
    PUBLIC
    lib1 
    lib2
)