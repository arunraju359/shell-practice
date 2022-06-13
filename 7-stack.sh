#!/bin/bash
ID=$(id -u)
LOGS=/tmp/stack.logs
INDEX_URL="https://devops-cloudcareers.s3.ap-south-1.amazonaws.com/index.html"
FUSER=student
APACHE_TOMCAT="https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.77/bin/apache-tomcat-8.5.77.tar.gz"


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
yum install httpd &> $LOGS
stat $?

echo -n "Update the reverse Proxy Congiguration : "
echo 'ProxyPass "/student" "http://APP-SERVER-IPADDRESS:8080/student"
ProxyPassReverse "/student"  "http://APP-SERVER-IPADDRESS:8080/student"' > /etc/httpd/conf.d/proxy.conf
stat $?

echo -n "Downloading the index.html file : " 
curl -s $INDEX_URL -o /var/www/html/index.html &>> $LOGS
stat $?

echo -n "Starting the HTTPD service : "
systemctl enable httpd
systemctl start httpd
stat $?

echo -n "Installing Java : "
yum install java &>> $LOGS
stat $?

echo -n "Creating the functional user : "
id $FUSER &>> $LOGS
if [ $? -eq 0 ]; then 
   echo -e "\e[33m Skipping \e[0m" 
else 
   useradd $FUSER &>> $LOGS
   stat $?
fi 

echo -n "Downloading the Tomcat"
cd /home/$FUSER
wget $APACHE_TOMCAT 
tar -xf /home/$FUSER/apache-tomcat-8.5.77.tar.gz &>> $LOGS
chown -R $FUSER:$FUSER apache-tomcat-8.5.77
stat $?




