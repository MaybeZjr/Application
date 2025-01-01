cmake_minimum_required(VERSION 3.23)
project(lerp)

set(CMAKE_CXX_STANDARD 14)

find_package(OpenCV)
include_directories(${OpenCV_INCLUDE_DIRS})

add_executable(lerp lerp_extend.cpp)
target_link_libraries(lerp ${OpenCV_LIBS})