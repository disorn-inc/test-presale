import { useContractCall, useEthers } from "@usedapp/core";
import PresaleTest from "../chain-info/contracts/PresaleTest.json";
import networkMapping from "../chain-info/deployments/map.json";
import { constants } from "ethers";
import { utils, BigNumber } from "@usedapp/core/node_modules/ethers";

export const useTotalBalance = (address: string, amount: number ): BigNumber | undefined => {
    const { chainId, account } = useEthers();
    const { abi } = PresaleTest;
    const proxyAddress = chainId ? networkMapping[String(chainId)]["PresaleTest"][0] : constants.AddressZero;
    // console.log(proxyAddress)
    const tokenFarmInterface = new utils.Interface(abi);
    // const tokenFarmContract = new Contract(proxyAddress, tokenFarmInterface);

    // const {send: totalSend, state: totalState} = useContractFunction(
    //     tokenFarmContract, "getConstValue", {transactionName: "Total Balance"}
    // )
    // const total = totalSend().then(res => res)
    // console.log(total)
    // return {total};
    // const b = useTokenBalance(address, account);
    const [stakingBalance] =
    useContractCall({
      abi: tokenFarmInterface,
      address: proxyAddress,
      method: "convertToPretoken",
      args: [address, amount],
    }) ?? []
    // console.log(b)
    return stakingBalance;
}