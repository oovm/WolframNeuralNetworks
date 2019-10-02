(* ::Package:: *)

SetDirectory@NotebookDirectory[];
mainNet = Import@"DCGAN-64 trained on Anime II.WMLF";


inBatch = RandomVariate[NormalDistribution[], {49, 100}];
outBatch = mainNet[inBatch, TargetDevice -> "GPU"];
outBatch // Multicolumn
