(* ::Package:: *)

SetDirectory@NotebookDirectory[];


If[
	!FileExistsQ@"anime_96x96.7z",
	URLDownload[
		"https://github.com/peter0749/WGAN-GP-Anime-with-Auxiliary-Classifier/releases/download/0.3.0/anime_96x96.7z",
		"anime_96x96.7z"
	]
]


ExtractArchive["anime_96x96.7z", "7z"]



