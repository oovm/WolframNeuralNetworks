(* ::Package:: *)

SetDirectory@NotebookDirectory[];
mainNet= Import@"DCGAN-64 trained on Anime III.WLNet";


inBatch=RandomVariate[NormalDistribution[],{49,100}];
outBatch=mainNet[inBatch,TargetDevice->"GPU"];
outBatch//Multicolumn
