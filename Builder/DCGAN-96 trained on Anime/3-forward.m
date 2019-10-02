(* ::Package:: *)

SetDirectory@NotebookDirectory[];
mainNet= Import@"DCGAN-96 trained on Anime.WXF";


inBatch=RandomVariate[UniformDistribution[{-1,1}],{36,100}];
outBatch=mainNet[inBatch,TargetDevice->"GPU"];
outBatch//Multicolumn
