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
export BOOTSTRAPIP=`az vm show -g $1 -n bootstrap-0 -d --query privateIps --output tsv`
./openshift-install --dir=gw wait-for bootstrap-complete --log-level debug
az vm stop --resource-group $1 --name bootstrap-0
az vm deallocate --resource-group $1 --name bootstrap-0 --no-wait
ACCOUNT_KEY=$(az storage account keys list --account-name sa${1} --resource-group $1 --query "[0].value" -o tsv)
az storage blob delete --account-key $ACCOUNT_KEY --account-name sa${1} --container-name files --name bootstrap.ign
./openshift-install --dir=gw wait-for install-complete --log-level debug
