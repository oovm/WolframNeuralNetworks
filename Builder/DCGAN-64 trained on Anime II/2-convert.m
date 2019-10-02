(* ::Package:: *)

SetDirectory@NotebookDirectory[];
params = Import["9999_GENERATOR_weights_and_arch.hdf5", "Data"];


leakyReLU[alpha_] := ElementwiseLayer[Ramp[#] - alpha * Ramp[-#]&];
$NCHW = TransposeLayer[{1<->4, 2<->3, 3<->4}];
getDN[i_, s_ , p_ ] := DeconvolutionLayer[
	"Weights" -> $NCHW@params[
		"/model_weights/conv2d_transpose_" <>
			ToString[i] <> "/conv2d_transpose_" <>
			ToString[i] <> "/kernel:0"
	],
	"Biases" -> params[
		"/model_weights/conv2d_transpose_" <>
			ToString[i] <> "/conv2d_transpose_" <>
			ToString[i] <> "/bias:0"
	],
	"PaddingSize" -> p,
	"Stride" -> s
];
getBN[i_] := BatchNormalizationLayer[
	"Biases" -> params[
		"/model_weights/batch_normalization_" <>
			ToString[i] <> "/batch_normalization_" <>
			ToString[i] <> "/beta:0"
	],
	"Scaling" -> params[
		"/model_weights/batch_normalization_" <>
			ToString[i] <> "/batch_normalization_" <>
			ToString[i] <> "/gamma:0"
	],
	"MovingMean" -> params[
		"/model_weights/batch_normalization_" <>
			ToString[i] <> "/batch_normalization_" <>
			ToString[i] <> "/moving_mean:0"
	],
	"MovingVariance" -> params[
		"/model_weights/batch_normalization_" <>
			ToString[i] <> "/batch_normalization_" <>
			ToString[i] <> "/moving_variance:0"
	],
	"Epsilon" -> 0.001,
	"Momentum" -> 0.9
];


mainNet = NetChain[
	{
		ReshapeLayer[{100, 1, 1}],
		{
			getDN[1, 1, 0],
			getBN[4],
			leakyReLU[0.2]
		},
		{
			getDN[2, 2, 1],
			getBN[5],
			leakyReLU[0.2]
		},
		{
			getDN[3, 2, 1],
			getBN[6],
			leakyReLU[0.2]
		},
		{
			getDN[4, 2, 1],
			getBN[7],
			leakyReLU[0.2]
		},
		{
			ConvolutionLayer[
				"Weights" -> $NCHW@params["/model_weights/conv2d_5/conv2d_5/kernel:0"],
				"Biases" -> params["/model_weights/conv2d_5/conv2d_5/bias:0"],
				"PaddingSize" -> 1,
				"Stride" -> 1
			],
			getBN[8],
			leakyReLU[0.2]
		},
		getDN[5, 2, 1],
		ElementwiseLayer[(Tanh@# + 1) / 2&]
	},
	"Input" -> 100,
	"Output" -> "Image"
]


Export["DCGAN-64 trained on Anime II.WMLF", mainNet]
