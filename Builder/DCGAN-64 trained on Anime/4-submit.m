(* ::Package:: *)

(* ::Subchapter:: *)
(*Import Models*)


SetDirectory@NotebookDirectory[];
mainNet = Import@"DCGAN-64 trained on Anime.WLNet";


(* ::Subchapter:: *)
(*Import Models*)


inBatch = RandomVariate[NormalDistribution[], {49, 100}];
outBatch = mainNet[inBatch, TargetDevice -> "GPU"];
outBatch // Multicolumn


(* ::Subchapter:: *)
(*Upload Models*)


CloudExport[
	mainNet,
	"WLNet",
	CloudObject["https://www.wolframcloud.com/obj/822cc5df-ce67-425f-87b0-f5b3bdf38569"],
	Permissions -> "Public",
	MetaInformation -> <|"Name" -> "DCGAN-64 trained on Anime", "Date" -> Now|>
]
local = LocalCache@CloudObject[
	"https://www.wolframcloud.com/obj/822cc5df-ce67-425f-87b0-f5b3bdf38569"
];


CloudObjectInformation[CloudObject["https://www.wolframcloud.com/obj/822cc5df-ce67-425f-87b0-f5b3bdf38569"]]
Import[local, "WLNet"]



