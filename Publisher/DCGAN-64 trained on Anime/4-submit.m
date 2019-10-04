(* ::Package:: *)

(* ::Subsection:: *)
(*Resource retrieval*)


(* ::Text:: *)
(*Get the pre-trained net:*)


SetDirectory@NotebookDirectory[];
mainNet = Import@"DCGAN-64 trained on Anime IV.WLNet"


ResourceObject[<|
	"Name" -> "DCGAN-128 trained on Landscape",
	"Description" -> "Deep Convolutional Generative Adversarial Networks 64\[Times]64 trained on Anime Dataset",
	"ResourceType" -> "NeuralNet",
	"Version" -> "1.1.0",
	"WolframLanguageVersionRequired" -> "12.0",
	"ContentElements" -> <|
	"EvaluationNet" -> File["DCGAN-64 trained on Anime IV.WLNet"],
	"EvaluationExample"->File["EvaluationExample.nb"]
	|>,
	"DefaultContentElement" -> "EvaluationNet",
	"ByteCount" -> ByteCount@mainNet,
	"InputDomains" -> {"Numeric"},
	"Keywords" -> {"GAN", "DCGAN", "Landscape"},
	"TaskType" -> {"Image Processing"}
|>]
