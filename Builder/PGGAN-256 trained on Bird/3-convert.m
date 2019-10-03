(* ::Package:: *)

(* ::Subchapter:: *)
(*Import Weights*)


SetDirectory@NotebookDirectory[];
ClearAll["Global`*"];


<< NeuralNetworks`
NeuralNetworks`PixelNormalizationLayer;
file = "PixelNorm.m";
def = NeuralNetworks`Private`ReadDefinitionFile[file, "NeuralNetworks`"];
NeuralNetworks`DefineLayer["PixelNorm", def];


params = Import@"karras2018iclr-lsun-bird-256x256.wxf";


(* ::Subchapter:: *)
(*Pre-defined Structures*)


leakyReLU[alpha_] := ElementwiseLayer[Ramp[#] - alpha * Ramp[-#]&];
$NCHW = TransposeLayer[{1<->4, 2<->3, 3<->4}];
getCN[name_, p_, s_] := ConvolutionLayer[
	"Weights" -> $NCHW[Normal@params[name <> "/weight"]] / Sqrt@s,
	"Biases" -> params[name <> "/bias"],
	"PaddingSize" -> p, "Stride" -> 1
];
getOut[w_, b_] := ConvolutionLayer[
	"Weights" -> $NCHW[Normal@params["G_paper_1/ToRGB_lod0/weight"]] / Sqrt[64 * w],
	"Biases" -> Normal@params["G_paper_1/ToRGB_lod0/bias"] + b
];
getBlock[i_, s1_, s2_] := NetChain[{
	ResizeLayer[Scaled /@ {2, 2}, "Resampling" -> "Nearest"],
	getCN[StringRiffle[{"G_paper_1/", i, "x", i, "/Conv0"}, ""], 1, s1],
	leakyReLU[0.2],
	PixelNormalizationLayer[],
	getCN[StringRiffle[{"G_paper_1/", i, "x", i, "/Conv1"}, ""], 1, s2],
	leakyReLU[0.2],
	PixelNormalizationLayer[]
}];


(* ::Subchapter:: *)
(*Main*)


$part1 = LinearLayer[8192,
	"Weights" -> Transpose[Normal@params["G_paper_1/4x4/Dense/weight"] / 64],
	(*there's no broadcast in Mathematica*)
	"Biases" -> Flatten@TransposeLayer[{1<->2}][ConstantArray[Normal@params["G_paper_1/4x4/Dense/bias"], 16]]
];
$part2 = NetChain@{
	ReshapeLayer[{512, 4, 4}],
	leakyReLU[0.2],
	PixelNormalizationLayer[],
	getCN["G_paper_1/4x4/Conv", 1, 1],
	leakyReLU[0.2],
	PixelNormalizationLayer[]
};


mainNet = NetChain[{
	$part1,
	$part2,
	getBlock[8, 2304, 2304],
	getBlock[16, 2304, 2304],
	getBlock[32, 2304, 2304],
	getBlock[64, 2304, 1152],
	getBlock[128, 1152, 576],
	getBlock[256, 576, 288],
	getOut[7, 0.4]
},
	"Input" -> 512,
	"Output" -> "Image"
]


(* ::Subchapter:: *)
(*Save Models*)


Export["PGAN-256 trained on Bird.WLNet", mainNet]
