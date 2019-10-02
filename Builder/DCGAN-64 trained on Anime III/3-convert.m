(* ::Package:: *)

<< NeuralNetworks`
SetDirectory@NotebookDirectory[];


raw = Import["netG_epoch_67.wxf"];


leakyReLU[alpha_] := ElementwiseLayer[Ramp[#] - alpha * Ramp[-#]&];
getCN[name_, s_, p_] := ConvolutionLayer[
	"Weights" -> raw["main." <> ToString@name <> ".weight"],
	"Biases" -> None,
	"Stride" -> s,
	"PaddingSize" -> p
]
getDN[name_, s_, p_] := DeconvolutionLayer[
	"Weights" -> raw["main." <> ToString@name <> ".weight"],
	"Biases" -> None,
	"Stride" -> s,
	"PaddingSize" -> p
]
getBN[i_] := BatchNormalizationLayer[
	"Biases" -> raw["main." <> ToString[i] <> ".bias"], "Scaling" -> raw["main." <> ToString[i] <> ".weight"],
	"MovingMean" -> raw["main." <> ToString[i] <> ".running_mean"],
	"MovingVariance" -> raw["main." <> ToString[i] <> ".running_var"],
	"Epsilon" -> 1*^-5,
	"Momentum" -> 0.1
]


mainNet = NetChain[{
	ReshapeLayer[{100, 1, 1}],
	{getDN[0, 1, 0], getBN[1], leakyReLU[0.2]},
	{getDN[3, 2, 1], getBN[4], leakyReLU[0.2]},
	{getDN[6, 2, 1], getBN[7], leakyReLU[0.2]},
	{getDN[9, 2, 1], getBN[10], leakyReLU[0.2]},
	{
		getCN["extra-layers-0.64.conv", 1, 1],
		getBN["extra-layers-0.64.batchnorm"],
		leakyReLU[0.2]
	},
	getDN["final_layer.deconv", 2, 1],
	ElementwiseLayer[(Tanh[2#] + 1) / 2&, "Input" -> {3, 64, 64}]
},
	"Input" -> 100,
	"Output" -> NetDecoder["Image"]
]


Export["DCGAN-64 trained on Anime III.WXF", mainNet]
