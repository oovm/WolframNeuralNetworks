(* ::Package:: *)

SetDirectory@NotebookDirectory[];
mainNet = Import@"DCGAN-64 trained on Anime IV.WLNet";


inBatch = RandomVariate[NormalDistribution[], {49, 100}];
outBatch = mainNet[inBatch, TargetDevice -> "GPU"];
outBatch // Multicolumn


Export["preview.png", ImageResize[ImageCollage[outBatch], 512]]
