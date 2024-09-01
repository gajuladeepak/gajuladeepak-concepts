#!bin/bash

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOGFILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R Please run this script with root priveleges $N" | tee -a $LOGFILE
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is...$R FAILED $N" | tee -a $LOGFILE
        exit 1
    else
        echo -e "$2 is... $G SUCCESS $N" | tee -a $LOGFILE
    fi
}

echo "Script started executing at: $(date)" | tee -a $LOGFILE
CHECK_ROOT

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabled the Previous Version"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabled the new version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing the NODEJS"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    echo "Creating the user"
    useradd expense
fi    

mkdir -p /app
VALIDATE $? "Creating the /app folder"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading the backend application code"

cd /app


rm -rf /app/*

unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Extracting the backend application code"

npm install &>>$LOGFILE &>>$LOGFILE
VALIDATE $? "Installing the packages"

cp /home/ec2-user/gajuladeepak-concepts/expense-practice/backend.service  /etc/systemd/system/backend.service

#firstly we need to load the data without loading the data we may get errors. therefore we are loading the data before 
dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing mysql client"


mysql -h mysql.deepakaws.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema/database loading is success"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Demon reload"


systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enabled the backend"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting the service"