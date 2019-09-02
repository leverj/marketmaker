# marketmaker
Basic Market maker script for leverj

# Prerequisites
Debian or Ubuntu platform

# What the script does
1. Install docker if needed
2. Stop running market maker bot if any
3. Capture log of last terminated market maker bot
4. Start market maker bot

# Environment variables

URL=https://test.leverj.io

KEY_FILE=leverj-api-key.json

PRICE_RANGE=0.0003

QUANTITY=1

DEPTH=2

STEP=0.000001

SPREAD=0.00001

START_PRICE=0.00006

START_SIDE=buy

STRATEGY=COLLAR

BOT_NAME=levmm

||||
|---|---|---|
|URL|Url of exchange|https://test.leverj.io for testnet, https://live.leverj.io for production|
|KEY_FILE|json file containing api key|Download from your account|
|PRICE_RANGE|||
|QUANTITY|size per order||
|DEPTH|How deep from the spread||
|STEP|price difference between order on same side||
|SPREAD|price difference between bid/ask||
|START_PRICE|midpoint of book start here||
|START_SIDE|||
|STRATEGY|How to place prices|Collar=equal sizes random=random sizes|



