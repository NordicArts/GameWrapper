#!/bin/bash
oldCC=$CC
oldCXX=$CXX

# Set the compiler to clang
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

usage()
{
cat << EOF
usage: $0 options

This script can build, clean, and grab new versions,
    Rebuild = Clean and Build
    Pull = Clean, Pull Dependencies and Build

OPTIONS:
    -h  Show this message
    -v  Verbose
    -o  Option, can be 'run', 'rebuild', 'run' or 'pull' [default: run]
EOF
}

makeIt()
{
    beLoud=$1
    
    if [[ $beLoud == 1 ]]; then
        cmake .
        make
    else
        cmake . >> /dev/null
        make >> /dev/null
    fi
}

pullCode()
{
    beLoud=$1

    if [[ $beLoud == 1 ]]; then
        git submodule init
        git submodule update --recursive
        git submodule foreach git pull origin master --recurse-submodules
    else
        git submodule init >> /dev/null
        git submodule update --recursive >> /dev/null
        git submodule foreach git pull origin master --recurse-submodules >> /dev/null
    fi
}

OPT="run"
VERBOSE=false
PULL=false

while getopts ":o:vhp?" OPTION
do
    case $OPTION in
        o)
            OPT=$OPTARG
            ;;
        p)
            PULL=1
            ;;
        h)
            usage
            exit 1
            ;; 
        v)
            VERBOSE=1
            ;;
    esac
done

# Clear window
clear

if [[ $PULL == 1 ]]; then
    pullCode $VERBOSE
fi

if [[ $OPT == "build" ]]; then
    makeIt $VERBOSE

    ./cleaner.sh -t cmake
fi

if [[ $OPT == "rebuild" ]]; then
    ./cleaner.sh -t all

    makeIt $VERBOSE

    ./cleaner.sh -t cmake
fi

if [[ $OPT == "run" ]]; then
    ./cleaner.sh -t all

    makeIt $VERBOSE

    ./cleaner.sh -t cmake
        
    cd Build
    cp -r ../GameFiles .
    ./GameWrapper.app
fi

export CC=$oldCC
export CXX=$oldCXX
