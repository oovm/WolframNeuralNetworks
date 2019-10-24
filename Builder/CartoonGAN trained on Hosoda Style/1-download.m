(* ::Package:: *)

SetDirectory@NotebookDirectory[];
If[
	!FileExistsQ@"Hosoda.h5",
	URLDownload[
		"https://github.com/penny4860/Keras-CartoonGan/raw/master/params/Hosoda.h5",
		"Hosoda.h5"
	]
]

