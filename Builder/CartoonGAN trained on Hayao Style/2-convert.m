(* ::Package:: *)

Clear["Global`*"];
SetDirectory@NotebookDirectory[];
params = Import["Hayao.h5", "Data"];


$NCHW = TransposeLayer[{1<->4, 2<->3, 3<->4}];
getPad[n_] := PaddingLayer[{{0, 0}, {n, n}, {n, n}}, Padding -> "Reflected"]
getCN[name_, s_, p_] := ConvolutionLayer[
	"Weights" -> $NCHW@params[ToString[name] <> "/kernel:0"],
	"Biases" -> params[ToString[name] <> "/bias:0"],
	"Stride" -> s, "PaddingSize" -> p
];
getDN[name_, s_, p_] := DeconvolutionLayer[
	"Weights" -> $NCHW@params[ToString[name] <> "/kernel:0"],
	"Biases" -> params[ToString[name] <> "/bias:0"],
	"Stride" -> s, "PaddingSize" -> p
];
getIN[name_] := NormalizationLayer[
	"Biases" -> params[ToString[name] <> "/beta:0"],
	"Scaling" -> params[ToString[name] <> "/gamma:0"],
	"Epsilon" -> 1*^-9
];
getBlock[i_] := NetFlatten@NetGraph[
	{
		{
			getPad[1],
			getCN["/conv" <> ToString[i] <> "_1/conv" <> ToString[i] <> "_1", 1, 0],
			getIN["/in" <> ToString[i] <> "_1/in" <> ToString[i] <> "_1"],
			Ramp,
			getPad[1],
			getCN["/conv" <> ToString[i] <> "_2/conv" <> ToString[i] <> "_2", 1, 0],
			getIN["/in" <> ToString[i] <> "_2/in" <> ToString[i] <> "_2"]
		},
		ThreadingLayer[Plus]
	},
	{
		NetPort["Input"] -> 1,
		{NetPort["Input"], 1} -> 2 -> NetPort["Output"]
	}
];


mainNet = NetChain[{
	{
		getPad[3],
		getCN["/conv1/conv1", 1, 0],
		getIN["/in1/in1"],
		Ramp
	},
	{
		getCN["/conv2_1/conv2_1", 2, 1],
		getCN["/conv2_2/conv2_2", 1, 1],
		getIN["/in2/in2"],
		Ramp
	},
	{
		getCN["/conv3_1/conv3_1", 2, 1],
		getCN["/conv3_2/conv3_2", 1, 1],
		getIN["/in3/in3"],
		Ramp
	},
	getBlock /@ Range[4, 11],
	{
		getDN["/deconv1_1/deconv1_1", 2, 1],
		PaddingLayer[{{0, 0}, {2, 1}, {2, 1}}, Padding -> "Reflected"],
		getCN["/deconv1_2/deconv1_2", 1, 0],
		getIN["/in_deconv1/in_deconv1"],
		Ramp
	},
	{
		getDN["/deconv2_1/deconv2_1", 2, 1],
		PaddingLayer[{{0, 0}, {2, 1}, {2, 1}}, Padding -> "Reflected"],
		getCN["/deconv2_2/deconv2_2", 1, 0],
		getIN["/in_deconv2/in_deconv2"],
		Ramp
	},
	{
		getPad[3],
		getCN["/deconv3/deconv3", 1, 0],
		ElementwiseLayer[(Tanh[#] + 1) / 2&]
	}
},
	"Input" -> "Image",
	"Output" -> "Image"
]


Export["CartoonGan trained on Hayao Style.WLNet", mainNet]
