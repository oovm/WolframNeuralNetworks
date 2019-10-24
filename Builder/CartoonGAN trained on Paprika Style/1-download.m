(* ::Package:: *)

SetDirectory@NotebookDirectory[];
If[
	!FileExistsQ@"Paprika.h5",
	URLDownload[
		"https://github.com/penny4860/Keras-CartoonGan/raw/master/params/Paprika.h5",
		"Paprika.h5"
	]
]

