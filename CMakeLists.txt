cmake_minimum_required(VERSION 3.16.3)

project(rpc_player)

set(CMAKE_C_COMPILER "gcc")
set(CMAKE_CXX_COMPILER "g++")

message(STATUS ${CMAKE_SOURCE_DIR})

set(3RD_GEN_PATH ${CMAKE_BINARY_DIR}/3rd)

# glog
set(3RD_GLOG_SRC_PATH ${CMAKE_SOURCE_DIR}/3rd/glog)
if (NOT EXISTS ${3RD_GLOG_SRC_PATH})
    message(FATAL_ERROR "not find submodule glog, please exe git submodule update --init")
else ()
    message(STATUS "find glog dir: ${3RD_GLOG_SRC_PATH}")
endif ()
add_custom_target(RPC_GLOG ALL DEPENDS)
add_custom_command(TARGET RPC_GLOG
    PRE_BUILD
    COMMENT "start to compile glog"
    COMMAND mkdir -p ${3RD_GEN_PATH}
    COMMAND cd ${3RD_GLOG_SRC_PATH} && bash autogen.sh && ./configure --prefix=${3RD_GEN_PATH} && make -j2 && make install
    COMMAND echo "compile glog success"
)

# gflags
set(3RD_GFLAGS_SRC_PATH ${CMAKE_SOURCE_DIR}/3rd/gflags)
if (NOT EXISTS ${3RD_GFLAGS_SRC_PATH})
    message(FATAL_ERROR "not find submodule gflags, please exe git submodule update")
else ()
    message(STATUS "find gflags dir: ${3RD_GFLAGS_SRC_PATH}")
endif ()
add_custom_target(RPC_GFLAGS ALL DEPENDS)
add_custom_command(TARGET RPC_GFLAGS
    PRE_BUILD
    COMMENT "start to compile gflags"
    COMMAND mkdir -p ${3RD_GEN_PATH}
    COMMAND mkdir -p ${3RD_GFLAGS_SRC_PATH}/build
    COMMAND cd ${3RD_GFLAGS_SRC_PATH}/build && cmake -DCMAKE_INSTALL_PREFIX=${3RD_GEN_PATH} .. && make -j2 && make install
    COMMAND echo "compile gflags success"
)

# protobuf
set(3RD_PROTOBUF_SRC_PATH ${CMAKE_SOURCE_DIR}/3rd/protobuf)
if (NOT EXISTS ${3RD_PROTOBUF_SRC_PATH})
    message(FATAL_ERROR "not find submodule protobuf, please exe: git submodule update")
else ()
    message(STATUS "find protobuf dir: ${3RD_PROTOBUF_SRC_PATH}")
endif ()
add_custom_target(RPC_PROTOBUF ALL DEPENDS)
add_custom_command(TARGET RPC_PROTOBUF
    PRE_BUILD
    COMMENT "start to compile protobuf"
    COMMAND mkdir -p ${3RD_GEN_PATH}
    COMMAND cd ${3RD_PROTOBUF_SRC_PATH} && bash autogen.sh && ./configure --prefix=${3RD_GEN_PATH} && make -j2 && make install
    COMMAND echo "compile protobuf success"
)

# grpc
set(3RD_GRPC_SRC_PATH ${CMAKE_SOURCE_DIR}/3rd/grpc)
if (NOT EXISTS ${3RD_GRPC_SRC_PATH})
    message(FATAL_ERROR "not find submodule grpc, please exe: git submodule update --init")
else ()
    message(STATUS "find grpc dir: ${3RD_GRPC_SRC_PATH}")
endif ()
add_custom_target(RPC_GRPC ALL DEPENDS)
add_custom_command(TARGET RPC_GRPC
    PRE_BUILD
    COMMENT "start to compile grpc"
    COMMAND mkdir -p ${3RD_GEN_PATH} ${3RD_GEN_PATH}/bin ${3RD_GEN_PATH}/include ${3RD_GEN_PATH}/lib ${3RD_GEN_PATH}/share/doc/grpc
    COMMAND cd ${3RD_GRPC_SRC_PATH} && git submodule update --init && make -j2
    COMMAND cd ${3RD_GRPC_SRC_PATH} && cp -r bins/* ${3RD_GEN_PATH}/bin && cp -r include/* ${3RD_GEN_PATH}/include && cp -r libs/opt/* ${3RD_GEN_PATH}/lib && cp -r doc/* ${3RD_GEN_PATH}/share/doc/grpc
    COMMAND echo "compile grpc success"
)


file(GLOB_RECURSE TOOL_CPP_FILES "${CMAKE_SOURCE_DIR}/src/tool/*.cc")

include_directories(${CMAKE_SOURCE_DIR}/include
    ${GFLAGS_INCLUDE_DIRS}
    ${GLOG_INCLUDE_DIRS}
)

add_executable(rplayer
    ${TOOL_CPP_FILES}
)