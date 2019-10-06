(* ::Package:: *)

SetDirectory@NotebookDirectory[];
params = Import["14_31400_GENERATOR.hdf5", "Data"];


leakyReLU[alpha_] := ElementwiseLayer[Ramp[#] - alpha * Ramp[-#]&];
$NCHW = TransposeLayer[{1<->4, 2<->3, 3<->4}];
getEB[name_] := EmbeddingLayer[
	"Weights" -> params["/model_weights/embedding_"
		<> ToString[name] <> "/embedding_"
		<> ToString[name] <> "/embeddings:0"
	]
]
getCN[name_, s_, p_] := DeconvolutionLayer[
	"Weights" -> $NCHW@params[
		"/model_weights/sequential_1/conv2d_"
			<> ToString[name]
			<> "/kernel:0"
	],
	"Biases" -> params[
		"/model_weights/sequential_1/conv2d_"
			<> ToString[name]
			<> "/bias:0"
	],
	"Stride" -> s,
	"PaddingSize" -> p
]
getDN[name_, s_, p_] := DeconvolutionLayer[
	"Weights" -> $NCHW@params[
		"/model_weights/sequential_1/conv2d_transpose_"
			<> ToString[name]
			<> "/kernel:0"
	],
	"Biases" -> params[
		"/model_weights/sequential_1/conv2d_transpose_"
			<> ToString[name]
			<> "/bias:0"
	],
	"Stride" -> s,
	"PaddingSize" -> p
]
getBN[i_] := BatchNormalizationLayer[
	"Biases" -> params[
		"/model_weights/sequential_1/batch_normalization_"
			<> ToString[i]
			<> "/beta:0"
	],
	"Scaling" -> params[
		"/model_weights/sequential_1/batch_normalization_"
			<> ToString[i]
			<> "/gamma:0"
	],
	"MovingMean" -> params[
		"/model_weights/sequential_1/batch_normalization_"
			<> ToString[i]
			<> "/moving_mean:0"
	],
	"MovingVariance" -> params[
		"/model_weights/sequential_1/batch_normalization_"
			<> ToString[i]
			<> "/moving_variance:0"
	],
	"Epsilon" -> 0.001,
	"Momentum" -> 0.5
]


body = NetChain[{
	ReshapeLayer[{116, 1, 1}],
	{getDN[1, 1, 0], getBN[1], leakyReLU[0.2]},
	{getDN[2, 2, 1], getBN[2], leakyReLU[0.2]},
	{getDN[3, 2, 1], getBN[3], leakyReLU[0.2]},
	{getDN[4, 2, 1], getBN[4], leakyReLU[0.2]},
	{getCN[1, 1, 1], getBN[5], leakyReLU[0.2]},
	getDN[5, 2, 1],
	ElementwiseLayer[(Tanh[#] + 1) / 2&]
}]
mainNet = NetGraph[
	<|
		"Generator" -> body,
		"HairColor" -> getEB[1],
		"EyeColor" -> getEB[2],
		"Merge" -> CatenateLayer[]
	|>,
	{
		NetPort["Hair"] -> "HairColor",
		NetPort["Eye"] -> "EyeColor",
		{NetPort["Input"], "HairColor", "EyeColor"} -> "Merge",
		"Merge" -> "Generator" -> NetPort["Output"]
	},
	"Input" -> 100,
	"Output" -> "Image"
]


mainNet[
	<|
		"Input" -> RandomVariate[NormalDistribution[], 100],
		"Hair" -> 11,
		"Eye" -> 1
	|>,
	TargetDevice -> "GPU"
]


(* ::Input:: *)
(**)


body = NetChain[{
	ReshapeLayer[{116, 1, 1}],
	{getDN[1, 1, 0], getBN[1], leakyReLU[0.2]},
	{getDN[2, 2, 0], getBN[2], leakyReLU[0.2]},
	{getDN[3, 2, 0], getBN[3], leakyReLU[0.2]},
	{getDN[4, 2, 0], getBN[4], leakyReLU[0.2]},
	{getCN[1, 1, 0], getBN[5], leakyReLU[0.2]},
	getDN[5, 2, 0],
	ElementwiseLayer[(Tanh[#] + 1) / 2&]
}]
NetDecoder["Image"][
	body[RandomVariate[NormalDistribution[0, 1], 116]]
]
