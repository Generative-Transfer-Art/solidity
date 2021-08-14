const { expect } = require("chai");
const { waffle } = require("hardhat");
const provider = waffle.provider;

describe("PawnShop contract", function () {

    let TransferArt;

    beforeEach(async function () {
        [addr1, addr2, addr3, addr4, addr5, ...addrs] = await ethers.getSigners();       


        TransferArtContract = await ethers.getContractFactory("TransferArt");
        TransferArt = await TransferArtContract.connect(addr1).deploy(addr1.address);
        await TransferArt.deployed();  
        await TransferArt.mint(addr1.address,{value: Math.pow(10, 17) + ""})
      });
      
    describe("tokenURI", function() {
        it("retrieves successfully", async function(){
            var art = await TransferArt.tokenURI("1");
            console.log(art)
            var counter  = 0
            while(counter < 6){
                await TransferArt.connect(addr1).transferFrom(addr1.address, addr2.address, "1");
                await TransferArt.connect(addr2).transferFrom(addr2.address, addr3.address, "1");
                await TransferArt.connect(addr3).transferFrom(addr3.address, addr4.address, "1");
                await TransferArt.connect(addr4).transferFrom(addr4.address, addr5.address, "1");
                await TransferArt.connect(addr5).transferFrom(addr5.address, addr1.address, "1");
                counter++
            }
            art = await TransferArt.tokenURI("1");
            console.log(art)
            art = await TransferArt.tokenURI("2");
            console.log(art)
        })
    })


    // describe("mintPawnTicket", function () {
    //     it("sets values correctly", async function(){
    //         await PawnShop.connect(punkHolder).mintPawnTicket(punkId, CryptoPunks.address, interest, loanAmount, DAI.address, blocks, addr4.address)
    //         const ticket = await PawnShop.ticketInfo("1")
    //         expect(ticket.loanAsset).to.equal(DAI.address)
    //         expect(ticket.loanAmount).to.equal(loanAmount)
    //         expect(ticket.collateralID).to.equal(punkId)
    //         expect(ticket.collateralAddress).to.equal(CryptoPunks.address)
    //         expect(ticket.perBlockInterestRate).to.equal(interest)
    //         expect(ticket.blockDuration).to.equal(blocks)
    //         expect(ticket.accumulatedInterest).to.equal(0)
    //     })
    // })
})