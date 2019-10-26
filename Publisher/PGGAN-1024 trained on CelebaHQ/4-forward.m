(* ::Package:: *)

(* ::Subchapter:: *)
(*Import Models*)


SetDirectory@NotebookDirectory[];
ClearAll["Global`*"];


<< NeuralNetworks`
NeuralNetworks`PixelNormalizationLayer;
file = "PixelNorm.m";
def = NeuralNetworks`Private`ReadDefinitionFile[file, "NeuralNetworks`"];
NeuralNetworks`DefineLayer["PixelNorm", def];


mainNet= Import@"PGAN-1024 trained on CelebaHQ.WLNet";


(* ::Subchapter:: *)
(*Forward*)


inBatch=RandomVariate[NormalDistribution[],{16,512}];
outBatch=mainNet[inBatch,TargetDevice->"GPU"];
outBatch//Multicolumn
rg=MinMax@Flatten[ImageData/@#]&;
rg@outBatch



