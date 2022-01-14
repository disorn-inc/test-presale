from scripts.helpful_scripts import get_account, get_contract
from brownie import PreToken, PresaleTest, network, config, Contract, MockERC20, interface
from web3 import Web3
import yaml
import json
import os
import shutil
KEPT_BALANCE = Web3.toWei(1, "ether")
BUY_BALANCE = Web3.toWei(10, "ether")

def un_pause():
    account = get_account()
    presale_address = "0xF077c9f246A0f72Fb41a89B954e4E999c90E90D7"
    token_address = "0xC3c57ec3085F83643f89E2e3C74A9ee630a1454a"
    presale = Contract.from_abi("PresaleTest", presale_address, PresaleTest.abi)
    puase = presale.onwerUnPause({"from": account, "gas_limit": 1000000, "allow_revert":True})
    puase.wait(1)
    puase_status = presale.paused({"from": account})
    print(puase_status)

def main():
    un_pause()