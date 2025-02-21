#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAM.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
if ( $1 -ne 0)
then
     echo -e " $2 is....$R FAILURE $N"
     exit 1

else
    echo -e "$2 is...$G SUCCESS $N"

fi     

}

if [ $USERID -ne 0]
then
    echo "run this script with root access"
    exit 1

 else
    echo  "you are a super user"

    dnf install mysql-server -y &>>$LOGFILE
    VALIDATE $? "Installing MYSQL Server"

    systemctl enable mysqld &>>LOGFILE
    VALIDATE $? "Enabling MYSQL Server"

    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>LOGFILE
    VALIDATE $? "Setting up root password"

