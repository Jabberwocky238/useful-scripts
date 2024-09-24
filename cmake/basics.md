# 基础使用

+ 指定cmake的最低版本
```cmake
cmake_minimum_required(VERSION 3.20.0)
```

+ 指定项目名称
```cmake
project(demos)
```

+ 指定C++标准
```cmake
set(CMAKE_CXX_STANDARD 17)
```

+ 添加头文件搜索路径
```cmake
include_directories(${CMAKE_SOURCE_DIR}/include)
```

+ 指定可执行文件输出路径
```cmake
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/bin)
```

+ 指定库文件输出路径
```cmake
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/lib)
```

+ 查找指定目录下的所有源文件
```cmake
aux_source_directory(${CMAKE_SOURCE_DIR}/src SRC_LIST)
```

+ 库链接
```cmake
add_library(${PROJECT_NAME} SHARED lib.cpp)

target_include_directories(${PROJECT_NAME} PUBLIC ${LIB_DIR})
target_link_libraries(${PROJECT_NAME} PRIVATE demo_lib)
```

+ 添加可执行文件
```cmake
add_executable(
    demo 
    ${SRC_LIST}
)
```

+ 未知使用
```cmake
# install(
#     TARGETS
#     ${PROJECT_NAME}
#     LIBRARY DESTINATION lib
#     ARCHIVE DESTINATION lib
#     RUNTIME DESTINATION bin
# )
# install(
#     FILES
#     ${PROJECT_SOURCE_DIR}/include/demo_complex_lib1.h
#     DESTINATION include
# )
```