const { expect } = require("chai");
const { waffle } = require("hardhat");
const provider = waffle.provider;

describe("Animal Coloring Book contract", function () {
    let AnimalColoringBook;
    let ColoringCoordinator;

    beforeEach(async function () {
        [addr1, addr2, addr3, addr4, addr5, ...addrs] = await ethers.getSigners();

        const randomAddr = ethers.Wallet.createRandom().address;

        AnimalColoringBookContract = await ethers.getContractFactory("AnimalColoringBook");
        AnimalColoringBook = await AnimalColoringBookContract.connect(addr1).deploy(randomAddr, '0x366b330a63dcb8948a0297bd5b9df3e0b4a273058855eb08b46efbfbd3500e5e', randomAddr, randomAddr, randomAddr);
        await AnimalColoringBook.deployed(); 
        await AnimalColoringBook.mint(addr1.address, false, {value: Math.pow(10, 17) * 2 + ""})

        ColoringCoordinatorContract = await ethers.getContractFactory("ColoringCoordinator");
        ColoringCoordinator = await ColoringCoordinatorContract.deploy();
        await ColoringCoordinator.deployed(); 

        ColoringParticipantContract = await ethers.getContractFactory("ColoringParticipant");
        ColoringParticipant1 = await ColoringParticipantContract.deploy(AnimalColoringBook.address, ColoringCoordinator.address);
        await ColoringParticipant1.deployed(); 
        ColoringParticipant2 = await ColoringParticipantContract.deploy(AnimalColoringBook.address, ColoringCoordinator.address);
        await ColoringParticipant2.deployed(); 

        ColoringParticipantFactoryContract = await ethers.getContractFactory("ColoringParticipantFactory");
        ColoringParticipantFactory = await ColoringParticipantFactoryContract.deploy(AnimalColoringBook.address, ColoringCoordinator.address);
        await ColoringParticipantFactory.deployed(); 
      });
    

    describe("color", function() {
        it("reverts if not approved", async function(){
            await AnimalColoringBook.connect(addr1).setApprovalForAll(ColoringCoordinator.address, true)
            await expect(
                ColoringCoordinator.connect(addr1).color(AnimalColoringBook.address, "1", [addr2.address])
            ).to.be.revertedWith("ERC721: transfer caller is not owner nor approved")
            const owner = await AnimalColoringBook.ownerOf("1")
            expect(owner).to.eq(addr1.address)
            const history = await AnimalColoringBook.transferHistory("1")
            expect(history.length).to.eq(0)
        })

        it("reverts if not approved", async function(){
            await AnimalColoringBook.connect(addr1).setApprovalForAll(ColoringCoordinator.address, true)
            await AnimalColoringBook.connect(addr2).setApprovalForAll(ColoringCoordinator.address, true)
            await expect(
                ColoringCoordinator.connect(addr1).color(AnimalColoringBook.address, "1", [addr2.address, addr3.address])
            ).to.be.revertedWith("ERC721: transfer caller is not owner nor approved")
            const owner = await AnimalColoringBook.ownerOf("1")
            expect(owner).to.eq(addr1.address)
            const history = await AnimalColoringBook.transferHistory("1")
            expect(history.length).to.eq(0)
        })

        it("does not revert if approved", async function(){
            await AnimalColoringBook.connect(addr1).setApprovalForAll(ColoringCoordinator.address, true)
            await AnimalColoringBook.connect(addr2).setApprovalForAll(ColoringCoordinator.address, true)
            await AnimalColoringBook.connect(addr3).setApprovalForAll(ColoringCoordinator.address, true)
            await ColoringCoordinator.connect(addr1).color(AnimalColoringBook.address, "1", [addr2.address, addr3.address])
            const owner = await AnimalColoringBook.ownerOf("1")
            expect(owner).to.eq(addr1.address)
            const history = await AnimalColoringBook.transferHistory("1")
            expect(history.length).to.eq(3)
        })

        it("works with participants", async function(){
            await AnimalColoringBook.connect(addr1).setApprovalForAll(ColoringCoordinator.address, true)
            await ColoringCoordinator.connect(addr1).color(AnimalColoringBook.address, "1", [ColoringParticipant1.address, ColoringParticipant2.address])
            const owner = await AnimalColoringBook.ownerOf("1")
            expect(owner).to.eq(addr1.address)
            const history = await AnimalColoringBook.transferHistory("1")
            expect(history.length).to.eq(3)
        })

        it("works with participants from factory", async function(){
            await AnimalColoringBook.connect(addr1).setApprovalForAll(ColoringCoordinator.address, true)
            await ColoringParticipantFactory.createNewColoringParticipantContract()
            await ColoringParticipantFactory.createNewColoringParticipantContract()
            var arr = await ColoringParticipantFactory.participants()
            console.log(arr)
            await ColoringCoordinator.connect(addr1).color(AnimalColoringBook.address, "1", arr)
            const owner = await AnimalColoringBook.ownerOf("1")
            expect(owner).to.eq(addr1.address)
            const history = await AnimalColoringBook.transferHistory("1")
            expect(history.length).to.eq(3)
        })
    })


})