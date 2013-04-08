#!/bin/bash

SONOSCONF=~/Library/Application\ Support/Sonos/jffs/localsettings.txt
OURCONF=~/Library/Application\ Support/Sonos/jffs/globalsettings.txt

case $1 in
    save)
        if [ -z $2 ]
        then
            echo "please specify a name!"
            exit
        else
            HOUSEHOLDID=`sed -nE "s/HouseholdID: \[(.+)\]/\1/p" "$SONOSCONF"`
            REGISTEREDCUSTOMERID=`sed -nE "s/RegisteredCustomerID: \[(.+)\]/\1/p" "$SONOSCONF"`
            echo $2 $HOUSEHOLDID $REGISTEREDCUSTOMERID >> "$OURCONF"
            echo "saved profile $2 to $OURCONF"
        fi
        ;;
    load)
        if [ -z $2 ]
        then
            echo "please specify a name!"
            exit
        else
            echo "loading $2..."
            LINE=`grep "^$2" "$OURCONF"`
            HOUSEHOLDID=$(echo $LINE | cut -f2 -d' ')
            echo $HOUSEHOLDID
            REGISTEREDCUSTOMERID=$(echo $LINE | cut -f3 -d' ')
            sed -iE "s/HouseholdID: .*/HouseholdID: \[$HOUSEHOLDID\]/" "$SONOSCONF"
            sed -iE "s/RegisteredCustomerID: .*/RegisteredCustomerID: \[$REGISTEREDCUSTOMERID\]/" "$SONOSCONF"
        fi
        ;;
    *)
        printf "Usage:\n$0 save [name] -- save household configuration\n$0 load [name] -- recall household configuration\n"
        ;;
esac

