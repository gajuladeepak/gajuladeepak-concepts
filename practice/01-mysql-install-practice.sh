#!/bin/bash
USERID=$(id -u)
SOFTWARE=$1

if [ $USERID -ne 0 ]
then
    echo "Root access is requried"
    exit 1

dnf list installed $SOFTWARE

