# Open Autonomy Workflow Commands
## Overview
This document will described the commands to build and publish a Open Autonomy package 

## Workflow Commands
1. Install and run poetry and create a environment
```
    pip install poetry
    poetry install && poetry shell
```
2. initialize autonomy framework setting default source for packages and the ipfs node
```
    autonomy init --reset --author valory --remote --ipfs --ipfs-node "/dns/registry.autonolas.tech/tcp/443/https"
```
3. Sync and update autonomy packages
```
    autonomy packages sync --update-packages
```
4. Update packages hashes
``` 
    autonomy packages lock
```
5. push package hashes to registry
```
    autonomy push-all
```

## Deploy Locally 
1. remove local working folder and fetch project to local registry
```
rm -rf trader
autonomy fetch valory/trader:0.1.0 --local
```
2. navigate to the trader directory
```
cd trader
```
3. update aea-config 
open trader/aea-config.yaml and set the following (service regisry and agent need to be none null as the type is enforced such)
- all_participants: ${list:["0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65"]}
- service_registry_address: ${str:0x0000000000000000000000000000000000000000}
- agent_registry_address: ${str:0x0000000000000000000000000000000000000000}

4. Add ethereum key to local agem
```
echo -n "0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a" > your_agent_key.txt
autonomy add-key ethereum your_agent_key.txt
```

5. Issue Certificates
```
autonomy issue-certificates
```

6. Run
```
autonomy -s run 
```

## Test Locally 
- to do 
