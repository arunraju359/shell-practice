#!/bin/bash

ACION=$1

case $ACTION in
    start)
    echo "\e[35m Startting the service \e[0m"
    ;;
    stop)
    echo "\e[37m Stopping the service \e[0m"
    ;;
    *)
    echo "print valid input"




esac