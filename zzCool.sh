#!/bin/bash
function zz_priv_source_script() {
  if [ -f $1 ]; then
    source $1
    echo "INFO: loaded '$1'"
  else
    echo "ERROR: could not load '$1'"
    return -1
  fi
}

function zz_priv_provision_dir() {
  if [ -z "$CUBRID" ]; then
    echo "ERROR: env variable 'CUBRID' was not found; nothing to do; bailing out ..."
    return -1
  fi
  DIR_CANONICAL=`readlink -m $1`
  if [ ! -d $DIR_CANONICAL ]
  then
    mkdir -p $DIR_CANONICAL
    echo "INFO: zz_priv_provision_dir: created directory '$DIR_CANONICAL'"
  else
    echo "INFO: zz_priv_provision_dir: directory '$DIR_CANONICAL' found"
  fi
}

function zzbuild() {
  if [ -z "$CUBRID" ]
  then
    echo "ERROR: env variable 'CUBRID' was not found; nothing to do; bailing out ..."
    return -1
  fi
  declare -i CORE_COUNT=`nproc`-1
  BUILD_DIR=${CUBRID}/../build
  BUILD_DIR_CANONICAL=`readlink -m $BUILD_DIR`
  zz_priv_provision_dir $BUILD_DIR_CANONICAL
  pushd ${BUILD_DIR_CANONICAL}
  cmake --build . -- -j$CORE_COUNT
  popd
}

function zzclean {
  if [ -z "$CUBRID" ]
  then
    echo "ERROR: env variable 'CUBRID' was not found; nothing to do; bailing out ..."
    return -1
  fi
  BUILD_DIR=${CUBRID}/../build
  BUILD_DIR_CANONICAL=`readlink -m $BUILD_DIR`
  zz_priv_provision_dir $BUILD_DIR_CANONICAL
  pushd ${BUILD_DIR_CANONICAL}
  cmake --build . --target clean
  popd
}

function zzrebuild {
  zzclean
  zzbuild
}

function zzinstall {
    if [ -z "$CUBRID" ]
    then
        echo "ERROR: env variable 'CUBRID' was not found; nothing to do; bailing out ..."
        return -1
    fi
    INST_DIR=${CUBRID}/../inst
    INST_DIR_CANONICAL=`readlink -m $INST_DIR`
    zz_priv_provision_dir $INST_DIR_CANONICAL
    pushd ${CUBRID}/../build
    cmake --build . --target install -j
    popd
}


# function zz_umount() {
#   #sudo umount -f /home/cristian/code/jupiter
#   #sudo umount -f /home/cristian/code/venus 
#   fusermount -z -u /home/cristian/code/jupiter
#   fusermount -z -u /home/cristian/code/venus
# }
# function zz_mount() {
#   # reconnect
#   sshfs arnia@jupiter:/ ~/code/jupiter -o ConnectTimeout=3,ConnectionAttempts=1,ServerAliveInterval=5,ServerAliveCountMax=3
#   #echo "INFO: result of 'sshfs arnia@jupiter:/ ~/code/jupiter' is = $?"
#   sshfs arnia@venus:/ ~/code/venus -o ConnectTimeout=3,ConnectionAttempts=1,ServerAliveInterval=5,ServerAliveCountMax=3
#   #echo "INFO: result of 'sshfs arnia@venus:/ ~/code/venus' is = $?"
#   #while true
#   #do
#   #  sshfs -f -o ConnectTimeout=3,ConnectionAttempts=1,ServerAliveInterval=5,ServerAliveCountMax=3 $@
#   #  echo "disconnected from $@"
#   #  sleep 3
#   #  echo "retry $@ ..."
#   #done
# }
# function zz_priv_remount() {
#   # NOTE: this function relies on the fact that the client is key-authorized with the remote servers
#   local server_name=$1
#   local base_mount_point="$HOME/code"
#   local mount_point="$base_mount_point/$server_name"
#   local ls_result=`ls ${mount_point}`
#   local ls_return_code=$?
#   #echo "server_name=$server_name"
#   #echo "mount_point=$mount_point"
#   #echo "ls_result=$ls_result"
#   #echo "ls_return_code=$ls_return_code"
#   # do not rely on ls return code as it will actually be the return code of assigning the result to the variable right above
#   # instead rely on the result contents
#   if [ $? -eq 0 ]; then
#     if [ -z "$ls_result" ]; then
#       #echo "EMPTY $mount_point"
#       #echo "fusermount -z -u ${mount_point}"
#       #echo "sshfs arnia@${server_name}:/ ${mount_point} -o ConnectTimeout=3,ConnectionAttempts=1,ServerAliveInterval=5,ServerAliveCountMax=3"
#       fusermount -z -u ${mount_point}
#       sshfs arnia@${server_name}:/ ${mount_point} -o ConnectTimeout=3,ConnectionAttempts=1,ServerAliveInterval=5,ServerAliveCountMax=3
#     #else
#     #  echo "OK $mount_point - nothing to do"
#     fi
#   #else
#   #  echo "MUST RECONNECT $mount_point" 
#   fi
# }
# function zz_remount() {
#   zz_priv_remount venus
#   zz_priv_remount jupiter
# }
# function zzcreatedb {
#     if [ -z "$CUBRID_DATABASES" ]
#     then
#         echo "ERROR: env variable 'CUBRID_DATABASES' was not found; nothing to do; bailing out ..."
#         return -1
#     fi
#     if [ -z "$1" ]
#     then
#         echo "ERROR: a database name was not supplied; nothing to do; bailing out ..."
#         return -1
#     fi
#     echo "INFO: making sure directory '$CUBRID_DATABASES/$1' is present"
#     mkdir -p $CUBRID_DATABASES/$1
#     database_file_size=$2
#     [[ -z $database_file_size ]] && database_file_size=50M
#     local params="--db-volume-size=$database_file_size --log-volume-size=$database_file_size --file-path=$CUBRID_DATABASES/${1}"
#     echo "INFO: parameters for database '${1}': ${params}"
#     #cubrid createdb --verbose --db-volume-size=$database_file_size --log-volume-size=$database_file_size --file-path=$CUBRID_DATABASES/${1} ${1} en_US 
#     cubrid createdb --verbose ${params} ${1} en_US 
#     # en_US.utf8
# }
# 

function zz_priv_provision_dir() {
  if [ -z "$CUBRID" ]; then
    echo "env variable 'CUBRID' was not found; nothing to do; bailing out ..."
    exit -1
  fi
  DIR_CANONICAL=`readlink -m $1`
  echo DIR_CANONICAL=$DIR_CANONICAL
  if [ ! -d $DIR_CANONICAL ]
  then
    mkdir -p $DIR_CANONICAL
    echo "created directory '$DIR_CANONICAL'"
  fi
}

function zzconfig {
  if [ -z "$CUBRID" ]
  then
      echo "env variable 'CUBRID' was not found; nothing to do; bailing out ..."
      exit -1
  fi
  local build_dir=${CUBRID}/../build
  local build_dir_canonical=`readlink -m $build_dir`
  local cmake_options_general="-DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=${INST_DIR} -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF -DVERBOSE:BOOL=OFF"
  local cmake_options_specific="-DWITH_JDBC=ON -DUNIT_TESTS:BOOL=ON"
  # -DUNIT_TEST_REQUEST_CS:BOOL=OFF
  zz_priv_provision_dir $build_dir_canonical
  INST_DIR=${CUBRID}/../inst
  pushd ${build_dir_canonical}
  echo cmake_options_general=$cmake_options_general
  echo cmake_options_specific=$cmake_options_specific
  CC=gcc-8 CXX=g++-8 cmake -G "Unix Makefiles" ${cmake_options_general} ${cmake_options_specific} ../repo
  popd
}
