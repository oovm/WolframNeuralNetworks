(* ::Package:: *)

(* ::Section::Closed:: *)
(*4*)


Needs["ForScience`PacletUtils`"];
Clear["Global`*"];
$here = SetDirectory@NotebookDirectory[];


(* ::Section:: *)
(*4*)


$name = "DCGAN-90 trained on Anime";
theTutorial = Tutorial[$name];
DocumentationHeader[theTutorial] = {
"WaifuZoo", 
Orange, 
"Updated at " <> DateString["ISODateTime"]
};
Usage[theTutorial] = "\
foo[a,b] does something cool.
foo[a,b] does something cool."
Abstract[theTutorial] = "\
This is an abstract with ```formatted``` text. This is a linked symbol: [*List*]. This is a link to another guide: <*Guide/Associations*>.";


(* ::Section::Closed:: *)
(*4*)


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


(* ::Section:: *)
(*4*)


NotebookWrite[nb,
	Cell[
		BoxData[TemplateBox[{TextCell["Basic"], 6, {TaggingRules, "Openers", "PrimaryExamplesSection", "0"}, RGBColor[217 / 255, 101 / 255, 0]}, "SectionOpener"]],
		"PrimaryExamplesSection",
		"PrimaryExamplesSection",
		WholeCellGroupOpener -> True
	]
]
NotebookWrite[nb,
	Cell[
		BoxData[TemplateBox[{Cell[TextData[{"Advance", "\[NonBreakingSpace]\[NonBreakingSpace]", Cell["(4)", "ExampleCount"]}]], 0, {TaggingRules, "Openers", "ExampleSection", "0"}, RGBColor[217 / 255, 101 / 255, 0]}, "SectionOpener"]],
		"ExampleSection",
		"ExampleSection",
		WholeCellGroupOpener -> True
	]
];
NotebookWrite[nb,
	Cell["\:5bfc\:5165\:8fd9\:4e2a\:6a21\:578b:", "ExampleText"]
]
NotebookWrite[nb,
	Cell["\t","ExampleDelimiter"]
]
NotebookWrite[nb,
	Cell["\:751f\:6210\:5355\:4e2a\:7684\:56fe\:6848:", "ExampleText"]
]
NotebookWrite[nb,
	Cell["Gene \:53ef\:4ee5\:552f\:4e00\:786e\:5b9a\:6700\:540e\:7684\:7ed3\:679c:", "ExampleText"]
]
NotebookWrite[nb,
	Cell["\:53ef\:4ee5\:53bb\:9664 Gene \:7b49\:5143\:4fe1\:606f:", "ExampleText"]
]


(* ::Section::Closed:: *)
(*4*)


NotebookWrite[nb, ForScience`PacletUtils`Private`MakeFooter[theTutorial, "Tutorial"]]


(* ::Section:: *)
(*4*)


NotebookSave[nb, FileNameJoin[{$here, $name <> ".nb"}]];
Export["Preview.png", Rasterize[nb]]
