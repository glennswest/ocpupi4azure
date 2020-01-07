#!/bin/bash
#set -e
echo "Start Deployment"
az group deployment create \
   --name $1 \
   --resource-group $1 \
   --template-uri "https://raw.githubusercontent.com/glennswest/ocpupi4azure/master/arm/azuredeploy.json" \
     --parameters "runit.parameters.json"
if [ $? -ne 0 ]
then 
   echo "Deployment Failed"
   exit $?
fi
echo "Adding internal entries for etcd"
export MASTER1IP=`az vm show -g $1 -n master1 -d --query privateIps --output tsv`
export MASTER2IP=`az vm show -g $1 -n master2 -d --query privateIps --output tsv`
export MASTER3IP=`az vm show -g $1 -n master3 -d --query privateIps --output tsv`
export BOOTSTRAPIP=az vm show -g $1 -n ${1}m1 -d --query privateIps --output tsv`
az network private-dns record-set a add-record -g $1 -z $2 -n etcd-0 -a ${MASTER1IP}
az network private-dns record-set a add-record -g $1 -z $2 -n etcd-1 -a ${MASTER2IP}
az network private-dns record-set a add-record -g $1 -z $2 -n etcd-2 -a ${MASTER3IP}
az network private-dns record-set a add-record -g $1 -z $2 -n ${1}m1 -a ${BOOTSTRAPIP}
./openshift-install --dir=gw wait-for bootstrap-complete --log-level debug
az vm stop --resource-group $1 --name bootstrap-0
az vm deallocate --resource-group $1 --name bootstrap-0 --no-wait
ACCOUNT_KEY=$(az storage account keys list --account-name sa${1} --resource-group $1 --query "[0].value" -o tsv)
az storage blob delete --account-key $ACCOUNT_KEY --account-name sa${1} --container-name files --name bootstrap.ign
./openshift-install --dir=gw wait-for install-complete --log-level debug
