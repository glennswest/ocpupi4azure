import json
import base64
import sys
from dotmap import DotMap

url = sys.argv[1]
print 'Url: ', url
ignition = {
  "ignition": {
    "version": "2.2.0",
    "config": {
      "replace": {
        "source": "http://example.com/config.json",
      }
    }
  }
}


ignition.source = url

with open("gw/bootstrap.ign","r") as ignFile:
    bootstrap_ignition = json.load(ignFile)
with open("gw/master.ign","r") as ignFile:
    master_ignition = json.load(ignFile)
with open("gw/worker.ign","r") as ignFile:
    worker_ignition = json.load(ignFile)
with open("azuredeploy.parameters.json", "r") as jsonFile:
    data = DotMap(json.load(jsonFile))


data.parameters.BootstrapIgnition.value =  base64.b64encode(json.dumps(ignition))
data.parameters.MasterIgnition.value =     base64.b64encode(json.dumps(master_ignition)) 
data.parameters.WorkerIgnition.value =     base64.b64encode(json.dumps(worker_ignition)) 

with open("runit.parameters.json", "w") as jsonFile:
    json.dump(data, jsonFile)

