#!bin/bash

#usually logs will be in /var/log
#we need to create a folder in /var/log 
#let say i am creating a folder named (shell-script) in /var/log/shell-script
#file name should in specified foemat

#tee command(writs logs on multiple destinations)
#everytime checking the logs by navigating to logs file is hectic task
#so we use tee command to write logs on both terminal and logs
LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOGFILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER #if we give mkdir -p if it's created it will not show any error in terminal or if it is not created it will create a folder

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo "$R Please run this script with root priveleges $N" | tee -a $LOGFILE
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

CHECK_ROOT

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installation of mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabled the service" 

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting the service"

mysql -h backend.deepakaws.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE

if [ $? -ne 0 ]
then 
    echo "Setting up root password" &>>$LOGFILE
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "Setting up root password"
else
    echo -e "Password was already setup...$Y skip the step $N" | tee -a $LOGFILE

fi
