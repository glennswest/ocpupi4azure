az disk create --resource-group gswx1 --name bootstrapdisk --source https://rhcos.blob.core.windows.net/imagebucket/rhcos-42.80.20191002.0.vhd
#az vm create --name bootstrap --resource-group group-1 --admin-username core --custom-data \"$(cat gw/bootstrap.ign)\" --image https://rhcos.blob.core.windows.net/imagebucket/rhcos-42.80.20191002.0.vhd
az vm create --name bootstrap --resource-group gswx1 --custom-data gw/bootstrap.ign --attach-os-disk bootstrapdisk --os-type linux

