#!/bin/bash
ID=$(id -u)
if [ "$ID" -ne 0 ]; then
    echo -e "\e[31m You need to perform the operation as a root user \e[0m"
    exit 1
fi
stat()
{
    if [ $1 -eq 0 ]; then
    echo -e "\e[32m Success \e[0m"
    else
    echo -e "\e[31m Failure \e[0m"
fi

}
echo -n "Installing Httpd : "
yum install httpd &> /tmp/stack.logs
stat $?

echo -n "Update the reverse Proxy Congiguration : "
echo 'ProxyPass "/student" "http://APP-SERVER-IPADDRESS:8080/student"
ProxyPassReverse "/student"  "http://APP-SERVER-IPADDRESS:8080/student"' > /etc/httpd/conf.d/proxy.conf
stat $?

echo -n "Downloading the index.html file : " 
curl -s https://devops-cloudcareers.s3.ap-south-1.amazonaws.com/index.html -o /var/www/html/index.html &>> /tmp/stack.logs
stat $?

echo -n "Starting the HTTPD service : "
systemctl enable httpd
systemctl start httpd
stat $?

echo -n "Installing Java : "
yum install java >>& /tmp/stack.logs
stat $?

