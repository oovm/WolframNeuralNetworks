(* ::Package:: *)

SetDirectory@NotebookDirectory[];
mainNet= Import@"DCGAN-128 trained on Landscape.WXF";


inBatch=RandomVariate[NormalDistribution[],{16,100}];
outBatch=mainNet[inBatch,TargetDevice->"GPU"];
outBatch//Multicolumn
