#!/bin/bash

#   Script, that helps you set up a charging treshold in a linux system on a Notebook, that supports this function. Wont have any effect if not supported.
#   You can pass a optional parameter $1, which is the percentage of the battery you want to set. If you did not supply it you will have to input it later.
#   If your battery percentage is above the set limit this will have no effect until your battery percentage is actually lower than the limit. 
#   If not for this case everything works very well :). You can set this script as a alias so you can run it easily.


#   It works by writing the limit into a kernel parameter of the linux kernel. Unfortunately this is reset every reboot and to my knowledge 
#   there is no way to set this up permanently. If the parameter does not exist on your system, it means this functionality is not supported by either kernel or 
#   battery of your system.

#   You can check that with the following command: 
#   sudo cat /sys/class/power_supply/BAT0/charge_control_end_threshold
#   If the command works and the output is a integer (most likely 100) you are good to go.



read_current_limit () {

    var_int_percentage=`cat /sys/class/power_supply/BAT0/charge_control_end_threshold`
    echo "The powerlimit is currently set to: $var_int_percentage Percent."
    echo ""

}

set_limit () {
    
    if [ -n "$1" ]; then 

        new_limit=$1
        echo $new_limit | tee /sys/class/power_supply/BAT0/charge_control_end_threshold
    
    fi
}


if [[ $EUID -ne 0 ]]; then
    run_as_root="false"
    echo "Please use this script with sudo or from an admin shell, because this script is applying changes to your temporary system configuration."
    exit 1
else
    run_as_root="true"
fi



if [ -n "$1" ]; then 
    inp_percentage=$1
fi


read_current_limit

finished="no"

while [ "$finished" == "no" ]
do

    if [ -n "$inp_percentage" ]; then 

        echo "Ah, you set the parameter. So you want to set the limit to $1 percent? (y/n)"
        read inp_bool

    else

        echo "What is the maximum percentage of power you want for your device? (positive integer smaller or equal to 100)"
        read inp_percentage

        if ((inp_percentage <= 100 && inp_percentage > 0)); then
            
            echo "Do you want to set the maximum power to $inp_percentage percent? (y/n)"
            read inp_bool

        else
            echo "You did not enter a valid integer! You entered $inp_percentage."
            inp_bool="n"
        fi

    fi


    if [ "$inp_bool" == "y" ]; then
        
        echo ""
        set_limit "$inp_percentage"
        finished="true"

    else
        
        echo "Retry? (y/n)"
        read inp_bool_retry
        
        if [ "$inp_bool_retry" == "n" ]; then
            echo ""
            finished="yes"
        else
            echo ""
            unset inp_percentage
        fi

    fi

done

echo ""
read_current_limit

exit 0
