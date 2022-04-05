#!/bin/bash

echo "The maximum power level of the battery is: "
sudo cat /sys/class/power_supply/BAT0/charge_control_end_threshold


echo "What is the maximum percentage of power you want to load on your device? (positive integer)"

read inp


echo "Do you want to set the maximum power to $inp percent? (y/n)"
read inp2


if [ "$inp2" = "y" ]
    then
        echo $inp | sudo tee /sys/class/power_supply/BAT0/charge_control_end_threshold
        echo "setting..."
    else
        echo "aborting..."
fi


echo "Now set to"
sudo cat /sys/class/power_supply/BAT0/charge_control_end_threshold
echo " Percent."

exit


