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

### Prerequisites:
1. Download the installer
2. Make sure python2 is installed
3. Execute: pip install dotmap


./setup_azarm.sh UniqueResourceGroupName  
read -p "Press [Enter] to start deploy"  
./deploy_azarm.sh UniqueResourceGroupNaem  

For more information see: 
    [azocpupi_overview.pdf](https://github.com/glennswest/ocpupi4azure/blob/master/doc/azocpupi_overview.pdf)
