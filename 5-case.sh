#!/bin/bash

ACTION=$1

case $ACTION in
    start)
    echo "\e[0;35m Startting the service \e[0m"
    ;;
    stop)
    echo "\e[0;37m Stopping the service \e[0m"
    ;;
    *)
    echo "print valid input"
    

esac