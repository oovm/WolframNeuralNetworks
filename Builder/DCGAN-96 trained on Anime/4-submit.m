(* ::Package:: *)

ro = ResourceObject[<|
	"Name" -> "DCGAN-128 trained on Landscape",
	"Description" -> "Deep Convolutional Generative Adversarial Networks 128\[Times]128 trained on Landscape Dataset",
	"ResourceType" -> "NeuralNet",
	"Version" -> "1.0.0",
	"WolframLanguageVersionRequired" -> "12.0",
	"ContentElements" -> <|"EvaluationNet" -> mainNet|>,
	"DefaultContentElement" -> "EvaluationNet",
	"ByteCount" -> ByteCount@mainNet,
	"InputDomains" -> {"Numeric"},
	"Keywords" -> {"GAN", "DCGAN", "Landscape"},
	"TaskType" -> {"Image Processing"}
|>]



(* ::Input:: *)
(*ResourceSubmit[ro]*)
