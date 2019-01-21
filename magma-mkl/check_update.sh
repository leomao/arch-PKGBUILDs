#! /bin/bash

check_url='http://icl.cs.utk.edu/projectsfiles/magma/downloads/?C=M;O=D'
latest_ver=`curl $check_url 2> /dev/null | sed -n 's|.*"magma-\(.*\)\.tar\.gz".*|\1|p' | head -n 1`
echo $latest_ver
