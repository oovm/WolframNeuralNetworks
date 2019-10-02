(* ::Package:: *)

SetDirectory@NotebookDirectory[];
mainNet= Import@"DCGAN-64 trained on Anime III.WXF";


inBatch=RandomVariate[NormalDistribution[],{25,100}];
outBatch=mainNet[inBatch,TargetDevice->"GPU"];
outBatch//Multicolumn
