#!/bin/bash
USERID=$(id -u)
SOFTWARE=$1

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo "Root access is requried"
        exit 1
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
    if [ $? -ne 0 ]
    then
        echo "Sorry Something wwnt wrong..."
        exit 1
    else
        echo "$SOFTWARE instllation is successfull"
    fi
else
    echo "Already Installed..No need to install again"

fi

#to remove any package from server 
#command: dnf remove mysql -y
