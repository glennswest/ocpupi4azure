#rm -r -f gw
#mkdir gw
#cp install-config.yaml gw
#openshift-install create ignition-configs --dir=gw

#cp ~/gw.lo/gw/worker.ign ~
#rm -f ~/.kube/config
#cp gw/auth/kubeconfig ~/.kube/config
#rm ~/.kube/config
#cp gw/auth/kubeconfig ~/.kube/config
#scp gw/* root@store.gw.lo:/volume1/tftp
#sleep 5
#openshift-install --dir=gw wait-for bootstrap-complete --log-level debug
#openshift-install --dir=gw wait-for install-complete --log-level debug


#~/azlogin.sh
#az group delete --name gswx1
#az group create --name gswx1 --location "East US"
az group deployment create \
   --name gswx1 \
   --resource-group gswx1 \
   --template-uri "https://raw.githubusercontent.com/glennswest/ocpupi4azure/master/4.1/azuredeploy.json" \
     --parameters "runit.parameters.json"

