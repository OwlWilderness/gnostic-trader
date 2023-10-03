pinstall=True
init=False
sync=False
syncUpd=True
lock=True
if [ $pinstall = True ]
then
    pip install poetry
    poetry install && poetry shell
fi

if [ $init = True ]
then
    #this did not appear to work when called from the script
    autonomy init --reset --author valory --remote --ipfs --ipfs-node "/dns/registry.autonolas.tech/tcp/443/https"
fi

if [ $sync = True ]
then
    if [ $syncUpd = True ]
    then
        autonomy packages sync --update-packages
    else
        autonomy packages sync
    fi
fi

if [ $lock = True ]
then
    autonomy packages lock
    #Error: Skill configuration not found: C:\repo\git\gnosis\gnostic-trader\cfg-rpc-timeout\packages\valory\skills\abstract_round_abci\skill.yaml
fi
rm -rf trader
autonomy fetch valory/trader:0.1.0 --local
0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65

cd trader
echo -n "0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a" > your_agent_key.txt
autonomy add-key ethereum your_agent_key.txt

autonomy issue-certificates
autonomy -s run 

