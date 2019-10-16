echo "Start Deployment"
az group deployment create \
   --name $1 \
   --resource-group $1 \
   --template-uri "https://raw.githubusercontent.com/glennswest/ocpupi4azure/master/arm/azuredeploy.json" \
     --parameters "runit.parameters.json"

