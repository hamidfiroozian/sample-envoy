import { Injectable } from '@nestjs/common';
import { ethers } from 'ethers';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello World!';
  }

  async getWalletBalance(): Promise<string> {
    try {
      // const rpc =
      //   'https://ethereum-sepolia.core.chainstack.com/fcb99710509cca4ee2a8bc6c48bd7389';
      const rpc =
        'https://sepolia.infura.io/v3/88c480d89d7042fd84bcdbdebcaadcef';

      const provider = new ethers.providers.JsonRpcProvider(rpc);
      const walletAddress = '0x819A569716E432F02e37788fD32079f85Ea14A25';
      // Get the balance of the wallet
      const balance = await provider.getBalance(walletAddress);

      // Convert the balance from Wei to Ether
      const balanceInEther = ethers.utils.formatEther(balance);

      console.log(`Balance of ${walletAddress}: ${balanceInEther} ETH`);
      return `Balance of ${walletAddress}: ${balanceInEther} ETH`;
    } catch (error) {
      console.error('Error getting wallet balance:', error);
    }
    return 'error getting wallet balance';
  }
}
