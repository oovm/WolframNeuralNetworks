(* ::Package:: *)

SetDirectory@NotebookDirectory[];
If[
	!FileExistsQ@"netG.pth",
	URLDownload[
		"https://github.com/Gagan6164/GAN-Anime_face_generator/raw/master/netG.pth",
		"netG.pth"
	]
]

