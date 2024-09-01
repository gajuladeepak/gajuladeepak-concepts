#!/bin/bash

#to print in red color in terminal echo -e "\e[31m Hello World"

Redcolor="\e[31m"
Greencolor="e[32m"
NORMALCOLOR="e[0m"
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


INSTALLATION_CHECK(){
    if [ $1 -ne 0 ]
    then
        echo "Sorry Something went wrong..."
        echo "$2 installation is... $Redcolor Failed $NORMALCOLOR"
        exit 1
    else
        echo "$2 instllation is $Greencolor successfull $NORMALCOLOR"
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
