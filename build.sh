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
    -n  No Clean
    -g  Game Name
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

# Build Number
buildNumber()
{
    buildName=$1    
    beLoud=$2

    # Text file
    awk -F, '{$1=$1+1}1' OFS= buildNumber.txt > buildNumberNew.txt && mv buildNumberNew.txt buildNumber.txt

    # Get the result
    buildNumber=$(cat buildNumber.txt)

    # Build the header
    l1="#ifndef NORDICARTS_"
    l1+=$buildName
    l1+="_BUILDNUMBER"

    l2="#define NORDICARTS_"
    l2+=$buildName
    l2+="_BUILDNUMBER "
    l2+=$buildNumber

    l3="#endif"

    echo -e $l1 > $buildName/buildNumber.hpp
    echo -e $l2 >> $buildName/buildNumber.hpp
    echo -e $l3 >> $buildName/buildNumber.hpp
}

OPT="run"
VERBOSE=false
PULL=false
CLEAN=1

while getopts ":o:vhnp?" OPTION
do
    case $OPTION in
        o)
            OPT=$OPTARG
            ;;
        n)
            CLEAN=false
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

    buildNumber "GameWrapper" $VERBOSE
    makeIt $VERBOSE

    if [[ $CLEAN == 1 ]]; then
        ./cleaner.sh -t cmake
    fi
fi

if [[ $OPT == "rebuild" ]]; then
    if [[ $CLEAN == 1 ]]; then
        ./cleaner.sh -t all
    fi

    buildNumber "GameWrapper" $VERBOSE
    makeIt $VERBOSE

    if [[ $CLEAN == 1 ]]; then
        ./cleaner.sh -t cmake
    fi
fi

if [[ $OPT == "run" ]]; then
    if [[ $CLEAN == 1 ]]; then
        ./cleaner.sh -t all
    fi

    buildNumber "GameWrapper" $VERBOSE
    makeIt $VERBOSE

    if [[ $CLEAN == 1 ]]; then
        ./cleaner.sh -t cmake
    fi
        
    cd Build
    cp -r ../GameFiles .
    ./GameWrapper.app
fi

export CC=$oldCC
export CXX=$oldCXX
