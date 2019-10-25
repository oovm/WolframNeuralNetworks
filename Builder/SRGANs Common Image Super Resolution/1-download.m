(* ::Package:: *)

SetDirectory@NotebookDirectory[];
MonitoredDownload = ResourceFunction["MonitoredDownload"];
If[
	!FileExistsQ@"14_31400_GENERATOR.hdf5",
	MonitoredDownload[
		"https://github.com/CryoliteZ/Anime-Face-ACGAN/raw/master/pretrained_models/14_31400_GENERATOR.hdf5",
		"14_31400_GENERATOR.hdf5"
	]
];
If[
	!FileExistsQ@"14_31400_GENERATOR.hdf5",
	MonitoredDownload[
		"https://github.com/CryoliteZ/Anime-Face-ACGAN/raw/master/pretrained_models/14_31400_GENERATOR.hdf5",
		"14_31400_GENERATOR.hdf5"
	]
];
If[
	!FileExistsQ@"14_31400_GENERATOR.hdf5",
	MonitoredDownload[
		"https://github.com/CryoliteZ/Anime-Face-ACGAN/raw/master/pretrained_models/14_31400_GENERATOR.hdf5",
		"14_31400_GENERATOR.hdf5"
	]
];
