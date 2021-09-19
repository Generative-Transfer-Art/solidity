const { expect } = require("chai");
const { waffle } = require("hardhat");
const provider = waffle.provider;
const { MerkleTree } = require('./helpers/merkleTree.js');

describe("Animal Coloring Book contract", function () {
    let merkleProof

    beforeEach(async function () {
        [addr1, addr2, addr3, addr4, addr5, ...addrs] = await ethers.getSigners();
        
        CreatorContract = await ethers.getContractFactory("Creator");
        Creator = await CreatorContract.deploy()
        await Creator.deployed();

        UnicornContract = await ethers.getContractFactory("Unicorn");
        Unicorn = await UnicornContract.deploy()
        await Unicorn.deployed();

        SkullContract = await ethers.getContractFactory("Skull");
        Skull = await SkullContract.deploy()
        await Skull.deployed();
        
        CatContract = await ethers.getContractFactory("Cat");
        Cat = await CatContract.deploy()
        await Cat.deployed(); 

        MouseContract = await ethers.getContractFactory("Mouse");
        Mouse = await MouseContract.deploy()
        await Mouse.deployed(); 

        BunnyContract = await ethers.getContractFactory("Bunny");
        Bunny = await BunnyContract.deploy()
        await Bunny.deployed(); 


        TransferArtContract = await ethers.getContractFactory("TransferArt");
        TransferArt = await TransferArtContract.connect(addr1).deploy(addr1.address);
        await TransferArt.deployed();  
        await TransferArt.mint(addr1.address,{value: Math.pow(10, 17) + ""})

        TransferArtWrapperContract = await ethers.getContractFactory("TransferArtOGWrapper");
        TransferArtWrapper = await TransferArtWrapperContract.connect(addr1).deploy(addr1.address, TransferArt.address);
        await TransferArtWrapper.deployed();  

        AnimalDescriptorsContract = await ethers.getContractFactory("AnimalDescriptors");
        AnimalDescriptors = await AnimalDescriptorsContract.deploy(Creator.address, Unicorn.address, Skull.address, Cat.address, Mouse.address, Bunny.address)
        await AnimalDescriptors.deployed();  

        AnimalColoringBookDescriptorsContract = await ethers.getContractFactory("AnimalColoringBookDescriptors");
        AnimalColoringBookDescriptors = await AnimalColoringBookDescriptorsContract.deploy(AnimalDescriptors.address)
        await AnimalColoringBookDescriptors.deployed();  

        const elements = [addr1.address, addr2.address];
        const merkleTree = new MerkleTree(elements);

        const root = merkleTree.getHexRoot();
        merkleProof = merkleTree.getHexProof(elements[0]);

        AnimalColoringBookContract = await ethers.getContractFactory("AnimalColoringBook");
        AnimalColoringBook = await AnimalColoringBookContract.connect(addr1).deploy(addr1.address, root, AnimalColoringBookDescriptors.address, TransferArt.address, TransferArtWrapper.address);
        await AnimalColoringBook.deployed(); 

        ColoringBookEraserContract = await ethers.getContractFactory("ColoringBookEraser");
        ColoringBookEraser = await ColoringBookEraserContract.connect(addr1).deploy(addr1.address, AnimalColoringBook.address);
        await ColoringBookEraser.deployed();
        
        await AnimalColoringBook.setEraser(ColoringBookEraser.address);

        AnimalCombineContract = await ethers.getContractFactory("AnimalColoringBookAddressCollection");
        AnimalCombine = await AnimalCombineContract.deploy(addr1.address, AnimalColoringBook.address, AnimalColoringBookDescriptors.address)
        await AnimalCombine.deployed(); 
      });
    
      describe("address collection tokenURI", function() {
        it("retrieves successfully", async function(){
            await AnimalCombine.mint(addr1.address)
            await AnimalColoringBook.mint(addr1.address, true, {value: Math.pow(10, 17) * 3 + ""})
            await AnimalColoringBook.mint(addr1.address, true, {value: Math.pow(10, 17) * 3 + ""})
            await AnimalColoringBook.mint(addr1.address, true, {value: Math.pow(10, 17) * 3 + ""})
            await AnimalColoringBook.mint(addr1.address, true, {value: Math.pow(10, 17) * 3 + ""})
            await AnimalColoringBook.mint(addr1.address, true, {value: Math.pow(10, 17) * 3 + ""})
            await AnimalColoringBook.mint(addr1.address, true, {value: Math.pow(10, 17) * 3 + ""})
            // await AnimalColoringBook.mint(addr1.address, true, {value: Math.pow(10, 17) * 3 + ""})
            var counter = 1
            while(counter < 7){
                var i = 0
                var holder = addr1
                while(i < 4){
                    var next = addrs[Math.floor(Math.random()*addrs.length)]
                    await AnimalColoringBook.connect(holder).transferFrom(holder.address, next.address, counter + "");
                    holder = next
                    i++
                }
                await AnimalColoringBook.connect(holder).transferFrom(holder.address, addr1.address, counter + "");
                counter++
            }
            await AnimalColoringBook.connect(addr1).transferFrom(addr1.address, addr2.address, "1");
            const image = await AnimalCombine.connect(addr1).tokenURI("1")
            console.log(image)
        })
    })
    describe("coloring book tokenURI", function() {
        it("retrieves successfully", async function(){
            await AnimalColoringBook.mint(addr1.address, true, {value: Math.pow(10, 17) * 3 + ""})
            var art = await AnimalColoringBook.tokenURI("1")
            await AnimalColoringBook.connect(addr1).transferFrom(addr1.address, addr2.address, "1");
            await AnimalColoringBook.connect(addr2).transferFrom(addr2.address, addr3.address, "1");
            await AnimalColoringBook.connect(addr3).transferFrom(addr3.address, addr4.address, "1");
            await AnimalColoringBook.connect(addr4).transferFrom(addr4.address, addr5.address, "1");
            await AnimalColoringBook.connect(addr5).transferFrom(addr5.address, addr1.address, "1");
            await ColoringBookEraser.approve(AnimalColoringBook.address, "1")
            await AnimalColoringBook.erase("1", "1")
            await AnimalColoringBook.connect(addr1).transferFrom(addr1.address, addr2.address, "1");
            art = await AnimalColoringBook.tokenURI("1")
            // console.log(art)
        })
    })

    describe("gtap1HolderMint", function() {
        it("allows valid proof to mint", async function(){
            await expect(
                AnimalColoringBook.connect(addr1).gtap1HolderMint(addr1.address, false, merkleProof, {value: Math.pow(10, 17) * 2 + ""})
            ).not.to.be.reverted
            const owner = await AnimalColoringBook.ownerOf("1");
            expect(owner).to.equal(addr1.address)
        })

        it("allows minting 2", async function(){
            await AnimalColoringBook.connect(addr1).gtap1HolderMint(addr1.address, false, merkleProof, {value: Math.pow(10, 17) * 2 + ""})
            var owner = await AnimalColoringBook.ownerOf("1");
            expect(owner).to.equal(addr1.address)
            await AnimalColoringBook.connect(addr1).gtap1HolderMint(addr1.address, false, merkleProof, {value: Math.pow(10, 17) * 2 + ""})
            var owner = await AnimalColoringBook.ownerOf("2");
            expect(owner).to.equal(addr1.address)
            await expect(
                AnimalColoringBook.connect(addr1).gtap1HolderMint(addr1.address, false, merkleProof, {value: Math.pow(10, 17) * 2 + ""})
            ).to.be.revertedWith('AnimalColoringBook: reached max mint')
        })

        it("does not allow address that is not in tree", async function(){
            await expect(
                AnimalColoringBook.connect(addr3).gtap1HolderMint(addr1.address, false, merkleProof, {value: Math.pow(10, 17) * 2 + ""})
            ).to.be.revertedWith("AnimalColoringBook: invalid proof")
        })

        it("does not allow if proof is invalid", async function(){
            const elements = ['0x32ab61fEC224bBFD1cEa38b2FA812a102170CA65'];
            const merkleTree = new MerkleTree(elements);

            const root = merkleTree.getHexRoot();
            merkleProof = merkleTree.getHexProof('0x32ab61fEC224bBFD1cEa38b2FA812a102170CA65');
            await expect(
                AnimalColoringBook.connect(addr1).gtap1HolderMint(addr1.address, false, merkleProof, {value: Math.pow(10, 17) * 2 + ""})
            ).to.be.revertedWith("AnimalColoringBook: invalid proof")
        })

        it("does not allow if proof is invalid with bad address ", async function(){
            const elements = ['0x32ab61fEC224bBFD1cEa38b2FA812a102170CA65'];
            const merkleTree = new MerkleTree(elements);

            const root = merkleTree.getHexRoot();
            merkleProof = merkleTree.getHexProof('0x32ab61fEC224bBFD1cEa38b2FA812a102170CA65');
            await expect(
                AnimalColoringBook.connect(addr3).gtap1HolderMint(addr1.address, false, merkleProof, {value: Math.pow(10, 17) * 2 + ""})
            ).to.be.revertedWith("AnimalColoringBook: invalid proof")
        })

        it("reverts if fee too low", async function(){
            await expect(
                AnimalColoringBook.connect(addr2).gtap1HolderMint(addr1.address, false, merkleProof, {value: Math.pow(10, 17) * 1 + ""})
            ).to.be.revertedWith("AnimalColoringBook: fee too low")
        })

        it("reverts if fee too low", async function(){
            await expect(
                AnimalColoringBook.connect(addr2).gtap1HolderMint(addr1.address, true, merkleProof, {value: Math.pow(10, 17) * 2 + ""})
            ).to.be.revertedWith("AnimalColoringBook: fee too low")
        })

        it("mints eraser if eraser true", async function(){
            await AnimalColoringBook.connect(addr1).gtap1HolderMint(addr1.address, true, merkleProof, {value: Math.pow(10, 17) * 3 + ""})
            const owner = await ColoringBookEraser.ownerOf("1");
            expect(owner).to.equal(addr1.address)
            const art = await ColoringBookEraser.tokenURI("1");
        })

        it("does not mint eraser if eraser false", async function(){
            await AnimalColoringBook.connect(addr1).gtap1HolderMint(addr1.address, false, merkleProof, {value: Math.pow(10, 17) * 3 + ""})
            await expect (
                ColoringBookEraser.ownerOf("1")
            ).to.be.reverted
        })
    })

    describe("gtap1OGHolderMint", function() {
        it("allows if holds GTAP original", async function(){
            await expect(
                AnimalColoringBook.connect(addr1).gtap1OGHolderMint(addr1.address, "1")
            ).not.to.be.reverted
            const owner = await AnimalColoringBook.ownerOf("1")
            expect(owner).to.equal(addr1.address)
        })

        it("does not allow copy", async function(){
            await TransferArt.connect(addr1).transferFrom(addr1.address, addr2.address, "1");
            await expect(
                AnimalColoringBook.connect(addr1).gtap1OGHolderMint(addr1.address, "2")
            ).to.be.reverted
        })

        it("does not allow if not owner", async function(){
            await expect(
                AnimalColoringBook.connect(addr2).gtap1OGHolderMint(addr1.address, "2")
            ).to.be.reverted
        })

        it("does not allow if already minted", async function(){
            AnimalColoringBook.connect(addr1).gtap1OGHolderMint(addr1.address, "1")
            await expect(
                AnimalColoringBook.connect(addr1).gtap1OGHolderMint(addr1.address, "1")
            ).to.be.revertedWith("AnimalColoringBook: reached max mint")
        })

        it("does allow wrapped gtap 1", async function(){
            await TransferArt.connect(addr1)['safeTransferFrom(address,address,uint256)'](addr1.address, TransferArtWrapper.address, "1")
            await expect(
                AnimalColoringBook.connect(addr1).gtap1OGHolderMint(addr1.address, "1")
            ).not.to.be.reverted
            const owner = await AnimalColoringBook.ownerOf("1")
            expect(owner).to.equal(addr1.address)
        })
    })

    describe("erase", function() {
        it("burns the eraser", async function(){
            await AnimalColoringBook.mint(addr1.address, true, {value: Math.pow(10, 17) * 3 + ""})
            await ColoringBookEraser.approve(AnimalColoringBook.address, "1")
            await AnimalColoringBook.erase("1", "1")
            await expect (
                ColoringBookEraser.ownerOf("1")
            ).to.be.reverted
        })

        it('does not allow others to mint', async function(){
            await expect(
                ColoringBookEraser.connect(addr1).mint(addr1.address)
            ).to.be.revertedWith("ColoringBookEraser: Coloring Book Contract only")
        })

        it("reverts if not approved", async function(){
            await AnimalColoringBook.mint(addr1.address, true, {value: Math.pow(10, 17) * 3 + ""})
            await expect (
                AnimalColoringBook.erase("1", "1")
            ).to.be.reverted
        })

        it("resets transferHistory", async function(){
            await AnimalColoringBook.mint(addr1.address, true, {value: Math.pow(10, 17) * 3 + ""})
            await AnimalColoringBook.connect(addr1).transferFrom(addr1.address, addr1.address, "1");
            await AnimalColoringBook.connect(addr1).transferFrom(addr1.address, addr1.address, "1");
            var history = await AnimalColoringBook.transferHistory("1")
            expect(history.length).to.equal(2)
            await ColoringBookEraser.approve(AnimalColoringBook.address, "1")
            await AnimalColoringBook.erase("1", "1")
            history = await AnimalColoringBook.transferHistory("1")
            expect(history.length).to.equal(0)
        })
            
    })

    describe("payOwner", function() {
        it("transfers to to address", async function(){
            const beforeBalance = await provider.getBalance(addr4.address)
            const amount = ethers.BigNumber.from(10).pow(17).mul(3);
            await AnimalColoringBook.mint(addr1.address, true, {value: amount});
            await AnimalColoringBook.connect(addr1).payOwner(addr4.address, amount);
            const afterBalance = await provider.getBalance(addr4.address);
            expect(afterBalance).to.equal(beforeBalance.add(amount));
        })

        it("reverts if not called by owner", async function(){
            await expect(
                AnimalColoringBook.connect(addr2).payOwner(addr4.address, "1")
            ).to.be.revertedWith("Ownable: caller is not the owner")
        })
    })

})