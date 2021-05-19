#!/bin/bash

export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
export CUBRID="/home/ilie/workspace/cubrid/inst" #cubrid install folder
export CUBRID_CONF="${CUBRID}/conf/cubrid.conf"
export CUBRID_DATABASES="/home/ilie/workspace/cubrid/db"
export PATH=${CUBRID}/bin:/home/ilie/bin:${PATH}
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CUBRID/lib
