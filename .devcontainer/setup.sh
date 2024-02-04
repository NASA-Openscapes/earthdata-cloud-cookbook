#!/bin/bash

sudo cp /etc/rstudio/disable_auth_rserver.conf /etc/rstudio/rserver.conf
sudo sudo bash -c 'echo "USER=rstudio" >>/etc/environment'
sudo /init &> /dev/null &

