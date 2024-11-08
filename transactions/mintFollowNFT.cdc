
import "NonFungibleToken"
import "FollowNFT"
import "UniversalCollection"
import "MetadataViews"

transaction(referenceId:Address, receiver:Address) {

    let minter :&FollowNFT.Minter
    let collection : &{NonFungibleToken.Receiver}

    prepare(signer: auth(BorrowValue) &Account) {
        self.minter =signer.storage.borrow<&FollowNFT.Minter>(from: /storage/followNFTMinter)!
        let cd = FollowNFT.getCollectionData()
        self.collection = getAccount(receiver).capabilities.borrow<&{NonFungibleToken.Receiver}>(cd.publicPath) ?? panic("Could not get receiver reference to the NFT Collection")
    }

    execute {
        self.minter.mintNFT(referenceId: referenceId, metadata: {"Foo": "Bar"}, receiver:self.collection)
    }
}
