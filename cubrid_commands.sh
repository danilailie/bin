#!/bin/bash

function cubrid_config {
    if [ -z "$CUBRID" ]
    then
        echo "env variable 'CUBRID' was not found; nothing to do; bailing out ..."
        exit -1
    fi
    
    local build_dir=${CUBRID}/../build

    if [ -d ${build_dir} ] 
    then
        echo "Build directory exists. Moving on..." 
    else
        echo "Build directory does not exist. Creating..."
        mkdir ${build_dir}
    fi

    pushd ${build_dir}

    CC=gcc-8 CXX=g++-8 cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=${CUBRID} ../repo

    popd
}

function cubrid_build {
    if [ -z "$CUBRID" ]
    then
        echo "env variable 'CUBRID' was not found; nothing to do; bailing out ..."
        exit -1
    fi
    
    declare -i CORE_COUNT=`nproc`
    local build_dir=${CUBRID}/../build
    pushd ${build_dir}

    cmake --build . -- -j$CORE_COUNT

    popd
}

function cubrid_install {
    if [ -z "$CUBRID" ]
    then
        echo "env variable 'CUBRID' was not found; nothing to do; bailing out ..."
        exit -1
    fi

    local build_dir=${CUBRID}/../build
    pushd ${build_dir}

    cmake --build . --target install

    popd
}