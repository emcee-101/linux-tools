#!/bin/bash
# Ein Skript, dass den PC in Hochleistungsmodus versetzt und ihn wieder herausholt...


echo "Your GPU Power Level is set to:"
sudo cat /sys/class/drm/card0/device/power_dpm_force_performance_level

echo ""

sudo cat /sys/kernel/debug/dri/0/amdgpu_pm_info | head -n 7

echo ""
echo ""

echo "Showing info about current CPU-state..."
sudo cpupower frequency-info | head -n 13 | tail -n 5

echo ""
echo ""

echo "Do you wanna change into performance mode or wanna go back? (y = up, n = down, e= exit)"
read inp
cmpison="y"
cmpisone="e"

if [ "$inp" = "$cmpison" ]
    then
        GPUTarget="high"
        CPUTarget="performance"
    else
        GPUTarget="auto"
        CPUTarget="schedutil"
fi

if [ "$inp" = "$cmpisone" ]
    then
        echo "exiting...."
        exit
fi


echo ""
echo ""

echo "Setting to $GPUTarget...."
su -c "echo $GPUTarget > /sys/class/drm/card0/device/power_dpm_force_performance_level"

echo ""
echo ""

echo "Setting CPU Governor to $CPUTarget..."
sudo cpupower frequency-set -g $CPUTarget

echo ""
echo ""

echo "Your GPU Power Level is set to:"
sudo cat /sys/class/drm/card0/device/power_dpm_force_performance_level

echo ""

sudo cat /sys/kernel/debug/dri/0/amdgpu_pm_info | head -n 7

echo ""
echo ""

echo "Showing info about current CPU-state..."
sudo cpupower frequency-info
