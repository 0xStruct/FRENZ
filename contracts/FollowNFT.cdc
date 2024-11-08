import "NonFungibleToken"
import "MetadataViews"
import "ViewResolver"
import "SimpleNFT"

access(all) contract FollowNFT : SimpleNFT{


    access(all) let minterPath : StoragePath
    access(all) event Minted(id: UInt64, uuid: UInt64, to: Address?, type: String)

    access(all) let nftType: Type

    access(all) var totalSupply: UInt64
    access(self) var mints: {Address: [Address]}

    /// The only thing that an NFT really needs to have is this resource definition
    access(all) resource NFT: SimpleNFT.DisplayableNFT, NonFungibleToken.NFT{
        /// Arbitrary trait mapping metadata
        access(self) let metadata: {String: AnyStruct}

        access(all) let id:UInt64
        access(all) let referenceId:Address
        access(all) let name :String
        access(all) let description :String
        access(all) let thumbnail :String

        init(
            referenceId: Address,
            metadata: {String: AnyStruct},
        ) {
            self.id=self.uuid
            self.referenceId = referenceId
            self.metadata = metadata
            self.name="foo"
            self.description="bar"
            self.thumbnail="http://foo.bar"
        }

        /// Uses the basic NFT views
        access(all) view fun getViews(): [Type] {
            return [
            Type<MetadataViews.Display>(),
            Type<MetadataViews.Traits>(),
            Type<MetadataViews.NFTCollectionDisplay>(),
            Type<MetadataViews.NFTCollectionData>()
            ]
        }

        access(all) fun resolveView(_ view: Type): AnyStruct? {
            switch view {
                case Type<MetadataViews.Display>(): return self.resolveDisplay()
                case Type<MetadataViews.Traits>(): return MetadataViews.dictToTraits(dict: self.metadata, excludedNames: nil)
                case Type<MetadataViews.NFTCollectionData>(): return FollowNFT.getCollectionData()
                case Type<MetadataViews.NFTCollectionDisplay>(): return FollowNFT.getCollectionDisplay()
            }
            return nil
        }

        access(all) fun createEmptyCollection(): @{NonFungibleToken.Collection} {
            return <- FollowNFT.createEmptyCollection(nftType: Type<@FollowNFT.NFT>())
        }
    }


    access(all) view fun getCollectionDisplay() : MetadataViews.NFTCollectionDisplay {

        let media = MetadataViews.Media(
            file: MetadataViews.HTTPFile(
                url: "https://assets.website-files.com/5f6294c0c7a8cdd643b1c820/5f6294c0c7a8cda55cb1c936_Flow_Wordmark.svg"
            ),
            mediaType: "image/svg+xml"
        )
        return MetadataViews.NFTCollectionDisplay(
            name: "The Example Collection",
            description: "This collection is used as an example to help you develop your next Flow NFT.",
            externalURL: MetadataViews.ExternalURL("https://example-nft.onflow.org"),
            squareImage: media,
            bannerImage: media,
            socials: {
                "twitter": MetadataViews.ExternalURL("https://twitter.com/flow_blockchain")
            }
        )
    }

    access(all) resource Minter {
        access(all) fun mintNFT(referenceId: Address, metadata: {String: AnyStruct}, receiver : &{NonFungibleToken.Receiver}){
            
            pre {
                !FollowNFT.mints.containsKey(referenceId) || FollowNFT.mints[referenceId]?.length! == 0  : "only 1 follow allowed"
            }
            let nft <- create NFT(referenceId: referenceId, metadata: metadata)

            FollowNFT.totalSupply = FollowNFT.totalSupply + 1
            let followers: [Address] = FollowNFT.mints.containsKey(referenceId) ? FollowNFT.mints[referenceId]! : []
            followers.append(receiver.owner?.address!)
            
            FollowNFT.mints.insert(key: referenceId, followers)

            emit Minted(id: nft.id, uuid:nft.uuid, to: receiver.owner?.address, type: Type<@FollowNFT.NFT>().identifier)
            receiver.deposit(token: <- nft)
        }
    }

    //I really do not want this method here, but i need to because of an bug in inheritance of interface 
    access(all) fun createEmptyCollection(nftType: Type): @{NonFungibleToken.Collection} {
        return <- FollowNFT.createEmptyUniversalCollection()
    }

    init() {
        let minter <- create Minter()
        self.nftType= Type<@FollowNFT.NFT>() //we cannot have generics so we make a poor mans generics

        self.minterPath=/storage/followNFTMinter
        self.account.storage.save(<-minter, to: self.minterPath)

        self.totalSupply = 0
        self.mints = {}
    }
}


