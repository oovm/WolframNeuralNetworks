(* ::Package:: *)

SetDirectory@NotebookDirectory[];
Clear["Global`*"];
params = Import@"netG.pth.wxf";


leakyReLU[alpha_] := ElementwiseLayer[Ramp[#] - alpha * Ramp[-#]&];
getDN[i_, s_, p_] := DeconvolutionLayer[
	"Weights" -> params["main." <> ToString[i] <> ".weight"],
	"Biases" -> None, "PaddingSize" -> p, "Stride" -> s
];
(*Solve[V1+10^-5\[Equal]V2+10^-3,V2]*)
fixV = -99 / 100000 + #&;
getBN[i_] := BatchNormalizationLayer[
	"Biases" -> params["main." <> ToString[i] <> ".bias"],
	"Scaling" -> params["main." <> ToString[i] <> ".weight"],
	"MovingMean" -> params["main." <> ToString[i] <> ".running_mean"],
	"MovingVariance" -> fixV@Normal@params["main." <> ToString[i] <> ".running_var"]
];


mainNet = NetChain[{
	ReshapeLayer[{100, 1, 1}],
	{getDN[0, 1, 0], getBN[1] , leakyReLU[0.2]},
	{getDN[3, 2, 1], getBN[4] , leakyReLU[0.2]},
	{getDN[6, 2, 1], getBN[7] , leakyReLU[0.2]},
	{getDN[9, 2, 1], getBN[10] , leakyReLU[0.2]},
	{
		ConvolutionLayer[
			"Weights" -> params["main.extra-layers-0.64.conv.weight"],
			"Biases" -> None, "PaddingSize" -> 1, "Stride" -> 1
		],
		getBN["extra-layers-0.64.batchnorm"],
		leakyReLU[0.2]
	},
	getDN["final_layer.deconv", 2, 1],
	ElementwiseLayer[(Tanh[#*1.414]+1)/2&, "Output" -> {3, 64, 64}]
},
	"Input" -> 100,
	"Output" -> "Image"
]


Export["DCGAN-64 trained on Anime.WLNet", mainNet]


nonpadNet = NetChain[{
	ReshapeLayer[{100, 1, 1}],
	{getDN[0, 1, 0], getBN[1] , leakyReLU[0.2]},
	{getDN[3, 2, 0], getBN[4] , leakyReLU[0.2]},
	{getDN[6, 2, 0], getBN[7] , leakyReLU[0.2]},
	{getDN[9, 2, 0], getBN[10] , leakyReLU[0.2]},
	{
		ConvolutionLayer[
			"Weights" -> params["main.extra-layers-0.64.conv.weight"],
			"Biases" -> None, "PaddingSize" -> 0, "Stride" -> 1
		],
		getBN["extra-layers-0.64.batchnorm"],
		leakyReLU[0.2]
	},
	getDN["final_layer.deconv", 2, 0],
	ElementwiseLayer[(Tanh[#*1.414]+1)/2&, "Output" -> {3, Automatic, Automatic}]
},
	"Input" -> 100,
	"Output" -> "Image"
]


Export["DCGAN-64 trained on Anime NP.WLNet", nonpadNet]
