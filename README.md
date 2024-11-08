# FRENZ - open and composable social protocol where users truly own

Decentralized social needs to be open and composable for everyone to build upon. Users must own what they create.

```bash
# install dependencies
flow dependencies install
```

```bash
# run tests
go run main.go
```

# NFT as social primitives

- ProfileNFT
[x] mint 1 ProfileNFT per account (for now)
[x] owner can edit its content

- FollowNFT
[x] mint to follow user
[x] has a serial #, early followers deserve better for early support
[x] limit 1 mint per user

- FanNFT
[x] pay to mint, each NFT has an expiry date (for now 1 month)
[x] has a serial #, early followers deserve better for early support
[x] unlimited mint
[x] FanNFT can be used as VIP pass to access token gated materials

- PostNFT
[x] unlimited mint
[x] offchain metadata as JSON object (IPFS)
[x] owner can edit its content

- CommentNFT
[x] unlimited mint
[x] owner can edit its content
