#!/bin/bash

export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
export ARNIADB="/home/ilie/workspace/cubrid/inst" #cubrid install folder
export ARNIADB_CONF="${ARNIADB}/conf/cubrid.conf"
export ARNIADB_DATABASES="/home/ilie/workspace/cubrid/db"
export PATH=${ARNIADB}/bin:/home/ilie/bin:${PATH}
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ARNIADB/lib


