(* ::Package:: *)

SetDirectory@NotebookDirectory[];
mainNet = Import@"DCGAN-64 trained on Anime.WLNet"


inBatch = RandomVariate[NormalDistribution[], {49, 100}];
outBatch = mainNet[inBatch, TargetDevice -> "GPU"];
outBatch // Multicolumn


Export["preview.png",ImageResize[ImageCollage[outBatch],512]]


nonpadNet = Import@"DCGAN-64 trained on Anime NP.WLNet"
outBatch = nonpadNet[inBatch, TargetDevice -> "GPU"];
outBatch // Multicolumn
