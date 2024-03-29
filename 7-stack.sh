#!/bin/bash

set -e

ID=$(id -u)
LOGS=/tmp/stack.logs
APACHE_VERSION="8.5.81"
INDEX_URL="https://devops-cloudcareers.s3.ap-south-1.amazonaws.com/index.html"
FUSER=student
APACHE_TOMCAT="https://dlcdn.apache.org/tomcat/tomcat-8/v$APACHE_VERSION/bin/apache-tomcat-$APACHE_VERSION.tar.gz"
WAR_URL="https://devops-cloudcareers.s3.ap-south-1.amazonaws.com/student.war"
JAR_URL="https://devops-cloudcareers.s3.ap-south-1.amazonaws.com/mysql-connector.jar"
SCHEMA="https://devops-cloudcareers.s3.ap-south-1.amazonaws.com/studentapp-ui-proj.sql"


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
echo 'ProxyPass "/student" "http://172.31.25.19:8080/student"
ProxyPassReverse "/student"  "http://172.31.25.19:8080/student"' > /etc/httpd/conf.d/proxy.conf
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

echo -n "Copying the context file :"
cp context.xml /tmp/context.xml  &>> $LOGS
stat $?


echo -n "Downloading the Tomcat : "
cd /home/$FUSER
wget $APACHE_TOMCAT &>> $LOGS
tar -xf /home/$FUSER/apache-tomcat-$APACHE_VERSION.tar.gz &>> $LOGS
chown -R $FUSER:$FUSER apache-tomcat-$APACHE_VERSION &>> $LOGS
stat $?

echo -n "Download the war file : "
cd apache-tomcat-8.5.81
wget $WAR_URL -o webapps/student.war &>> $LOGS
chown $FUSER:$FUSER webapps/student.war &>> $LOGS
stat $?

echo -n "Download the jar or JDBC connector : "
wget $JAR_URL -o /lib/mysql-connector.jar &>> $LOGS
chown $FUSER:$FUSER /lib/mysql-connector.jar &>> $LOGS
stat $?

echo -n "Download the schema DB : "
wget $SCHEMA -o /tmp/studentapp.sql &>> $LOGS
stat $?

echo -n "Installing & Starting Mariadb: "
yum install mariadb-server -y &>> $LOGS
systemctl enable mariadb  &>> $LOGS
systemctl start  mariadb  &>> $LOGS
stat $?

echo -n "Injecting he schema : "
mysql <  /tmp/studentapp.sql
stat $?

echo -n "Injecting the context file : "
sed  -i  -e "s/DUMMYUSER/$1/" -e "s/DUMMYPASSWORD/$2/" /tmp/context.xml
cp /tmp/context.xml conf/context.xml
stat $?

echo -n "Starting Tomcat: "
sh bin/startup.sh  &>> $LOGS
stat $?

echo -n "Checking Application Availability : "
sleep 5
curl localhost:8080/$FUSER &>> $LOGS
if [ $? -eq 0 ]; then 
   echo -e "\e[32m AVailable \e[0m" 
else 
   echo -e "\e[31m Not yet available. Please check the catalina logs \e[0m" 
   stat $?
fi 
echo -e " ********************************* \e[32m $FUSER Stack Completed \e[0m ********************************* "










