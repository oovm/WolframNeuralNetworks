(* ::Package:: *)

SetDirectory@NotebookDirectory[];
params = Import["ACGAN-64 trained on Anime.WLNet"];


Options[netEvaluator] = {
	MetaInformation -> True,
	TargetDevice -> "GPU",
	"Stability" -> 1
};
SetAttributes[netEvaluator, Listable]
netEvaluator[o : OptionsPattern[]] := First@netEvaluator[1, o];
netEvaluator[n_Integer, o : OptionsPattern[]] := Module[
	{hairs, eyes, new, norm = OptionValue[Norm]},
	norm = OptionValue[Norm];
	If[n < 1 || norm <= 0, Return[]];

	hairs = {"Orange", "White", "Aqua", "Gray", "Green", "Red", "Purple", "Pink", "Blue", "Black", "Brown", "Blonde"};
	eyes = {"Gray", "Black", "Orange", "Pink", "Yellow", "Aqua", "Purple", "Green", "Brown", "Red", "Blue"};

	new := <|
		"Gene" -> RandomVariate[NormalDistribution[0, 1 / OptionValue[Norm]], 100],
		"Hair" -> If[MissingQ@dict["Hair"], RandomChoice[hairs], dict["Hair"]],
		"Eye" -> If[MissingQ@dict["Eye"], RandomChoice[eyes], dict["Eye"]]
	|>;


	netEvaluator[ConstantArray[new, n], o]
];
netEvaluator[dict_Association, OptionsPattern[]] := Module[
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




norm = OptionValue[Norm]
If[n < 1 || norm <= 0, Return[]];

hairs = {"Orange", "White", "Aqua", "Gray", "Green", "Red", "Purple", "Pink", "Blue", "Black", "Brown", "Blonde"}
eyes = {"Gray", "Black", "Orange", "Pink", "Yellow", "Aqua", "Purple", "Green", "Brown", "Red", "Blue"}


new := <|
	"Gene" -> RandomVariate[NormalDistribution[0, 1 / OptionValue[Norm]], 100],
	"Hair" -> If[MissingQ@dict["Hair"], RandomChoice[hairs], dict["Hair"]],
	"Eye" -> If[MissingQ@dict["Eye"], RandomChoice[eyes], dict["Eye"]]
|>

ConstantArray[new, n]
