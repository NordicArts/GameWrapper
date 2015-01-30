#!/bin/bash

usage(){
cat << EOF
usage: $0 options

This script cleans based on what type

OPTIONS:
    -h  Shows this message
    -t  Type of cleaning, can be all or cmake
EOF
}

deleteCMake()
{
    rm -rf `find . -type d -name CMakeFiles`    
#    rm -rf `find . -type d -name build`
    rm -rf `find . -type f -name CMakeCache.txt`
    rm -rf `find . -type f -name Makefile`
    rm -rf `find . -type f -name cmake_install.cmake`
    rm -rf `find . -type f -name CPackConfig.cmake`
    rm -rf `find . -type f -name CPackSourceConfig.cmake`
}

deleteBuild()
{
    rm -rf Build
}

deleteLibs()
{
    rm -rf `find . -type f -name libGLFW.*`
    rm -rf `find . -type f -name libSQLite.*`
    rm -rf `find . -type f -name libNordicEngine.*`
    rm -rf `find . -type f -name liblua.*`
    rm -rf `find . -type f -name libGame.*`
}

CLEANTYPE=cmake

while getopts ":t:vh?" OPTION
do
    case $OPTION in

        h)
            usage
            exit 1
            ;;
        t)
            CLEANTYPE=$OPTARG
            ;;
        ?)
            usage
            exit
            ;;
    esac
done

if [ $CLEANTYPE == "all" ]
then
    deleteBuild    
    deleteCMake
    deleteLibs
fi


if [ $CLEANTYPE == "cmake" ]
then
    deleteCMake
fi

