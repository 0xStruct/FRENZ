import "NonFungibleToken"
import "MetadataViews"
import "UniversalCollection"

access(all) contract interface SimpleNFT: NonFungibleToken{

    access(all) nftType:Type

    //TODO: here we cannot override the build in createEmptyCollection method because the post condition will fire in the wrong order
    access(all) fun createEmptyUniversalCollection(): @{NonFungibleToken.Collection} {
        return <- UniversalCollection.createEmptyCollection(type: self.nftType)
    }

    access(all) view fun getCollectionDisplay() : MetadataViews.NFTCollectionDisplay



    access(all) resource interface NFT {
        access(all) fun createEmptyCollection(): @{NonFungibleToken.Collection} {
            return <- UniversalCollection.createEmptyCollection(type: self.getType())
        }
    }

    access(all) resource interface DisplayableNFT:NFT{

        access(all) name :String
        access(all) description :String
        access(all) thumbnail :String

        access(all) fun resolveDisplay() : MetadataViews.Display {
            return MetadataViews.Display(
                name: self.name,
                description: self.description,
                thumbnail: MetadataViews.HTTPFile(
                    url: self.thumbnail
                )
            )
        }
    }

    access(all) view fun getCollectionData() : MetadataViews.NFTCollectionData {
        return UniversalCollection.getCollectionData(self.nftType)
    }

    /// Function that returns all the Metadata Views implemented by a Non Fungible Token
    ///
    /// @return An array of Types defining the implemented views. This value will be used by
    ///         developers to know which parameter to pass to the resolveView() method.
    ///
    access(all) view fun getContractViews(resourceType: Type?): [Type] {
        return [
        Type<MetadataViews.NFTCollectionData>(),
        Type<MetadataViews.NFTCollectionDisplay>()
        ]
    }


    /// Function that resolves a metadata view for this contract.
    ///
    /// @param view: The Type of the desired view.
    /// @return A structure representing the requested view.
    ///
    //
    access(all) fun resolveContractView(resourceType: Type?, viewType: Type): AnyStruct? {
        switch viewType {
        case Type<MetadataViews.NFTCollectionData>():
            return UniversalCollection.getCollectionData(self.nftType)
        case Type<MetadataViews.NFTCollectionDisplay>():
            return self.getCollectionDisplay()
        }
        return nil
    }

}

