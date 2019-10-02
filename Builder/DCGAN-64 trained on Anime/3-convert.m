(* ::Package:: *)

SetDirectory@NotebookDirectory[];
params = Import@"netG.pth.wxf";


leakyReLU[alpha_] := ElementwiseLayer[Ramp[#] - alpha * Ramp[-#]&];
getDN[i_, p_ : 1, s_ : 2] := DeconvolutionLayer[
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


decoder = NetDecoder["Image"];
mainNet = NetChain[{
	ReshapeLayer[{100, 1, 1}],
	{getDN[0, 0, 1], getBN[1] , leakyReLU[0.2]},
	{getDN[3, 1, 2], getBN[4] , leakyReLU[0.2]},
	{getDN[6, 1, 2], getBN[7] , leakyReLU[0.2]},
	{getDN[9, 1, 2], getBN[10] , leakyReLU[0.2]},
	{
		ConvolutionLayer[
			"Weights" -> params["main.extra-layers-0.64.conv.weight"],
			"Biases" -> None, "PaddingSize" -> 1, "Stride" -> 1
		],
		getBN["extra-layers-0.64.batchnorm"],
		leakyReLU[0.2]
	},
	getDN["final_layer.deconv", 1, 2],
	ElementwiseLayer[Tanh[#] / 2 + 0.5&, "Output" -> {3, 64, 64}]
},
	"Input" -> 100,
	"Output" -> decoder
]


Export["DCGAN-64 trained on Anime.WLNet",mainNet]
