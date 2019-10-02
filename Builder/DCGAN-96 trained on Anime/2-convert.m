(* ::Package:: *)

<< NeuralNetworks`
SetDirectory@NotebookDirectory[];


raw = Import["generator_model.h5", "Data"];


l0z = LinearLayer["Weights" -> raw["/l0z/W"], "Biases" -> raw["/l0z/b"]];
dc[i_] := DeconvolutionLayer[
	"Weights" -> raw["/dc" <> ToString[i] <> "/W"],
	"Biases" -> raw["/dc" <> ToString[i] <> "/b"],
	"Stride" -> 2,
	"PaddingSize" -> 1
]
bn[i_] := BatchNormalizationLayer[
	"Biases" -> raw["/bn" <> ToString[i] <> "/beta"],
	"Scaling" -> raw["/bn" <> ToString[i] <> "/gamma"],
	"Epsilon" -> raw["/bn" <> ToString[i] <> "/N"],
	"MovingMean" -> raw["/bn" <> ToString[i] <> "/avg_mean"],
	"MovingVariance" -> raw["/bn" <> ToString[i] <> "/avg_var"]
]





mainNet = NetChain[
	{
		LinearLayer[6 * 6 * 512, "Weights" -> raw["/l0z/W"], "Biases" -> raw["/l0z/b"]],
		bn["0l"],
		ElementwiseLayer["RectifiedLinearUnit"],
		ReshapeLayer[{512, 6, 6}],
		{dc[1], bn[1], Ramp},
		{dc[2], bn[2], Ramp},
		{dc[3], bn[3], Ramp},
		dc[4], ElementwiseLayer[(Clip[#] + 1) / 2&]
	},
	"Input" -> 100,
	"Output" -> NetDecoder["Image"]
]


Export["DCGAN-96 trained on Anime.WXF", mainNet]
