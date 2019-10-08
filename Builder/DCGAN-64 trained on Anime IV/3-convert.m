(* ::Package:: *)

SetDirectory@NotebookDirectory[];
Clear["Global`*"];
params = Import@"netG.pth.wxf";


leakyReLU[alpha_] := ElementwiseLayer[Ramp[#] - alpha * Ramp[-#]&];
getDN[i_, s_, p_] := DeconvolutionLayer[
	"Weights" -> params["main." <> ToString[i] <> ".weight"],
	"Biases" -> None, "PaddingSize" -> p, "Stride" -> s
];
getBN[i_] := BatchNormalizationLayer[
	"Biases" -> params["main." <> ToString[i] <> ".bias"],
	"Scaling" -> params["main." <> ToString[i] <> ".weight"],
	"MovingMean" -> params["main." <> ToString[i] <> ".running_mean"],
	"MovingVariance" -> Normal@params["main." <> ToString[i] <> ".running_var"],
	"Epsilon" -> 1*^-5,
	"Momentum" -> 0.1
];


mainNet = NetChain[
	{
		ReshapeLayer[{100, 1, 1}],
		{getDN[0, 1, 0], getBN[1], Ramp},
		{getDN[3, 2, 1], getBN[4], Ramp},
		{getDN[6, 2, 1], getBN[7], Ramp},
		{getDN[9, 2, 1], getBN[10], Ramp},
		getDN[12, 2, 1],
		ElementwiseLayer[(Tanh[# * 1.2] + 1) / 2&, "Output" -> {3, 64, 64}]
	},
	"Input" -> 100,
	"Output" -> "Image"
]


Export["DCGAN-64 trained on Anime IV.WLNet", mainNet]
