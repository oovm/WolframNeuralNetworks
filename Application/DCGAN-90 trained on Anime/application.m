(* ::Package:: *)

(* ::Section:: *)
(*L*)


Clear["Global`*"];
SetDirectory@NotebookDirectory[];


(* ::Subsection:: *)
(*Saver*)


Serialize := Serialize = ResourceFunction["BinarySerializeWithDefinitions"];
Options[PackNetApplication] = {"Name" -> Automatic};
PackNetApplication[app_, OptionsPattern[]] := Block[
	{name, bin},
	name = If[
		OptionValue["Name"] =!= Automatic,
		OptionValue["Name"],
		Normal[app]["Name"] <> ".app"
	];
	If[FileExistsQ@name, DeleteFile@name];
	bin = CreateFile[name];
	BinaryWrite[bin, Serialize@app];
	Close[bin]
];


(* ::Section:: *)
(*L*)


(* ::Subsection:: *)
(*Evaluator*)


uuid = CreateUUID[];
FunctionRepository`ctx = "`$" <> StringReplace[uuid, "-" -> ""] <> "`";
BeginPackage["FunctionRepository`"];
Begin[FunctionRepository`ctx];


(* ::Subsection:: *)
(*Evaluator*)


$LoadNets = <|
	"Main" -> Import@"D:\\Wolfram-NeuralNetworks\\Builder\\DCGAN-64 trained on Anime\\DCGAN-64 trained on Anime NP.WLNet"
|>


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
	data = RandomVariate[NormalDistribution[], {n, 100}];
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


(* ::Subsection::Closed:: *)
(*NetApplication*)


(* ::Subsubsection:: *)
(*Icon*)


$icon = Block[
	{
		layerCounts = {3, 2, 5, 1},
		graph, vStyle
	},
	graph = GraphUnion @@ MapThread[
		IndexGraph, {
			CompleteGraph /@ Partition[layerCounts, 2, 1],
			FoldList[Plus, 0, layerCounts[[;; -3]]]
		}];
	vStyle = Catenate[Thread /@ Thread[
		TakeList[VertexList[graph], layerCounts] -> ColorData[97] /@ Range@Length[layerCounts]
	]];
	Graph[
		graph,
		GraphLayout -> {"MultipartiteEmbedding", "VertexPartition" -> layerCounts},
		GraphStyle -> "BasicBlack",
		VertexSize -> 0.65,
		VertexStyle -> vStyle,
		ImageSize -> 60
	]
];


(* ::Subsubsection:: *)
(*Object*)


showByte = UnitConvert[Quantity[N@ByteCount@#, "Bytes"], "Megabytes"]&;
NetApplicationQ[asc_?AssociationQ] := AllTrue[{"Name", "UUID", "Date"}, KeyExistsQ[asc, #]&];
NetApplicationQ[___] = False;
NetApplication::illInput = "Illegal parameters, please read the instructions again.";
NetApplication /: MakeBoxes[
	obj : NetApplication[asc_? NetApplicationQ],
	form : (StandardForm | TraditionalForm)
] := Module[
	{above, below},
	above = {
		{BoxForm`SummaryItem[{"Name: ", asc["Name"]}]},
		{BoxForm`SummaryItem[{"Hash: ", asc[MetaInformation, Hash]}]},
		{BoxForm`SummaryItem[{"Date: ", DateString@asc["Date"]}]}
	};
	below = {
		{BoxForm`SummaryItem[{"Byte: ", showByte[asc[Method][NetModel]]}]},
		{BoxForm`SummaryItem[{"UUID: ", asc["UUID"]}]},
		{BoxForm`SummaryItem[{"Link: ", asc[MetaInformation, Hyperlink]}]}
	};
	BoxForm`ArrangeSummaryBox[
		"NetApplication",
		obj, $icon, above, below, form,
		"Interpretable" -> Automatic
	]
];


(* ::Subsubsection:: *)
(*Methods*)


NetApplication /: Normal[NetApplication[s_]] := s;
(*NetApplication[asc_?AssociationQ][New]:=makeNew;*)
(*NetApplication[asc_?AssociationQ][Save]:=doSave;*)
NetApplication[asc_?AssociationQ][Input] := Activate@Lookup[asc, "Example"];
NetApplication[asc_?AssociationQ][Function] := GeneralUtilities`PrintDefinitionsLocal@Lookup[asc, Method];
NetApplication[asc_?AssociationQ][NetModel] := asc[Method][NetModel];
NetApplication[asc_?AssociationQ][MetaInformation] := Lookup[asc, MetaInformation];
NetApplication[this_][args___] := this[Method][args];


(* ::Subsection:: *)
(*Pack*)


Global`PackNetApplication@With[
	{f = evaluator},
	NetApplication[<|
		"Name" -> "DCGAN-90 trained on Anime",
		"UUID" -> Global`uuid,
		"Date" -> Now,
		Method -> f,
		MetaInformation -> <|
			Hyperlink -> Hyperlink[
				"DCGAN-90 trained on Anime",
				"https://github.com/GalAster/WolframNeuralNetworks/tree/master/Application/DCGAN-90%20trained%20on%20Anime"
			],
			Hash -> Hash[f[NetModel], "Expression", "HexString"],
			$Version -> "NetApplication v1.5.1"
		|>
	|>]
]


EndPackage[]


(* ::Section:: *)
(*Test*)


SetDirectory@NotebookDirectory[]
app = Import["DCGAN-90 trained on Anime.app"]
app[] 
