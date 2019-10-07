export VHD_NAME=rhcos-410.8.20190504.0-azure.vhd
az storage account create --location "East US" --name sagswx1 --kind StorageV2 --resource-group gswx1 --sku Premium_LRS
az storage container create --name vhd --account-name sagswx1
ACCOUNT_KEY=$(az storage account keys list --account-name sagswx1 --resource-group gswx1 --query "[0].value" -o tsv)
az storage blob copy start --account-name "sagswx1" --account-key "$ACCOUNT_KEY" --destination-blob "$VHD_NAME" --destination-container vhd --source-uri "https://openshifttechpreview.blob.core.windows.net/rhcos/$VHD_NAME"

