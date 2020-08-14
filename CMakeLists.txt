cmake_minimum_required(VERSION 3.16.3)

project(rpc_player)

set(CMAKE_C_COMPILER "gcc")
set(CMAKE_CXX_COMPILER "g++")

message(STATUS ${CMAKE_SOURCE_DIR})

set(3RD_GEN_PATH ${CMAKE_BINARY_DIR}/3rd)

# glog
set(3RD_GLOG_SRC_PATH ${CMAKE_SOURCE_DIR}/3rd/glog)
if (NOT EXISTS ${3RD_GLOG_SRC_PATH})
    message(FATAL_ERROR "not find submodule glog, please exe git submodule update")
else ()
    message(STATUS "find glog dir: ${3RD_GLOG_SRC_PATH}")
endif ()
add_custom_target(RPC_GLOG ALL DEPENDS)
add_custom_command(TARGET RPC_GLOG
    PRE_BUILD
    COMMENT "start to compile glog"
    COMMAND mkdir -p ${3RD_GEN_PATH}
    COMMAND cd ${3RD_GLOG_SRC_PATH} && bash autogen.sh && ./configure --prefix=${3RD_GEN_PATH} && make -j && make install
    COMMAND echo "compile glog success"
)

# gflags

file(GLOB_RECURSE TOOL_CPP_FILES "${CMAKE_SOURCE_DIR}/src/tool/*.cc")
message(STATUS ${TOOL_CPP_FILES})

include_directories(${CMAKE_SOURCE_DIR}/include
    ${GFLAGS_INCLUDE_DIRS}
    ${GLOG_INCLUDE_DIRS}
)

add_executable(rplayer
    ${TOOL_CPP_FILES}
)