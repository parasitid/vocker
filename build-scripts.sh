#!/bin/bash
this_path=$(readlink -f $0)        ## Path of this file including filename
dir_name=`dirname ${this_path}`    ## Dir where this file is
myname=`basename ${this_path}`     ## file name of this script.

source ${dir_name}/.envrc

src=${dir_name}/src/scripts
builddir=${dir_name}/build/scripts


mkdir -p $builddir
for s in $(find $src -name "*.sh"); do
    # simple templating system based on perl; replaces {{FOO}} by $FOO
    # env var.'s value if it exists
    cat $s | perl -p -e 's/\{\{[ ]*([^ }]+)[ ]*\}\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' > $builddir/$(basename $s)
done
