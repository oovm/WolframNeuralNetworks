(* ::Package:: *)

SetDirectory@NotebookDirectory[];
If[
	!FileExistsQ@"14_31400_GENERATOR.hdf5",
	URLDownload[
		"https://github.com/CryoliteZ/Anime-Face-ACGAN/raw/master/pretrained_models/14_31400_GENERATOR.hdf5",
		"14_31400_GENERATOR.hdf5"
	]
]
