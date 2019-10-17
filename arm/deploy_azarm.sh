echo "Start Deployment"
az group deployment create \
   --name $1 \
   --resource-group $1 \
   --template-uri "https://raw.githubusercontent.com/glennswest/ocpupi4azure/master/arm/azuredeploy.json" \
     --parameters "runit.parameters.json"
openshift-install --dir=gw wait-for bootstrap-complete --log-level debug
az vm stop --resource-group $1 --name bootstrap-0
az vm deallocate --resource-group $1 --name bootstrap-0 --no-wait
openshift-install --dir=gw wait-for install-complete --log-level debug
