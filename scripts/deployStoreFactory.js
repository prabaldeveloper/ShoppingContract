const { ethers } = require("hardhat")

async function main() {
    const accounts = await ethers.provider.listAccounts();
    console.log("Accounts", accounts[0]);
    //const MATIC = "0x0000000000000000000000000000000000000000";
    //MAINNET
    // const USDC = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";
    // const Trace = "0x4287F07CBE6954f9F0DecD91d0705C926d8d03A4";
    // const USDT = "0xc2132D05D31c914a87C6611C10748AEb04B58e8F";


    //// ************ DEPLOY ADMIN **************/////

    // const storeFactory = await ethers.getContractFactory("StoreFactory");
    // const StoreFactoryContract = await upgrades.deployProxy(storeFactory, [accounts[0]], { initializer: 'initialize' })
    // //const StoreFactoryContract = storeFactory.attach("0xB208e79c795bf24984B2541489EB7B027FecAbdc");
    // // await new Promise(res => setTimeout(res, 2000));
    // await StoreFactoryContract.deployed();
    // console.log("Store Factory Proxy", StoreFactoryContract.address);

    // await StoreFactoryContract.createStore("DA MILANO", "DA MILANO", "1", accounts[0]);
    // await new Promise(res => setTimeout(res, 12000));

    // const storeAddress = await StoreFactoryContract.storeAddress("1");

    // const store = await ethers.getContractFactory("Store");
    // //const storeContract = await upgrades.deployProxy(store, { initializer: 'initialize' })
    // const storeContract = store.attach(storeAddress);

    // console.log("Store Contract", storeContract.address);

    // await storeContract.createItemContracts("Outfit","o",12555, "item1", accounts[0]);
    // await new Promise(res => setTimeout(res, 12000));

    // const item1Address = await storeContract.itemAddress("item1");

    // console.log("item1Address", item1Address);
    const item1Address = "0xe763A66C57aF3bc28e479b212fb6d6d5B78F0039";
    const item = await ethers.getContractFactory("Item");
    const itemContract = item.attach(item1Address);

    await itemContract.updateSignerAddress(accounts[0]);
    await new Promise(res => setTimeout(res, 10000));
    //await itemContract.mint(accounts[0], "QmZyafXNHR1w4ja3mJHSZWnwZHFikecqnoBkL5VVeC5wbo");

    // await itemContract.updateTotalSupply(12500);



   



}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })

    //https://mumbai.polygonscan.com/address/0x5d8d5952229bb6a1ea224340ab249e4d1add8050