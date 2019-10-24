(* ::Package:: *)

SetDirectory@NotebookDirectory[];
If[
	!FileExistsQ@"Shinkai.h5",
	URLDownload[
		"https://github.com/penny4860/Keras-CartoonGan/raw/master/params/Shinkai.h5",
		"Shinkai.h5"
	]
]

