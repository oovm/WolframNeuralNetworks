(* ::Package:: *)

SetDirectory@NotebookDirectory[];
mainNet = Import@"CartoonGan trained on Shinkai Style.WLNet"


img = ImageResize[ExampleData[{"TestImage", "Mandrill"}], 256]
newNet = NetReplacePart[mainNet, "Input" -> NetEncoder[{"Image", ImageDimensions@img}]];


newNet[img, TargetDevice -> "GPU"]
