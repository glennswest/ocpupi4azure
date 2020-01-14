#!/bin/bash
#set -e
echo "Using resource group $1"
echo "Using dns domain $2"
echo "Creating Public DNS"
az network dns zone create -g $1 -n $2 
vdnsserv=`az network dns record-set ns show -g $1 -z $2 -n @ --query 'nsRecords[0].nsdname' -o tsv`
vdnsip=`dig +short ${vdnsserv}`
#az network vnet update -g $1 -n openshiftVnet --dns-servers ${vdnsip}
az network vnet create \
  --name openshiftVnet \
  --resource-group $1 \
  --location centralus \
  --address-prefix 10.0.0.0/16 \
  --subnet-name nodeSubnet \
  --subnet-prefixes 10.0.1.0/24 \
  --subnet-name masterSubnet \
  --subnet-prefixes 10.0.0.0/24 \
  --dns-servers ${vdnsip}
az network dns record-set a add-record -g $1 -z $2 -n bootstrap-0  -a 10.0.0.4
az network dns record-set a add-record -g $1 -z $2 -n master1 -a 10.0.0.5
az network dns record-set a add-record -g $1 -z $2 -n master2 -a 10.0.0.6
az network dns record-set a add-record -g $1 -z $2 -n master3 -a 10.0.0.7
az network dns record-set srv add-record -g $1 -z $2  -n _etcd-server-ssl._tcp.${2} -t master1.${2} -p 1 -w 1 -r 2380
az network dns record-set srv add-record -g $1 -z $2  -n _etcd-server-ssl._tcp.${2} -t master2.${2} -p 1 -w 1 -r 2380
az network dns record-set srv add-record -g $1 -z $2  -n _etcd-server-ssl._tcp.${2} -t master3.${2} -p 1 -w 1 -r 2380
az network dns record-set srv add-record -g $1 -z $2  -n _etcd-server-ssl._tcp.${2} -t bootstrap-0.${2} -p 1 -w 1 -r 2380
export MASTERIP=`az network public-ip show --resource-group $1 --name $1 --query [ipAddress] --output tsv`
export APPIP=`az network public-ip show --resource-group $1 --name ${1}app --query [ipAddress] --output tsv`
#export INTLBIP=`az network lb frontend-ip show -g $1 --lb-name ${1}intlb -n LoadBalancerFrontEnd --query [privateIpAddress] --output tsv`
export INTLBIP="10.0.0.63"
az network dns record-set a add-record -g $1 -z $2 -n api-int -a ${INTLBIP}
az network dns record-set list -g gswx1 -z gw.ncc9.com
az network dns zone create -g $1 -n $2
az network dns record-set a add-record -g $1 -z $2 -n api -a ${MASTERIP}
az network dns record-set a add-record -g $1 -z $2 -n *.apps -a ${APPIP}
az network dns record-set list -g gswx1 -z gw.ncc9.com

