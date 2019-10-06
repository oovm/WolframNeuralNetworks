(* ::Package:: *)

(* ::Subchapter:: *)
(*Import Weights*)


SetDirectory@NotebookDirectory[];
ClearAll["Global`*"];


<< NeuralNetworks`
NeuralNetworks`PixelShuffleLayer;
file = "PixelShuffle.m";
def = NeuralNetworks`Private`ReadDefinitionFile[file, "NeuralNetworks`"];
NeuralNetworks`DefineLayer["PixelShuffle", def];


params = Import["anime_face_generator.h5", "Data"];


(* ::Subchapter:: *)
(*Pre-defined Structures*)


leakyReLU[alpha_] := ElementwiseLayer[Ramp[#] - alpha * Ramp[-#]&];
$NCHW = TransposeLayer[{1<->4, 2<->3, 3<->4}];
getDN[i_, s_, p_] := DeconvolutionLayer[
	"Weights" -> $NCHW@params[
		"/model_weights/conv2d_transpose_" <>
			ToString@i <> "/conv2d_transpose_" <>
			ToString@i <> "/kernel:0"
	],
	"Biases" -> params[
		"/model_weights/conv2d_transpose_" <>
			ToString@i <> "/conv2d_transpose_" <>
			ToString@i <> "/bias:0"
	],
	"PaddingSize" -> p, "Stride" -> s
];
getCN[i_, s_, p_] := ConvolutionLayer[
	"Weights" -> $NCHW@params[
		"/model_weights/conv2d_" <>
			ToString@i <> "/conv2d_" <>
			ToString@i <> "/kernel:0"
	],
	"Biases" -> params[
		"/model_weights/conv2d_" <>
			ToString@i <> "/conv2d_" <>
			ToString@i <> "/bias:0"
	],
	"PaddingSize" -> p, "Stride" -> s
];

getBlock[i_] := NetGraph[
	{
		PaddingLayer[{{0, 0}, {2, 1}, {2, 1}}],
		getCN[i, 1, 0],
		ThreadingLayer[Plus]
	},
	{
		NetPort["Input"] -> 1 -> 2,
		{NetPort["Input"], 2} -> 3 -> NetPort["Output"]
	}
];


(* ::Subchapter:: *)
(*Main*)


mainNet = NetChain[
	{
		LinearLayer[512 * 6 * 6,
			"Weights" -> Transpose@params["/model_weights/dense_3/dense_3/kernel:0"],
			"Biases" -> params["/model_weights/dense_3/dense_3/bias:0"]
		],
		ReshapeLayer[{512, 6, 6}],
		{
			leakyReLU[0.1],
			DropoutLayer[0.2],
			ResizeLayer[Scaled /@ {2, 2}, "Resampling" -> "Linear"],
			getDN[1, 1, 0],
			leakyReLU[0.1]
		},
		{
			ResizeLayer[Scaled /@ {2, 2}, "Resampling" -> "Linear"],
			getDN[2, 1, 0],
			leakyReLU[0.1]
		},
		{
			ResizeLayer[Scaled /@ {2, 2}, "Resampling" -> "Linear"],
			getDN[3, 1, 0],
			leakyReLU[0.1]
		},
		{
			getBlock[8],
			leakyReLU[0.1],
			DropoutLayer[0.2]
		},
		{
			PixelShuffleLayer[2],
			getDN[4, 1, 0],
			leakyReLU[0.1]
		},
		{
			getBlock[9],
			leakyReLU[0.1],
			DropoutLayer[0.2]
		},
		getDN[5, 1, 0]
	},
	"Input" -> 100,
	"Output" -> "Image"
]


(* ::Subchapter:: *)
(*Save Models*)


mainNet[RandomVariate[NormalDistribution[], 100], TargetDevice -> "GPU"]


Export["PGAN-256 trained on Person.WLNet", mainNet]
