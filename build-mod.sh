#!/bin/bash

this_path=$(readlink -f $0)        ## Path of this file including filename
dir_name=`dirname ${this_path}`    ## Dir where this file is
myname=`basename ${this_path}`     ## file name of this script.

source ${dir_name}/.envrc

src=${dir_name}/src/mod
builddir=${dir_name}/build

OLDDIR=$(pwd)
cd $dir_name

_exit(){
    cd $OLDDIR
    exit $1
}

modname=$1
output=$builddir/$modname.zip
src=$dir_name/src/mod

# if no VERTX_HOME is defined, try a guess with a gvm install
if [ "$VERTX_HOME" == "" ]; then 
    VERTX_HOME="~/.gvm/vertx/${VERTX_VERSION:-current}"
fi

if [ ! -x $VERTX_HOME/bin/vertx ]; then
    echo "can't find any vertx ${VERTX_VERSION} binary. exiting."
    _exit 1
else
    VERTX=$VERTX_HOME/bin/vertx
    VERTX_VERSION=$( $VERTX version 2>&1 | awk '{print $1}')
fi

if [ -d $src ] && [ -f $src/mod.json ]; then
    #clean old temp build dir in case of
    if [ -d $builddir/mod ]; then 
        rm -Rf $builddir/mod
    fi

    mkdir -p $builddir/mod/mods/$modname
    cp -Rf src/mod/* $builddir/mod/mods/$modname/
    cd $builddir/mod
    echo "pulling vertx dependencies..."
    $VERTX pulldeps $modname
    if [ $? -eq 0 ]; then 
        cd ./mods/$modname
        zip -r $output *
    else
        echo "could not pulldeps. exiting leaving build dir for diag."
        _exit 2
    fi
    
    #clean temp build dir.
    rm -Rf $builddir/mod
fi

