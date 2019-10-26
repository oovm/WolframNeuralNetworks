(* ::Package:: *)

SetDirectory@NotebookDirectory[];
mainNet = Import@"DCGAN-64 trained on Anime IV.WLNet"
example = Import["EvaluationExample.nb"]


CloudExport[
	mainNet, "WLNet",
	CloudObject["https://www.wolframcloud.com/obj/822cc5df-ce67-425f-87b0-f5b3bdf38569"],
	Permissions -> "Public",
	MetaInformation -> <|
		"Name" -> "DCGAN-64 trained on Anime",
		"Date" -> Now
	|>
]


CloudExport[
	example, "NB",
	CloudObject["https://www.wolframcloud.com/obj/b81672fa-1643-44e3-8859-e3d871e5837f"],
	Permissions -> "Public",
	MetaInformation -> <|
		"Name" -> "DCGAN-64 trained on Anime Example",
		"Date" -> Now
	|>
]


ro = ResourceObject[<|
	"Name" -> "DCGAN-64 trained on Anime",
	"Description" -> "Deep Convolutional Generative Adversarial Networks 64\[Times]64 trained on Anime Dataset",
	"ResourceType" -> "NeuralNet",
	"Version" -> "1.1.0",
	"WolframLanguageVersionRequired" -> "12.0",
	"ContentElements" -> <|
		"EvaluationNet" -> CloudObject["https://www.wolframcloud.com/obj/822cc5df-ce67-425f-87b0-f5b3bdf38569"],
		"EvaluationExample" -> CloudObject["https://www.wolframcloud.com/obj/b81672fa-1643-44e3-8859-e3d871e5837f"]
	|>,
	"DefaultContentElement" -> "EvaluationNet",
	"ByteCount" -> ByteCount@mainNet,
	"InputDomains" -> {"Numeric"},
	"Keywords" -> {"GAN", "DCGAN", "Anime"},
	"TaskType" -> {"Image Processing"},
	"TrainingSetData" -> Hyperlink["www.kaggle.com", "https://www.kaggle.com/soumikrakshit/data"],
	"TrainingSetInformation" -> "21551 anime faces scraped from www.getchu.com, all images are resized to 64\[Times]64."
|>]


ResourceSubmit[ro]
