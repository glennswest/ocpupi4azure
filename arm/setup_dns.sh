#!/bin/bash
set -e
echo "Using resource group $1"
echo "Using dns domain $2"
echo "Creating private dns settings"
az network private-dns zone create -g $1 -n $2
az network private-dns link vnet create -g $1 -n ${1}DNSLink -z $2 -v openshiftVnet -e true
az network private-dns record-set srv add-record -g $1 -z $2  -n _etcd-server-ssl._tcp.${2} -t master1.${2} -p 1 -w 1 -r 2380
az network private-dns record-set srv add-record -g $1 -z $2  -n _etcd-server-ssl._tcp.${2} -t master2.${2} -p 1 -w 1 -r 2380
az network private-dns record-set srv add-record -g $1 -z $2  -n _etcd-server-ssl._tcp.${2} -t master3.${2} -p 1 -w 1 -r 2380
az network private-dns record-set srv add-record -g $1 -z $2  -n _etcd-server-ssl._tcp.${2} -t ${1}m1.${2} -p 1 -w 1 -r 2380
export MASTERIP=`az network public-ip show --resource-group $1 --name $1 --query [ipAddress] --output tsv`
export APPIP=`az network public-ip show --resource-group $1 --name ${1}app --query [ipAddress] --output tsv`
az network private-dns record-set a add-record -g $1 -z $2 -n api -a ${MASTERIP}
az network private-dns record-set a add-record -g $1 -z $2 -n *.apps -a ${APPIP}
export INTLBIP=`az network lb frontend-ip show -g $1 --lb-name ${1}intlb -n LoadBalancerFrontEnd --query [privateIpAddress] --output tsv`
az network private-dns record-set a add-record -g $1 -z $2 -n api-int -a ${INTLBIP}
az network private-dns record-set list -g gswx1 -z gw.ncc9.com
echo "Creating Public DNS"
az network dns zone create -g $1 -n $2
az network dns record-set a add-record -g $1 -z $2 -n api -a ${MASTERIP}
az network dns record-set a add-record -g $1 -z $2 -n *.apps -a ${APPIP}
export DNSSERVNAME=`az network dns record-set ns show --resource-group $1 --zone-name $2 --name @ --query "nsRecords[0].nsdname" --output tsv`
echo "Please add "${DNSSERVNAME}"to your dns resolver settings"


