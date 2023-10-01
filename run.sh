poetry install
poetry shell
autonomy packages sync --update-packages

autonomy packages lock

 Autonomy hash all && Autonomy push-all
rm -rf trader
autonomy fetch valory/trader:0.1.0 --local

cd trader

echo -n "0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a" > your_agent_key.txt
autonomy add-key ethereum your_agent_key.txt
autonomy issue-certificates
autonomy -s run 
