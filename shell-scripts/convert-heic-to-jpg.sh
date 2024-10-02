#!/bin/bash
# install tifig in archlinux to convert HEIC to jpg
# yay -S tifig-bin
for i in "$PWD"/*.HEIC
do
  tifig -v -p "$i" "${i/HEIC/jpg}"
done
