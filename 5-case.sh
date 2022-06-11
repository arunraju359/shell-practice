#!/bin/bash

ACTION=$1

case $ACTION in
    start)
    echo -e "\e[0;35m Startting the service \e[0m"
    ;;
    stop)
    echo -e "\e[0;34m Stopping the service \e[0m"
    ;;
    *)
    echo "print valid input"
    

esac