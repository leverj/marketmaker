#!/bin/bash
URL=https://test.leverj.io
#URL=https://live.leverj.io
PRICE_RANGE=0.0003
KEY_FILE=leverj-api-key.json
QUANTITY=1
DEPTH=2
STEP=0.000001
SPREAD=0.00001
START_PRICE=0.00006
START_SIDE=buy
STRATEGY=COLLAR
BOT_NAME=levmm

for e in PRICE_RANGE QUANTITY DEPTH STEP SPREAD START_PRICE START_SIDE STRATEGY
do
	eval env=\$$e
	ENVS="$ENVS -e $e=$env"
done

function setup_debian_docker() {
  local ID=$(lsb_release -is | tr A-Z a-z)
  local REL=$(lsb_release -rs)
  local V=${REL%.*}
  [ -z "$ID" ] && echo Could not determine Distribution && exit 1
  local INST=$(apt-cache search '^docker-(ce|engine)' 2>/dev/null | awk '{print $1}')
  [ -n "$INST" ] && echo Skipping docker. Already installed: $INST && return 1
  [ "$ID" = "ubuntu" -a "$REL" \< "16.04" ] && echo Only Ubuntu 16.04+ supported && exit 1
  [ "$ID" = "debian" -a "$V" -lt 8 ] && echo Only Debian 8+ supported && exit 1

  apt-get remove -y docker docker-engine docker.io
  curl -fsSL https://download.docker.com/linux/$ID/gpg | apt-key add -
  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/${ID} \
   $(lsb_release -cs) \
   stable"
   apt-get update
   apt-get install -y docker-ce
}

setup_debian_docker
mkdir -p /root/privateKey
[ ! -f /root/privateKey/$KEY_FILE ] && echo "Could not find private key /root/privateKey/$KEY_FILE" && exit 1

echo Running market maker
docker stop $BOT_NAME
docker logs $BOT_NAME > $BOT_NAME`date +%Y%m%d_%H%M%S`.log
docker rm $BOT_NAME
docker run  --cap-drop ALL --read-only --restart=unless-stopped --name "$BOT_NAME" -d -v /root/privateKey:/privateKey $ENVS -e BASE_URL=$URL leverj/leverj-mm:master node src/mm.js /privateKey/$KEY_FILE
