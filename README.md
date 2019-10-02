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

When creating the Red Hat OpenShift Container Platform on Azure, you will need a SSH RSA key for access.

## SSH Key Generation

1. [Windows](ssh_windows.md)
2. [Linux](ssh_linux.md)
3. [Mac](ssh_mac.md)

## Create the Installation
### OCP Version 4.2 - Create the Installation on the Azure Portal
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fopenshift%2Fopenshift-ansible-contrib%2Fmaster%2Freference-architecture%2Fazure-ansible%2F3.7%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fopenshift%2Fopenshift-ansible-contrib%2Fmaster%2Freference-architecture%2Fazure-ansible%2F3.7%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


## Parameters

### Input Parameters

| Name| Type           | Description |
| ------------- | ------------- | ------------- |
| bootstrap.ign  | String       | Ignition File for Bootstrap Node      |
| master.ign     | String       | Ignition File for Master Node         |
| worker.ign     | String       | Public SSH Key for the Virtual Machines |
| masterDnsName  | String       | DNS Prefix for the OpenShift Master / Webconsole |
| numberOfNodes  | Integer      | Number of OpenShift Nodes to create |
| masterVMSize | String | The size of the Master Virtual Machine |
| nodeVMSize| String | The size of the each Node Virtual Machine |

