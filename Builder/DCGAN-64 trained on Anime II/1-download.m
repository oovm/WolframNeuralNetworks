(* ::Package:: *)

SetDirectory@NotebookDirectory[];
If[
	!FileExistsQ@"netG.pth",
	URLDownload[
		"https://github.com/jayleicn/animeGAN/raw/master/netG.pth",
		"netG.pth"
	]
]

