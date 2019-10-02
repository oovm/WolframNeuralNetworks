(* ::Package:: *)

SetDirectory@NotebookDirectory[];
If[
	FileExistsQ@"netG_epoch_67.pth",
	URLDownload[
		"https://github.com/acupoftee/MangaGAN/raw/master/netG_epoch_67.pth",
		"netG_epoch_67.pth"
	]
]
