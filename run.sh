
export RPC_0="https://nethermind-nethermind-xdai.a48730b12c57d259.dyndns.dappnode.io"
export CHAIN_ID=100

export ALL_PARTICIPANTS='["0x1C72a70b6e5f055eF42b6beFa55026BE081365b1"]'
export SAFE_CONTRACT_ADDRESS="0x2a4c15908b03fFbb6179f3F52A27D971571A093A"
export OMEN_CREATORS='["0x89c5cc945dd550BcFfb72Fe42BfF002429F46Fec"]'

export BET_AMOUNT_PER_THRESHOLD_000=0
export BET_AMOUNT_PER_THRESHOLD_010=0
export BET_AMOUNT_PER_THRESHOLD_020=0
export BET_AMOUNT_PER_THRESHOLD_030=0
export BET_AMOUNT_PER_THRESHOLD_040=0
export BET_AMOUNT_PER_THRESHOLD_050=0
export BET_AMOUNT_PER_THRESHOLD_060=0
export BET_AMOUNT_PER_THRESHOLD_070=0
export BET_AMOUNT_PER_THRESHOLD_080=123697802100000000
export BET_AMOUNT_PER_THRESHOLD_090=352369780210000000
export BET_AMOUNT_PER_THRESHOLD_100=1023697802100000000
export BET_THRESHOLD=352369780210000000
export SLEEP_TIME=2
export REDEEM_MARGIN_DAYS=23
#export RPC_TIMEOUT_DAYS=5
#export MECH_TOOL="prediction-online-sme"
export PROMPT_TEMPLATE="You are a Gnostic Observer, Ipsissimus Ordo Hermeticus Aurorae Aureae. Please return respective probabilities \`p_yes\` and \`p_no\` where \`@{yes}\` represents \`yes\` and \`@{no}\` represents \`no\` of the following question \`@{question}\`. Thank you."

autonomy packages lock

autonomy push-all

autonomy fetch --local --service valory/trader && cd trader

autonomy build-image 

autonomy build-image --service-dir ../packages/valory/services/trader/