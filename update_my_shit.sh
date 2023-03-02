#!/bin/zsh

echo "Starting update Script....\n"
echo "________________________________"
echo "yay: "
echo ""
yay -Syu

echo "________________________________"
echo "flatpak: "
echo ""
flatpak update

echo "________________________________"
echo "remove unused flatpak runtimes: "
echo ""
flatpak remove --unused
echo ""
echo "finished!"
exit
