#!/bin/bash

#to print in red color in terminal echo -e "\e[31m Hello World"

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
USERID=$(id -u)
SOFTWARE=$1

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo "Root access is requried"
        exit 1
    fi
    
}


INSTALLATION_CHECK(){
    if [ $1 -ne 0 ]
    then
        echo "Sorry Something went wrong..."
        echo -e "$2 installation is... $R Failed $N"
        exit 1
    else
        echo -e "$2 instllation is $G successfull $N"
    fi

}
CHECK_ROOT


if [ -z $SOFTWARE ]
then    
    echo "Please provide input to the command"
    exit 1
fi



dnf list installed $SOFTWARE

if [ $? -ne 0 ]
then
    echo "Need to install $SOFTWARE.. Not yet installed"
    dnf install $SOFTWARE -y
    INSTALLATION_CHECK $? $SOFTWARE
else
    echo "Already Installed..No need to install again"

fi


#to remove any package from server 
#command: dnf remove mysql -y
