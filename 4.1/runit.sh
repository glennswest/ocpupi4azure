rm -r -f gw
mkdir gw
cp install-config.yaml gw
openshift-install create ignition-configs --dir=gw
#cp gw/auth/kubeconfig ~/.kube/config
#rm ~/.kube/config
#cp gw/auth/kubeconfig ~/.kube/config
#scp gw/* root@store.gw.lo:/volume1/tftp
#sleep 5
#openshift-install --dir=gw wait-for bootstrap-complete --log-level debug
#openshift-install --dir=gw wait-for install-complete --log-level debug


#~/azlogin.sh
echo "Delete old resource group"
#az group delete --name gswx1 --yes
echo "Create new resource group"
#az group create --name gswx1 --location "East US"
echo "Copy RHCOS to resource group"
export VHD_NAME=rhcos-410.8.20190504.0-azure.vhd
#az storage account create --location "East US" --name sagswx1 --kind StorageV2 --resource-group gswx1 --sku Premium_LRS
#az storage account create --location "East US" --name sagswx1 --kind Storage --resource-group gswx1  --sku Standard_LRS
az storage container create --name vhd --account-name sagswx1
ACCOUNT_KEY=$(az storage account keys list --account-name sagswx1 --resource-group gswx1 --query "[0].value" -o tsv)
az storage blob copy start --account-name "sagswx1" --account-key "$ACCOUNT_KEY" --destination-blob "$VHD_NAME" --destination-container vhd --source-uri "https://openshifttechpreview.blob.core.windows.net/rhcos/$VHD_NAME"

echo "Configure template with ignition files"
python setup-variables.py
echo "Start Deployment"
az group deployment create \
   --name gswx1 \
   --resource-group gswx1 \
   --template-uri "https://raw.githubusercontent.com/glennswest/ocpupi4azure/master/4.1/azuredeploy.json" \
     --parameters "runit.parameters.json"

