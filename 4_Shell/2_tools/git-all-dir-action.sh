#!/bin/bash

action=$1

for d in $(ls); do
    if [ ! -d $d ]; then
        continue
    fi
    echo ""
    echo "#########" $(pwd)/$d
    cd $d
    git $action
    cd - > /dev/null
done
