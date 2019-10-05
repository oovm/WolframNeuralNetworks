(* ::Package:: *)

<< NeuralNetworks`
SetDirectory@NotebookDirectory[];


rawNet = ImportTorchNet@"landscapes_776_net_G.t7";


mainNet = NetChain[
	{
		ReshapeLayer[{100, 1, 1}],
		NetTake[rawNet, {1, 3}],
		NetTake[rawNet, {4, 6}],
		NetTake[rawNet, {7, 9}],
		NetTake[rawNet, {10, 12}],
		NetTake[rawNet, {13, 15}],
		NetExtract[rawNet, 16],
		ElementwiseLayer[(Tanh[#] + 1) / 2&, "Output" -> {3, 128, 128}]
	},
	"Input" -> 100,
	"Output" -> NetDecoder["Image"]
]


Export["DCGAN-128 trained on Landscape.WLNet", mainNet]
