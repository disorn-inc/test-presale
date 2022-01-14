from scripts.helpful_scripts import get_account, get_contract
from brownie import PreToken, PresaleTest, network, config, Contract
from web3 import Web3
import yaml
import json
import os
import shutil
KEPT_BALANCE = Web3.toWei(10, "ether")

def tes_value():
    account = get_account()
    presale_address = "0x8dD5843475AD0307f3f53116b4AfB5530Ae8CEB4"
    fau_address = "0xFab46E002BbF0b4509813474841E0716E6730136"
    presale = Contract.from_abi("PresaleTest", presale_address, PresaleTest.abi)
    (price, decimal) = presale.getTokenValue(fau_address)
    print(price, decimal) 
    amount = presale.convertToPretoken(config["networks"][network.show_active()]["fau_token"], KEPT_BALANCE, {"from": account})
    print(amount / 10**18)
    # buy = presale.buyToken()

def main():
    tes_value()