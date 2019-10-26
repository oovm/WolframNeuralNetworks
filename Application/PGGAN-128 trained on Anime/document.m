(* ::Package:: *)

(* ::Section:: *)
(*initialization*)


Needs["ForScience`PacletUtils`"];
Clear["Global`*"];
$here = SetDirectory@NotebookDirectory[];


(* ::Section:: *)
(*Settings*)


$name = "PGGAN-128 trained on Anime";
theTutorial = Tutorial[$name];
DocumentationHeader[theTutorial] = {
	"WaifuZoo",
	Orange,
	"Updated at " <> DateString["ISODateTime"]
};


(* ::Text:: *)
(*Usage[theTutorial] = "\*)
(* evaluator[a,b] does something cool.*)
(* evaluator[a,b] does something cool."*)
(*Abstract[theTutorial] = "\*)
(*  This is an abstract with ```formatted``` text. This is a linked symbol: [*List*]. This is a link to another guide: <*Guide/Associations*>.";*)


(* ::Section::Closed:: *)
(*Create Notebook*)


nb = NotebookPut[
	Saveable -> False,
	StyleDefinitions -> ForScience`PacletUtils`Private`CreateStyleDefinitions[
		"Tutorial",
		Flatten@{
			ForScience`PacletUtils`Private`DocumentationOptionValue[
				ForScience`PacletUtils`DocumentationBuilder[theTutorial],
				StyleDefinitions
			]
		}

	],
	Visible -> True,
	TaggingRules -> {
		"NewStyles" -> True,
		"Openers" -> {},
		"Metadata" -> {}
	},
	WindowTitle -> $name
];


NotebookWrite[nb, ForScience`PacletUtils`Private`MakeHeader[theTutorial, "Tutorial"]];
NotebookWrite[nb, Cell[$name, "ObjectName"]];
ForScience`PacletUtils`Private`MakeUsageSection[theTutorial, nb];
ForScience`PacletUtils`Private`MakeGuideAbstract[theTutorial, nb];


(* ::Text:: *)
(*NotebookWrite[nb, Cell[$name, "GuideTitle"]];*)
(*NotebookWrite[nb, Cell[$name, "Title"]];*)
(*NotebookWrite[nb, Cell[$name, "TOCDocumentTitle"]]*)
(*NotebookWrite[nb, Cell[$name, "ContextNameCell"]];*)
(*NotebookWrite[nb, Cell[$name, "ObjectName"]];*)


(* ::Section::Closed:: *)
(*Parse Notebook*)


parseCell[Cell[a_, "Section", c___]] := Block[
	{text},
	text = {
		TextCell[a], 6,
		{TaggingRules, "Openers", "PrimaryExamplesSection", "0"},
		RGBColor[217 / 255, 101 / 255, 0]
	};
	Cell[
		BoxData[TemplateBox[text, "SectionOpener"]],
		"PrimaryExamplesSection",
		"PrimaryExamplesSection",
		WholeCellGroupOpener -> True
	]
];
parseCell[Cell[a_, "Subsection", c___]] := Block[
	{text},
	text = {
		TextCell[a], 0,
		{TaggingRules, "Openers", "ExampleSection", "1"},
		RGBColor[217 / 255, 101 / 255, 0]
	};
	Cell[
		BoxData[TemplateBox[text, "SectionOpener"]],
		"ExampleSection",
		"ExampleSection",
		WholeCellGroupOpener -> True
	]
];
parseCell[Cell[a_, "Text", c___]] := Cell[a, "ExampleText"];
parseCell[a : Cell[CellGroupData[___]]] := a;
parseCell[Cell[a_, "Code", c___]] := Nothing;
parseCell[Cell[a_, "Input", c___]] := Cell[a, "Input"];
exps = Flatten@Import[$name <> " Example.nb"][[1, All, 1, 1]];


NotebookWrite[nb, #]& /@ Map[parseCell, exps]


(* ::Section:: *)
(*Export Notebook*)


NotebookWrite[nb, ForScience`PacletUtils`Private`MakeFooter[theTutorial, "Tutorial"]]
NotebookSave[nb, FileNameJoin[{$here, $name <> ".nb"}]];


Export["Preview.png", Rasterize[nb]]
