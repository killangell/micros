#!/bin/sh

umount -l /dev/sda*

dmsetup remove vg0-lv_swap
dmsetup remove vg0-lv_root
dmsetup remove vg0-lv_var
dmsetup remove vg0-lv_home
dmsetup remove vg0-lv_tmp
dmsetup remove vg0-lv_opt
dmsetup remove vg0-lv_usr
dmsetup remove vg0-lv_data

lvremove /dev/vg0/lv_swap -ff
lvremove /dev/vg0/lv_root -ff
lvremove /dev/vg0/lv_var -ff
lvremove /dev/vg0/lv_home -ff
lvremove /dev/vg0/lv_tmp -ff
lvremove /dev/vg0/lv_opt -ff
lvremove /dev/vg0/lv_usr -ff
lvremove /dev/vg0/lv_data -ff

vgremove vg0 -ff

pvremove /dev/sda* -ff

mkfs.vfat -F 32 -I /dev/sda

mkdir -p test-micros-dir
cd test-micros-dir
rm -rf ./*
