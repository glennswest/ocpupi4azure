echo "Using resource group $1"
rm -r -f gw
mkdir gw
cp install-config.yaml gw
./openshift-install create ignition-configs --dir=gw
#cp gw/auth/kubeconfig ~/.kube/config
#rm ~/.kube/config
#cp gw/auth/kubeconfig ~/.kube/config
#scp gw/* root@store.gw.lo:/volume1/tftp
#sleep 5
#openshift-install --dir=gw wait-for bootstrap-complete --log-level debug
#openshift-install --dir=gw wait-for install-complete --log-level debug


#~/azlogin.sh
echo "Delete old resource group"
az group delete --name $1 --yes
echo "Create new resource group"
az group create --name $1 --location "East US"
echo "Copy RHCOS to resource group"
#export VHD_NAME=rhcos-410.8.20190504.0-azure.vhd
export VHD_URL=https://rhcos.blob.core.windows.net/imagebucket/
export VHD_NAME=rhcos-42.80.20191010.0.vhd
#az storage account create --location "East US" --name sa${1} --kind StorageV2 --resource-group $1 --sku Premium_LRS
az storage account create --location "East US" --name sa${1} --kind Storage --resource-group $1  --sku Standard_LRS
az storage container create --name vhd --account-name sa${1}
export ACCOUNT_KEY=$(az storage account keys list --account-name sa${1} --resource-group $1 --query "[0].value" -o tsv)
az storage blob copy start --account-name "sa${1}" --account-key "$ACCOUNT_KEY" --destination-blob "$VHD_NAME" --destination-container vhd --source-uri ${VHD_URL}${VHD_NAME}
echo "Waiting on copy of vhd"
status="unknown"
echo $status
while [ "$status" != "success" ]
    do
    status=$(az storage blob show --container-name vhd --name $VHD_NAME --account-name "sa${1}"  --account-key "$ACCOUNT_KEY" -o json --query properties.copy.status | sed -e 's/^"//' -e 's/"$//')
    done
echo "Copy of vhd complete"


echo "Configure template with ignition files"
az storage container create --name files --account-name sa${1} --public-access blob
ACCOUNT_KEY=$(az storage account keys list --account-name sa${1} --resource-group $1 --query "[0].value" -o tsv)
az storage blob upload --account-name sa$1 --account-key $ACCOUNT_KEY -c "files" -f "gw/bootstrap.ign" -n "bootstrap.ign"
BOOTSTRAPURL=$(az storage blob url --account-name sa$1 --account-key $ACCOUNT_KEY -c "files" -n "bootstrap.ign" -o tsv)
python setup-variables.py $BOOTSTRAPURL

az network public-ip create -g $1 -n $1 --allocation-method static
