#!/bin/bash
#set -e
echo "Using resource group $1"
echo "Using dns domain $2"
echo "Creating private dns settings"
a z network private-dns zone create -g $1 -n $2
az network private-dns record-set srv add-record -g $1 -z $2  -n _etcd-server-ssl._tcp.${2} -t master1.${2} -p 1 -w 1 -r 2380
az network private-dns record-set srv add-record -g $1 -z $2  -n _etcd-server-ssl._tcp.${2} -t master2.${2} -p 1 -w 1 -r 2380
az network private-dns record-set srv add-record -g $1 -z $2  -n _etcd-server-ssl._tcp.${2} -t master3.${2} -p 1 -w 1 -r 2380
az network private-dns record-set srv add-record -g $1 -z $2  -n _etcd-server-ssl._tcp.${2} -t bootstrap-0.${2} -p 1 -w 1 -r 2380
export MASTERIP=`az network public-ip show --resource-group $1 --name $1 --query [ipAddress] --output tsv`
export APPIP=`az network public-ip show --resource-group $1 --name ${1}app --query [ipAddress] --output tsv`
az network private-dns record-set a add-record -g $1 -z $2 -n master1 -a 10.0.0.5
az network private-dns record-set a add-record -g $1 -z $2 -n master2 -a 10.0.0.6
az network private-dns record-set a add-record -g $1 -z $2 -n master3 -a 10.0.0.7
az network private-dns record-set a add-record -g $1 -z $2 -n bootstrap-0 -a 10.0.0.4
az network private-dns record-set a add-record -g $1 -z $2 -n node01 -a 10.0.1.4
az network private-dns record-set a add-record -g $1 -z $2 -n node02 -a 10.0.1.5
az network private-dns record-set a add-record -g $1 -z $2 -n node03 -a 10.0.1.6
az network private-dns record-set a add-record -g $1 -z $2 -n api -a ${MASTERIP}
az network private-dns record-set a add-record -g $1 -z $2 -n *.apps -a ${APPIP}
#export INTLBIP=`az network lb frontend-ip show -g $1 --lb-name ${1}intlb -n LoadBalancerFrontEnd --query [privateIpAddress] --output tsv`
export INTLBIP="10.0.0.63"
az network private-dns record-set a add-record -g $1 -z $2 -n api-int -a ${INTLBIP}
az network private-dns record-set list -g gswx1 -z gw.ncc9.com
#az network private-dns link vnet create -g $1 -n ${1}DNSLink -z $2 -v openshiftVnet -e true
az network private-dns link vnet create -g $1 -n ${1}DNSLink -z $2 -v openshiftVnet -e false

