#!/bin/bash

DEFAULT_LOC="$HOME/.groundzero"
GIT_PULL='git clone https://github.com/NonLogicalDev/GroundZERO'
GIT_INIT1='git submodule init'
GIT_INIT2='git submodule update'

location=''
if [ ! -z  "$1" ]; then
  location=$1
else
  location=$DEFAULT_LOC
fi

mkdir -p $location
pushd $location

$GIT_PULL $location && $GIT_INIT1 && $GIT_INIT2
