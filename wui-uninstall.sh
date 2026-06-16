#!/bin/bash


systemctl stop x-ui
systemctl disable x-ui
rm /etc/systemd/system/x-ui.service -f
systemctl daemon-reload
systemctl reset-failed
rm /etc/x-ui/ -rf
rm /usr/local/x-ui/ -rf



echo -e "limit success"
