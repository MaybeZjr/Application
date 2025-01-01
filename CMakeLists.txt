cmake_minimum_required(VERSION 3.23)
project(CropPictureIntoPieces)

set(CMAKE_CXX_STANDARD 14)

find_package(OpenCV)
include_directories(${OpenCV_INCLUDE_DIRS})

add_executable(CropPictureIntoPieces main.cpp)
target_link_libraries(CropPictureIntoPieces ${OpenCV_LIBS})