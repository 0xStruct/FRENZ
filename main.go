package main

import (
	"fmt"

	"github.com/bjartek/overflow/v2"
	"github.com/fatih/color"
)

func main() {
	fmt.Print("\033[H\033[2J")
	o := overflow.Overflow(overflow.WithPrintResults(), overflow.WithFlowForNewUsers(10.0))

	if o.Error != nil {
		panic(o.Error)
	}

	o.Tx("setupFan", overflow.WithSigner("alice"))
	o.Tx("setupFollow", overflow.WithSigner("alice"))
	o.Tx("setupProfile", overflow.WithSigner("alice"))

	o.Tx("setupFan", overflow.WithSigner("bob"))
	o.Tx("setupFollow", overflow.WithSigner("bob"))
	o.Tx("setupProfile", overflow.WithSigner("bob"))

	message("We have started the emulator, deployed our FRENS NFTs and created two tests users alice and bob")
	pause()

	message("Let's mint NFTs")

	// PROFILES
	o.Tx("mintProfileNFT",
		overflow.WithSignerServiceAccount(),
		overflow.WithArg("receiver", "alice"),
	)

	o.Tx("mintProfileNFT",
		overflow.WithSignerServiceAccount(),
		overflow.WithArg("receiver", "bob"),
	)

	message("Bob follows Alice")
	o.Tx("mintFollowNFT",
		overflow.WithSignerServiceAccount(),
		overflow.WithArg("referenceId", "bob"),
		overflow.WithArg("receiver", "alice"),
	)

	message("Alice follows Bob")
	o.Tx("mintFollowNFT",
		overflow.WithSignerServiceAccount(),
		overflow.WithArg("referenceId", "alice"),
		overflow.WithArg("receiver", "bob"),
	)

	// message("Alice follows Bob again")
	// o.Tx("mintFollowNFT",
	// 	overflow.WithSignerServiceAccount(),
	// 	overflow.WithArg("referenceId", "alice"),
	// 	overflow.WithArg("receiver", "bob"),
	// )

	// FANS
	o.Tx("mintFanNFT",
		overflow.WithSignerServiceAccount(),
		overflow.WithArg("receiver", "bob"),
	)

	o.Tx("mintFanNFT",
		overflow.WithSignerServiceAccount(),
		overflow.WithArg("receiver", "alice"),
	)

}

func pause() {
	fmt.Println()
	color.Yellow("press any key to continue")
	fmt.Scanln()
	fmt.Print("\033[H\033[2J")
}

func message(msg string) {
	fmt.Println()
	color.Green(msg)
}
