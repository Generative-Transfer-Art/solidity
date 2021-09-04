const { expect } = require("chai");
const { waffle } = require("hardhat");
const provider = waffle.provider;

describe("Transfer Art contract", function () {

    let TransferArt;

    beforeEach(async function () {
        [addr1, addr2, addr3, addr4, addr5, ...addrs] = await ethers.getSigners();
        

        TransferArtContract = await ethers.getContractFactory("TransferArt");
        TransferArt = await TransferArtContract.connect(addr1).deploy(addr1.address);
        await TransferArt.deployed();  
        await TransferArt.mint(addr1.address,{value: Math.pow(10, 17) + ""})

        TransferArtWrapperContract = await ethers.getContractFactory("TransferArtOGWrapper");
        TransferArtWrapper = await TransferArtWrapperContract.connect(addr1).deploy(addr1.address, TransferArt.address);
        await TransferArtWrapper.deployed();  

        TestNFTContract = await ethers.getContractFactory("TestNFT");
        TestNFT = await TestNFTContract.deploy();
        await TestNFT.deployed(); 
        await TestNFT.connect(addr1).mint();
      });


    describe("tokenURI", function() {
        it("retrieves successfully", async function(){
            var art = await TransferArt.tokenURI("1");
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
        })
    })

    // wrapper tests

    describe("ownable", function() {
        it("has owner", async function(){
            const owner = await TransferArtWrapper.owner()
            expect(owner).to.equal(addr1.address)
        })
    })

    describe("deposit", function() {
        it("reverts on copies", async function(){
            await TransferArt.connect(addr1).transferFrom(addr1.address, addr2.address, "1");
            await TransferArt.connect(addr1).approve(TransferArt.address, "2")
            await expect(
                TransferArtWrapper.connect(addr1).deposit(addr1.address, addr1.address, "2")
            ).to.be.revertedWith("TransferArtOGWrapper: Only originals")
        })

        it("reverts on copies of copies", async function(){
            await TransferArt.connect(addr1).transferFrom(addr1.address, addr2.address, "1");
            await TransferArt.connect(addr1).transferFrom(addr1.address, addr3.address, "2");
            await TransferArt.connect(addr1).approve(TransferArt.address, "3")
            await expect(
                TransferArtWrapper.connect(addr1).deposit(addr1.address, addr1.address, "3")
            ).to.be.revertedWith("TransferArtOGWrapper: Only originals")
        })

        it("reverts if does not exist", async function(){
            await expect(
                TransferArtWrapper.connect(addr1).deposit(addr1.address, addr1.address, "3")
            ).to.be.revertedWith("ERC721: operator query for nonexistent token")
        })

        it("reverts on copies", async function(){
            await TransferArt.connect(addr1).approve(TransferArtWrapper.address, "1")
            await expect(
                TransferArtWrapper.connect(addr1).deposit(addr1.address, addr1.address, "1")
            ).not.to.be.reverted
            const owner1 = await TransferArt.ownerOf("1")
            expect(owner1).to.equal(TransferArtWrapper.address)
            const owner2 = await TransferArtWrapper.ownerOf("1")
            expect(owner2).to.equal(addr1.address)
        })
    })

    describe("withdraw", function() {
        it("reverts if is not owner", async function(){
            await TransferArt.connect(addr1).approve(TransferArtWrapper.address, "1")
            TransferArt.connect(addr1)['safeTransferFrom(address,address,uint256)'](addr1.address, TransferArtWrapper.address, "1")
            await expect(
                TransferArtWrapper.connect(addr2).withdraw(addr1.address, "1")
            ).to.be.revertedWith("TransferArtOGWrapper: caller is not owner nor approved")
        })

        it("transfers and burns", async function(){
            await TransferArt.connect(addr1).approve(TransferArtWrapper.address, "1")
            await TransferArt.connect(addr1)['safeTransferFrom(address,address,uint256)'](addr1.address, TransferArtWrapper.address, "1")
            var owner1 = await TransferArt.ownerOf("1")
            expect(owner1).to.equal(TransferArtWrapper.address)
            await expect(
                TransferArtWrapper.connect(addr1).withdraw(addr1.address, "1")
            ).not.to.be.reverted
            owner1 = await TransferArt.ownerOf("1")
            expect(owner1).to.equal(addr1.address)
            await expect(
                TransferArtWrapper.ownerOf("1")
            ).to.be.revertedWith("ERC721: owner query for nonexistent token")
        })
    })

    describe("tokenURI", function() {
        it("matches original", async function(){
            await TransferArt.connect(addr1)['safeTransferFrom(address,address,uint256)'](addr1.address, TransferArtWrapper.address, "1")
            const art1 = await TransferArt.tokenURI("1");
            const art2 = await TransferArtWrapper.tokenURI("1");
            expect(art1).to.equal(art2)
        })

        it("reverts if does not exist in contract", async function(){
            await expect(
                TransferArtWrapper.tokenURI("1")
            ).to.be.revertedWith("TransferArtOGWrapper: token does not exist")
        })
    })

    describe("onReceive", function() {
        it("reverts on copies", async function(){
            await TransferArt.connect(addr1).transferFrom(addr1.address, addr2.address, "1");
            await TransferArt.connect(addr1).approve(TransferArt.address, "2")
            await expect(
                TransferArt.connect(addr1)['safeTransferFrom(address,address,uint256)'](addr1.address, TransferArtWrapper.address, "2")
            ).to.be.revertedWith("TransferArtOGWrapper: Only originals")
        })

        it("reverts on copies of copies", async function(){
            await TransferArt.connect(addr1).transferFrom(addr1.address, addr2.address, "1");
            await TransferArt.connect(addr1).transferFrom(addr1.address, addr3.address, "2");
            await TransferArt.connect(addr1).approve(TransferArt.address, "3")
            await expect(
                TransferArt.connect(addr1)['safeTransferFrom(address,address,uint256)'](addr1.address, TransferArtWrapper.address, "3")
            ).to.be.revertedWith("TransferArtOGWrapper: Only originals")
        })

        it("reverts on copies", async function(){
            await TransferArt.connect(addr1).approve(TransferArtWrapper.address, "1")
            await expect(
                TransferArt.connect(addr1)['safeTransferFrom(address,address,uint256)'](addr1.address, TransferArtWrapper.address, "1")
            ).not.to.be.reverted
            const owner1 = await TransferArt.ownerOf("1")
            expect(owner1).to.equal(TransferArtWrapper.address)
            const owner2 = await TransferArtWrapper.ownerOf("1")
            expect(owner2).to.equal(addr1.address)
        })

        it("reverts if sender is not gtap", async function(){
            await expect(
                TestNFT.connect(addr1)['safeTransferFrom(address,address,uint256)'](addr1.address, TransferArtWrapper.address, "1")
            ).to.be.revertedWith("TransferArtOGWrapper: GTAP1 only")
        })
    })
})