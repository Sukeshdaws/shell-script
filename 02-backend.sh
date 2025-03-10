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

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Intsalling nodejs"


id expense &>>$LOGFILE

if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "Creating Expense User"
else
    echo -e "expense user is alread created... $Y SKIPPING $N"

fi    

mkdir -p /app  #-p if we create directory with same name then it will throw error if we keep -p then it doesnt throw any error
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Dowmloading the backend code"


cd /app
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Extracted backend code"


npm install &>>$LOGFILE
VALIDATE $? "Installing nodejs dependencies"

cp /home/ec2-user/shell-script/backend service /etc/systemd/system/backend.service  &>>$LOGFILE
VALIDATE $? "Copied backend service" 

systemctl daemon-reload &>>$LOGFILE
systemctl start backend &>>$LOGFILE
systemctl enable backend &>>$LOGFILE
VALIDATE $? "Staring and enabling backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing mysql client"

mysql -h db.sukeshdaws.shop -uroot -p${mysql_root_password} < /app/schema/backend.sql  &>>$LOGFILE
VALIDATE $? "Schema loding"

systemctl restart backend  &>>$LOGFILE
VALIDATE $? "Restarting backend"