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

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Intsall nodejs"


id expense &>>$LOGFILE

if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "Creating Expense User"
else
    echo -e "expense user is alread created... $Y SKIPPING $N"

fi    



