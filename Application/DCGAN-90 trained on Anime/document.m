(* ::Package:: *)

Needs["ForScience`PacletUtils`"];
Clear["Global`*"];
$here = SetDirectory@NotebookDirectory[];
$name = "DCGAN-90 trained on Anime";


myTutorial = Tutorial[$name];
DocumentationHeader[myTutorial] = {"WaifuZoo", Orange};


TutorialSections[myTutorial, "\:57fa\:672c\:64cd\:4f5c", None] = {
	"\:5bfc\:5165\:8fd9\:4e2a\:6a21\:578b:",
	ExampleInput @@ {
		"Quiet@SetDirectory@NotebookDirectory[];",
		"app = Import[\"" <> $name <> ".app\"]"
	},
	"\:751f\:6210\:5355\:4e2a\:7684\:56fe\:6848:",
	ExampleInput[
		"SeedRandom[44];",
		"gen=app[]"
	],
	"Gene \:53ef\:4ee5\:552f\:4e00\:786e\:5b9a\:6700\:540e\:7684\:7ed3\:679c:",
	ExampleInput[
		"gen[\"Gene\"]",
		"app[%][\"Result\"]"
	],
	"\:53ef\:4ee5\:53bb\:9664 Gene \:7b49\:5143\:4fe1\:606f:",

	ExampleInput[
		SeedRandom[44];,
		"app[MetaInformation\[Rule]False]"
	]
};
TutorialSections[myTutorial, "\:8fdb\:9636\:64cd\:4f5c", None] = {
	"\:751f\:6210\:4e00\:4e2a 16 \:5f20\:56fe\:7684\:96c6\:5408:",
	ExampleInput[
		app[16, MetaInformation -> False] // Multicolumn
	],
	"\:76f4\:63a5\:83b7\:5f97\:6838\:5fc3\:7f51\:7edc",
	ExampleInput[
		app[NetModel]
	]
};


(* ::Code:: *)
(**)


nb = DocumentationBuilder[myTutorial];
NotebookSave[nb, FileNameJoin[{$here, "DCGAN-90 trained on Anime.nb"}]];
Export["Preview.png", Rasterize[nb]]
