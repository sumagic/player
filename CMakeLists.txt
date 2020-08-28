cmake_minimum_required(VERSION 3.16.3)

project(player)

SET(CMAKE_SYSTEM_NAME Linux)

set(CMAKE_C_COMPILER "aarch64-linux-gnu-gcc")
set(CMAKE_CXX_COMPILER "aarch64-linux-gnu-cpp")

message(STATUS ${CMAKE_SOURCE_DIR})


file(GLOB_RECURSE TOOL_CPP_FILES "${CMAKE_SOURCE_DIR}/src/tool/*.cc")

include_directories(${CMAKE_SOURCE_DIR}/include
    ${GFLAGS_INCLUDE_DIRS}
    ${GLOG_INCLUDE_DIRS}
)

add_executable(player
    ${TOOL_CPP_FILES}
)

add_executable(layer
    ${TOOL_CPP_FILES}
)