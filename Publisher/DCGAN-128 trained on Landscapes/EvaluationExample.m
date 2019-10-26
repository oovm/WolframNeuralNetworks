(* ::Package:: *)

(* ::ResourceExampleTitle::RGBColor[{Rational[31, 85], Rational[146, 255], Rational[11, 85]}]:: *)
(*DCGAN-64 trained on Anime*)


(* ::ResourceExampleSubtitle::RGBColor[{Rational[1, 3], Rational[1, 3], Rational[1, 3]}]::Italic:: *)
(*Deep Convolutional GAN trained on Anime Dataset*)


(* ::Subsection:: *)
(*Resource retrieval*)


(* ::Text:: *)
(*Get the pre-trained net:*)


SetDirectory@NotebookDirectory[];
mainNet = Import@"DCGAN-64 trained on Anime IV.WLNet"


(* ::Subsection:: *)
(*Evaluation function*)


(* ::Text:: *)
(*Defining the evaluate function:*)


Options[netEvaluator] = {
	MetaInformation -> True,
	TargetDevice -> "GPU"
};
netEvaluator[o : OptionsPattern[]] := netEvaluator[
	RandomVariate[NormalDistribution[], 100], o
];
netEvaluator[ary_NumericArray, o : OptionsPattern[]] := netEvaluator[
	Normal@ary, o
];
netEvaluator[n_Integer, o : OptionsPattern[]] := Module[
	{data},
	If[n < 1, Return[]];
	data = If[
		n == 1,
		RandomVariate[NormalDistribution[], 100],
		RandomVariate[NormalDistribution[], {n, 100}]
	];
	netEvaluator[data, o]
];
netEvaluator[list_List, OptionsPattern[]] := Module[
	{eval = mainNet, results, info},
	results = eval[list, TargetDevice -> OptionValue@TargetDevice];
	If[!TrueQ[OptionValue@MetaInformation], Return[results]];
	info = <|
		"Gene" -> NumericArray[#1, "Real32"],
		"Result" -> #2
	|>&;
	If[
		Length@results == 0,
		info[list, results],
		info @@@ Transpose[{list, results}]
	]
];


(* ::Subsubsection:: *)
(*Basic usage*)


(* ::Text:: *)
(*Run the net with random seeds:*)


SeedRandom[42];
gen = netEvaluator[]


(* ::Text:: *)
(*Run the net with given seeds:*)


netEvaluator[gen["Gene"]]


(* ::Text:: *)
(*Run the net with multi-outputs:*)


SeedRandom[42];
netEvaluator[4] // Dataset


(* ::Subsection:: *)
(*Options*)


(* ::Subsubsection:: *)
(*MetaInformation*)


(* ::Text:: *)
(*Return output with only images:*)


SeedRandom[42];
netEvaluator[MetaInformation -> False]


(* ::Text:: *)
(*Display generated images:*)


SeedRandom[42];
netEvaluator[49, MetaInformation -> False] // Multicolumn


(* ::Subsection:: *)
(*Net information*)


(* ::Text:: *)
(*Inspect the  number of parameters of all arrays in the net:*)


NetInformation[mainNet, "ArraysElementCounts"] // Dataset


(* ::Text:: *)
(*Obtain the total number of parameters:*)


NetInformation[mainNet, "ArraysTotalElementCount"]


(* ::Text:: *)
(*Obtain the layer type counts:*)


NetInformation[mainNet, "LayerTypeCounts"] // Dataset


(* ::Text:: *)
(*Display the summary graphic:*)


NetInformation[mainNet, "SummaryGraphic"]


(* ::Text:: *)
(*Display the node graph:*)


NetInformation[mainNet, "MXNetNodeGraphPlot"]
