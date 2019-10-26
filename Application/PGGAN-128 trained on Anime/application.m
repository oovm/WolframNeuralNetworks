(* ::Package:: *)

(* ::Subsection:: *)
(*Loader*)


SetDirectory@NotebookDirectory[];
NetModel[];
NeuralNetworks`PixelNormalizationLayer;
file = "PixelNorm.m";
def = NeuralNetworks`Private`ReadDefinitionFile[file, "NeuralNetworks`"];
NeuralNetworks`DefineLayer["PixelNorm", def];
$LoadNets = <|
	"Main" -> Import@"PGGAN-128 trained on Anime.WLNet"
|>;


(* ::Subsection:: *)
(*Evaluator*)


Options[evaluator] = {
	MetaInformation -> True,
	TargetDevice -> "GPU"
};
evaluator[NetModel] := AssociationThread[Keys[$LoadNets] -> Values[$LoadNets]];
evaluator[o : OptionsPattern[]] := First@evaluator[1, o];
evaluator[n_Integer, o : OptionsPattern[]] := Module[
	{data},
	If[n < 1, Return[]];
	data = RandomVariate[NormalDistribution[], {n, 512}];
	evaluator[<|"Gene" -> #|>& /@ data, o]
];
evaluator[n_NumericArray, o : OptionsPattern[]] := evaluator[<|"Gene" -> n|>, o];
evaluator[a_Association, o : OptionsPattern[]] := First@evaluator[{a}, o];
evaluator[list : {(_Association)...}, OptionsPattern[]] := Module[
	{eval = $LoadNets["Main"], results, info},
	results = eval[#Gene& /@ list, TargetDevice -> OptionValue@TargetDevice];
	If[!TrueQ[OptionValue@MetaInformation], Return[results]];
	info = <|
		"Gene" -> NumericArray[#Gene, "Real32"],
		"Result" -> #2
	|>&;
	If[
		Length@results == 0,
		info[list, results],
		info @@@ Transpose[{list, results}]
	]
];
