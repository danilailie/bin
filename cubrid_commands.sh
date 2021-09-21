#!/bin/bash

function cubrid_config {
    if [ -z "$ARNIADB" ]
    then
        echo "env variable 'ARNIADB' was not found; nothing to do; bailing out ..."
        exit -1
    fi
    
    local build_dir=${ARNIADB}/../build

    if [ -d ${build_dir} ] 
    then
        echo "Build directory exists. Moving on..." 
    else
        echo "Build directory does not exist. Creating..."
        mkdir ${build_dir}
    fi

    pushd ${build_dir}

    CC=gcc-8 CXX=g++-8 cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=${ARNIADB} ../repo

    popd
}

function cubrid_build {
    if [ -z "$ARNIADB" ]
    then
        echo "env variable 'ARNIADB' was not found; nothing to do; bailing out ..."
        exit -1
    fi
    
    declare -i CORE_COUNT=`nproc`
    local build_dir=${ARNIADB}/../build
    pushd ${build_dir}

    cmake --build . -- -j$CORE_COUNT

    popd
}

function cubrid_install {
    if [ -z "$ARNIADB" ]
    then
        echo "env variable 'ARNIADB' was not found; nothing to do; bailing out ..."
        exit -1
    fi

    local build_dir=${ARNIADB}/../build
    pushd ${build_dir}

    cmake --build . --target install

    popd
}

function cubrid_restart {
    if [ -z "$ARNIADB" ]
    then
        echo "env variable 'ARNIADB' was not found; nothing to do; bailing out ..."
        exit -1
    fi
    
    arniadb service stop
    arniadb server stop TEST2
    arniadb deletedb TEST2
    arniadb createdb --db-volume-size=20M --log-volume-size=20M TEST2 en_US
    arniadb server start TEST2
    asql -C -s -u dba TEST2
}
