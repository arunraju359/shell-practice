#!/bin/bash
fun()
{
    echo "Hi this is sample function program 1"
    sleep 2
    echo "Hi this is sample function program 2"
    sleep 2
    echo "Hi this is sample function program 3"
    sleep 2
    echo "Hi this is sample function program 4"
}

stat(){
    echo "The load average is : $(uptime | awk -F : '{print $2}')"
}

stat
fun
