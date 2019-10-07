export VHD_NAME=rhcos-410.8.20190504.0-azure.vhd
az storage account create --location "East US" --name ckocp4storage --kind StorageV2 --resource-group gswx1
az storage container create --name vhd --account-name ckocp4storage
#az group create --location uksouth --name rhcos_images
ACCOUNT_KEY=$(az storage account keys list --account-name ckocp4storage --resource-group gswx1 --query "[0].value" -o tsv)
az storage blob copy start --account-name "ckocp4storage" --account-key "$ACCOUNT_KEY" --destination-blob "$VHD_NAME" --destination-container vhd --source-uri "https://openshifttechpreview.blob.core.windows.net/rhcos/$VHD_NAME"

