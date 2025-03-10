#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAM.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "Please Enter DB Password"
read -s mysql_root_password

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

    dnf install mysql-server -y &>>$LOGFILE
    VALIDATE $? "Installing MYSQL Server"

    systemctl enable mysqld &>>LOGFILE
    VALIDATE $? "Enabling MYSQL Server"

     systemctl start mysqld  &>>LOGFILE
     VALIDATE $? "Starting MYSQL Server"


    # mysql_secure_installation --set-root-pass ExpenseApp@1 &>>LOGFILE
    # VALIDATE $? "Setting up root password"

    #Below code will be useful for idempotent nature

    mysql -h db.sukeshdaws.shop -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
    
    #wen e run the script for first time the passwd is not set up soo it is not equal to zero
    #wen we run for the  second time the password is equal to zero then it will run below command

    if [ $? -ne 0 ]

    then
        mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
        VALIDATE $?  "MYSQL Root password setup"
    else
        echo -e "MYSQL root password is already setup...$Y SKIP $N" 
    fi    
