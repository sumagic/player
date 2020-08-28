#!/bin/bash

DATA_PRE=$(date +%Y-%m-%d-%H-%M)

log_info ()
{
    [ $# == 0 ] && echo "log_info should have args"
    echo "[INFO] [${DATA_PRE}] ["${1}"]"
}

log_error ()
{
    [ $# == 0 ] && echo "log_error should have args"
    echo "[ERROR] [${DATA_PRE}] ["${1}"]"
}

# export environment
export PLAYER_ROOT=$PWD
export THIRDPARTY_DIR=${PLAYER_ROOT}/3rd
export BUILD_PATH=${PLAYER_ROOT}/build
export INSTALL_PATH=${BUILD_PATH}/install
export INSTALL_BIN_PATH=${INSTALL_PATH}/bin
export INSTALL_INCLUDE_PATH=${INSTALL_PATH}/include
export INSTALL_LIB_PATH=${INSTALL_PATH}/lib

# print environment
log_info "PLAYER_ROOT=${PLAYER_ROOT}"

# Environment Init
[ ! -d ${BUILD_PATH} ] && mkdir -p ${BUILD_PATH}
[ ! -d ${INSTALL_PATH} ] && mkdir -p ${INSTALL_PATH}
[ ! -d ${INSTALL_BIN_PATH} ] && mkdir -p ${INSTALL_BIN_PATH}
[ ! -d ${INSTALL_INCLUDE_PATH} ] && mkdir -p ${INSTALL_INCLUDE_PATH}
[ ! -d ${INSTALL_LIB_PATH} ] && mkdir -p ${INSTALL_LIB_PATH}

cd ${THIRDPARTY_DIR}
git clone https://github.com/grpc/grpc.git
git clone https://github.com/protocolbuffers/protobuf.git
git clone https://github.com/google/glog.git
git clone https://github.com/gflags/gflags.git
git clone https://github.com/nlohmann/json.git

git submodule update --init

# glog compile
log_info "start to compile glog"
GLOG_SRC_PATH=${THIRDPARTY_DIR}/glog
GLOG_BUILD_PATH=${BUILD_PATH}/glog
cd ${GLOG_SRC_PATH} && git submodule update --init
cd ${GLOG_SRC_PATH} && bash autogen.sh
[ ! -d ${GLOG_BUILD_PATH} ] && mkdir -p ${GLOG_BUILD_PATH}
cd ${GLOG_BUILD_PATH} && ${GLOG_SRC_PATH}/configure --prefix=${INSTALL_PATH} && make -j2 && make install
log_info "compile glog success"

# gflags compile
log_info "start to compile gflags"
GFLAGS_SRC_PATH=${THIRDPARTY_DIR}/gflags
GFLAGS_BUILD_PATH=${BUILD_PATH}/gflags
cd ${GFLAGS_SRC_PATH} && git submodule update --init
cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH} ${GFLAGS_SRC_PATH} && make -j2
log_info "compile gflags success"


# # protobuf compile
log_info "start to compile protobuf"
PROTOBUF_SRC_PATH=${THIRDPARTY_DIR}/protobuf
PROTOBUF_BUILD_PATH=${BUILD_PATH}/protobuf
cd ${PROTOBUF_SRC_PATH} && git submodule update --init
[ ! -d ${PROTOBUF_BUILD_PATH} ] && mkdir -p ${PROTOBUF_BUILD_PATH}
cd ${PROTOBUF_SRC_PATH} && bash autogen.sh
cd ${PROTOBUF_BUILD_PATH} && ${PROTOBUF_SRC_PATH}/configure --prefix=${INSTALL_PATH} && make -j2 && make install
log_info "compile protobuf success"

# compile grpc
log_info "start to compile grpc"
GRPC_SRC_PATH=${THIRDPARTY_DIR}/grpc
GRPC_BUILD_PATH=${BUILD_PATH}/grpc
git submodule update --init --recursive
[ ! -d ${GRPC_SRC_PATH} ] && git submodule update --init
[ ! -d ${GRPC_BUILD_PATH} ] && mkdir -p ${GRPC_BUILD_PATH}
cd ${GRPC_SRC_PATH} && make -j2
cp -r ${GRPC_SRC_PATH}/bins/* ${INSTALL_BIN_PATH}
cp -r ${GRPC_SRC_PATH}/include/* ${INSTALL_INCLUDE_PATH}
cp -r ${GRPC_SRC_PATH}/libs/opt/* ${INSTALL_LIB_PATH}
log_info "compile grpc success"








