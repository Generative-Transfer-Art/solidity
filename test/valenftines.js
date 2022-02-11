const { expect } = require("chai");
const { waffle, ethers } = require("hardhat");
const provider = waffle.provider;

describe("Valenftines contract", function () {

    let Valenftines;
    let earlymintStartTimestamp = 10;
    let mintStartTimestamp = 12;
    let mintEndTimestamp = 50;

    beforeEach(async function () {
        [addr1, addr2, addr3, addr4, addr5, ...addrs] = await ethers.getSigners();
        
        vcd = await ethers.getContractFactory("ValenftinesDescriptors")
        vc = await vcd.deploy()
        await vc.deployed();

        ValenftinesContract = await ethers.getContractFactory("Valenftines", {
        libraries: {
            ValenftinesDescriptors: vc.address,
          }
         });
        Valenftines = await ValenftinesContract.deploy(
            earlymintStartTimestamp,
            mintStartTimestamp,
            mintEndTimestamp,
            "0x25fd86c71603dae2e956a40ee26625eb003ba383dc169089298ce4e86683edad"
        )
        await Valenftines.deployed();  
    });

    describe("tokenURI", function() {
        it("retrieves successfully", async function(){
            await Valenftines.mint(addr1.address, 1, 2, 3, {value: ethers.BigNumber.from(10).pow(18)});
            const art = await Valenftines.tokenURI(1);
            console.log(art);
        })
    });

});
