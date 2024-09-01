#!/bin/bash


#for i in 1 2 3 4 5
#do 
#    echo $i
#one


#for i in {1..5}
#do 
#    echo $i
#done


#let say i have given 10 packages i want them to install if not installed


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

for package in $@
do 
    dnf list installed $package

    if [ $? -ne 0 ]
    then
        echo "Need to install $package.. Not yet installed"
        dnf install $package -y
        INSTALLATION_CHECK $? $package
    else
        echo "Already Installed..No need to install again"

    fi
done

