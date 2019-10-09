#az storage container delete --name files --account-name sagswx1 
#az storage container create --name files --account-name sagswx1 --public-access blob
ACCOUNT_KEY=$(az storage account keys list --account-name sagswx1 --resource-group gswx1 --query "[0].value" -o tsv)
az storage blob upload --account-name sagswx1 --account-key $ACCOUNT_KEY -c "files" -f "gw/bootstrap.ign" -n "bootstrap.ign"
