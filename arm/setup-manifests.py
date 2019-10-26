import json
import base64
import sys
import os
from dotmap import DotMap
import yaml

resource_group = sys.argv[1]
print ('resource_group: ', resource_group)



with open('./gw/manifests/cloud-provider-config.yaml') as file:
      yamlx = yaml.load(file)
      jsondata = yamlx['data']['config']
      jsonx = json.loads(jsondata)
      config = DotMap(jsonx)
      config.resourceGroup = resource_group
      config.vnetName = "openshiftVnet"
      config.vnetResourceGroup = resource_group
      config.subnetName = "masterSubnet"
      config.securityGroupName = "master1nsg"
      config.routeTableName = ""
      jsondata = json.dumps(dict(**config.toDict()))
      jsonout = jsondata.replace('"', '\\"').replace('\n', '\\n')
      yamlx['data']['config'] = jsonout
      with open('./gw/manifests/cloud-provider-config.yaml', 'w') as outfile:
          yaml.dump(yamlx, outfile, default_flow_style=False)

with open('./gw/manifests/cluster-infrastructure-02-config.yml') as file:
      yamlx = yaml.load(file)
      yamlx['status']['platformStatus']['azure']['resourceGroupName'] = resource_group   
      with open('./gw/manifests/cluster-infrastructure-02-config.yml','w') as outfile:
          yaml.dump(yamlx, outfile, default_flow_style=False)

dnsyml = "gw/manifests/cluster-dns-02-config.yml"
if (is.path.isfile(dnsyml)
   os.remove(dnsyml)

"""
apiVersion: config.openshift.io/v1
kind: Infrastructure
metadata:
  creationTimestamp: null
  name: cluster
spec:
  cloudConfig:
    key: config
    name: cloud-provider-config
status:
  apiServerInternalURI: https://api-int.gw.ncc9.com:6443
  apiServerURL: https://api.gw.ncc9.com:6443
  etcdDiscoveryDomain: gw.ncc9.com
  infrastructureName: gw-tzgbp
  platform: Azure
  platformStatus:
    azure:
      resourceGroupName: gw-tzgbp-rg
    type: Azure
"""
