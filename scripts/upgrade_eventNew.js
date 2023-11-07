async function main() {

    const Venue = await ethers.getContractFactory("HistoryMetastore")
    //let EventsV1Proxy = await upgrades.forceImport("0xcb89cc98A0aCa08b757C50785c55D580EE91880B", Venue);
    let EventsV1Proxy = await upgrades.upgradeProxy("0xf744e3E70a80A6695cfaA7eE406CF39F249594d9", Venue)
    console.log("Your upgraded proxy is done!", EventsV1Proxy.address);
    console.log(await EventsV1Proxy.owner());
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)    
        process.exit(1)
    })
