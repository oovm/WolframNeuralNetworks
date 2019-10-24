(* ::Package:: *)

SetDirectory@NotebookDirectory[];
If[
	!FileExistsQ@"Hayao.h5",
	URLDownload[
		"https://github.com/penny4860/Keras-CartoonGan/raw/master/params/Hayao.h5",
		"Hayao.h5"
	]
]
