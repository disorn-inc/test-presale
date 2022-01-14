from scripts.helpful_scripts import get_account, get_contract
from brownie import PreToken, PresaleTest, network, config, Contract, MockERC20, interface
from web3 import Web3
import yaml
import json
import os
import shutil
KEPT_BALANCE = Web3.toWei(1, "ether")
BUY_BALANCE = Web3.toWei(10, "ether")

def tes_value():
    account = get_account()
    presale_address = "0xF077c9f246A0f72Fb41a89B954e4E999c90E90D7"
    token_address = "0xC3c57ec3085F83643f89E2e3C74A9ee630a1454a"
    presale = Contract.from_abi("PresaleTest", presale_address, PresaleTest.abi)
    amount = presale.convertToPretoken(config["networks"][network.show_active()]["fau_token"], KEPT_BALANCE, {"from": account})
    print(amount / 10**18)
    approve_erc20(BUY_BALANCE, presale_address, config["networks"][network.show_active()]["fau_token"], account)
    buy = presale.buyToken(BUY_BALANCE, config["networks"][network.show_active()]["fau_token"], {"from": account, "gas_limit": 1000000, "allow_revert":True})
    buy.wait(1)
    check_value = presale.getAccountToken(account)
    print(check_value)
    
def approve_erc20(amount, spender, erc20_address, account):
    print("Approving ERC20 token...")
    erc20 = interface.IERC20(erc20_address)
    tx = erc20.approve(spender, amount, {"from": account})
    tx.wait(1)
    print("Approved!")
    return tx

def main():
    tes_value()