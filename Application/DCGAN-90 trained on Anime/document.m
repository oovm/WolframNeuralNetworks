(* ::Package:: *)

SetDirectory@NotebookDirectory[];
Needs["ForScience`PacletUtils`"]
$name = "DCGAN-90 trained on Anime";


myTutorial = Tutorial["Example tutorial"];
DocumentationHeader[myTutorial] = {"TEST TUTORIAL", Orange};


TutorialSections[myTutorial, None] = {
	"This tutorial page was generated fully automatically. The text can contain links to other pages (e.g. [*List*]) and ```other``` '''formatting'''.",
	"\:9996\:5148\:5bfc\:5165\:6a21\:578b:",
	Echo[ExampleInput @@ {
		"Quiet@SetDirectory@NotebookDirectory[];",
		"app = Import[\"" <> $name <> ".app\"]"
	}, "In-1: "]
};
TutorialSections[myTutorial, "A section", None] = {
	"This is another section of the tutorial."
};
TutorialSections[myTutorial, "A section", "A subsection"] = {
	"This is a subsection of the tutorial."
};


(* ::Code:: *)
(**)


nb = DocumentationBuilder[myTutorial]
NotebookSave[nb, "DCGAN-90 trained on Anime.nb"]
