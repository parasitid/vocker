#!/bin/bash
this_path=$(readlink -f $0)        ## Path of this file including filename
dir_name=`dirname ${this_path}`    ## Dir where this file is
myname=`basename ${this_path}`     ## file name of this script.
oldpath=$(readlink -f $PWD)

source ${dir_name}/.envrc

src=${dir_name}/src/docker
builddir=${dir_name}/build

IMAGENAME=$1

if [ ! -d $builddir ]; then 
    mkdir -p $builddir
fi

# simple templating system based on perl; replaces {{FOO}} by $FOO
# env var.'s value if it exists
cat $src/Dockerfile | perl -p -e 's/\{\{[ ]*([^ }]+)[ ]*\}\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' > $builddir/Dockerfile

cd $builddir
docker build -t $IMAGENAME --rm=true .
cd $oldpath

