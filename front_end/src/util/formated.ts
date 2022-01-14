import { formatUnits } from "@ethersproject/units";
import { utils, BigNumber } from "@usedapp/core/node_modules/ethers";

export function formattedToken(value: BigNumber | undefined) {  
    const balance = value ? parseFloat(formatUnits(value, 0))  : 0;
    return balance;
}

export function normalFormattedToken(value: BigNumber | undefined) {  
    const balance = value ? parseFloat(formatUnits(value, 18)) : 0;
    return balance;
}