#!/bin/bash
ID=$(id -u)
if ["$ID" -ne 0]; then
    echo -e "\e[32m You need to perform the operation as a root user \e[0m"
    exit 1
fi
yum install httpd &> /tmp/stack.logs
if [$? -eq 0]; then
    echo "Success"
else
    echo "Failure"
fi