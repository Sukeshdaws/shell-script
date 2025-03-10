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
    if [ $1 -ne 0 ]
then 
echo -e "$2 is.... $R FAILURE $N"
exit 1
else 
echo -e "$2 is... $G SUCCESS $N"

fi

}


if [ $USERID -ne 0 ]

then 
     echo "please run this script with root access."
     exit 1 #manually exit the program

     else
         echo "you are  a super user"

    fi

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing NGINX"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling NGINX"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Staring NGINX"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "Removing Content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip  &>>$LOGFILE
VALIDATE $? "Downloading Frontend Code"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Extracting frontend code" 

#check you repo absoulete path for avoiding errors in the code

cp /home/ec2-user/shell-script/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Copief expense conf"


systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restaring NGINX"






