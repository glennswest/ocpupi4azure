echo "Start Deployment"
az group deployment create \
   --name gswx1 \
   --resource-group gswx1 \
   --template-uri "https://raw.githubusercontent.com/glennswest/ocpupi4azure/master/4.1/azuredeploy.json" \
     --parameters "runit.parameters.json"

