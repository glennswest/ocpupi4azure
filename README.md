# Red Hat OpenShift Container 4.x UPI Platform on Azure

## Overview
This provides a Azure ARM Template to launch user provided infrastructure implemenation of OpenShift 4.x on Azure.

This creates:
 
    A Resource Group
    3 Masters
    3-16 Workers
    A API Loadbalancer
    A Application Loadbalancer
    2 Availablity Groups

### To Use:

./setup_azarm.sh gswx1
read -p "Press [Enter] to start deploy"
./deploy_azarm.sh       gswx1

For more information see: 
    [azocpupi_overview.pdf](https://github.com/glennswest/ocpupi4azure/blob/master/doc/azocpupi_overview.pdf)
