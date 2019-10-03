(* ::Package:: *)

(* ::Subchapter:: *)
(*Import Models*)


SetDirectory@NotebookDirectory[];
Clear["Global`*"];


<< NeuralNetworks`
NeuralNetworks`PixelNormalizationLayer;
file = "PixelNorm.m";
def = NeuralNetworks`Private`ReadDefinitionFile[file, "NeuralNetworks`"];
NeuralNetworks`DefineLayer["PixelNorm", def];


mainNet = Import@"PGAN-256 trained on Cat.WLNet";


(* ::Subchapter:: *)
(*Forward*)


inBatch = RandomVariate[NormalDistribution[], {16, 512}];
outBatch = mainNet[inBatch, TargetDevice -> "GPU"];
outBatch // Multicolumn
