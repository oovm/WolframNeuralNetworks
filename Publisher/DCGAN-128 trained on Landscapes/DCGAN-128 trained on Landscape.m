(* ::Package:: *)

SetDirectory@NotebookDirectory[];
mainNet = Import@"DCGAN-128 trained on Landscape.WLNet"
example = Import["EvaluationExample.nb"]


CloudExport[
	mainNet, "WLNet",
	CloudObject["https://www.wolframcloud.com/obj/09a9c5fc-179c-4427-8149-e047e18b7625"],
	Permissions -> "Public",
	MetaInformation -> <|
		"Name" -> "DCGAN-128 trained on Landscape",
		"Date" -> Now
	|>
]


CloudExport[
	example, "NB",
	CloudObject["https://www.wolframcloud.com/obj/cfe0d5ca-4688-4757-aeac-4e6670b01e89"],
	Permissions -> "Public",
	MetaInformation -> <|
		"Name" -> "DCGAN-128 trained on Landscape Example",
		"Date" -> Now
	|>
]


ro = ResourceObject[<|
	"Name" -> "DCGAN-128 trained on Landscape",
	"Description" -> "Deep Convolutional Generative Adversarial Networks 128\[Times]128 trained on Landscape Dataset",
	"ResourceType" -> "NeuralNet",
	"Version" -> "1.1.0",
	"WolframLanguageVersionRequired" -> "12.0",
	"ContentElements" -> <|
		"EvaluationNet" -> CloudObject["https://www.wolframcloud.com/obj/09a9c5fc-179c-4427-8149-e047e18b7625"],
		"EvaluationExample" -> CloudObject["https://www.wolframcloud.com/obj/cfe0d5ca-4688-4757-aeac-4e6670b01e89"]
	|>,
	"DefaultContentElement" -> "EvaluationNet",
	"ByteCount" -> ByteCount@mainNet,
	"InputDomains" -> {"Numeric"},
	"Keywords" -> {"GAN", "DCGAN", "Landscape"},
	"TaskType" -> {"Image Processing"}
|>]


ResourceSubmit[ro]
