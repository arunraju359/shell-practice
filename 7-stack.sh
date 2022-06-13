#!/bin/bash
ID=$(id -u)
if [ "$ID" -ne 0 ]; then
    echo -e "\e[31m You need to perform the operation as a root user \e[0m"
    exit 1
fi
echo -n "Installing Httpd : "
yum install httpd &> /tmp/stack.logs
if [ $? -eq 0 ]; then
    echo -e "\e[32m Success [0m"
else
    echo -e "\e[31m Failure [0m"
fi