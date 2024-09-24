project(demo_complex_lib1)

add_library(
    ${PROJECT_NAME} 
    SHARED
    lib1.cpp
)

target_include_directories(
    ${PROJECT_NAME}
    PUBLIC
    ${LIB2_DIR}
)
target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE
    demo_complex_lib2
)

