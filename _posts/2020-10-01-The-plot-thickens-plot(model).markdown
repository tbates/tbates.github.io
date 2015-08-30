---
layout: post
title: "A picture is worth a thousand words: Getting graphical Figures from OpenMx models"
date: 2020-10-01 00:00
comments: true
categories: models tutorial
---

# "The plot thickens"

#### This page is not finished.

This post explains using plot() to produce figures from OpenMx

You will be used to using `plot` for graphs. umx defines an "S3" function which allows you to do this for RAM models and selected matrix models (mainly twin models).


At its simplest, you just provide a model, and plot() will create a path diagram.

```splus
selVars = c("mpg", "wt", "disp")
myCov = mxData(cov(mtcars[,selVars]), type = "cov", numObs = nrow(mtcars) )
m1 = umxRAM("tim", data = myCov,
	umxPath(c("wt", "disp"), to = "mpg"),
	umxPath("wt", with = "disp"),
	umxPath(var = c("wt", "disp", "mpg"))
)
plot(m1)
```

![model of mpg](/media/plot_the_plot_thickens/1simpleModel.png "A model of Miles/gallon")

plot in fact writes a "[dot](http://graphviz.org/content/dot-language)" file. This is another Bell Labs invention (just like R (or S))to specify "graphs" (for our purposes, objects linked by lines) and lay them out (not an easy problem).

## Inside a Graphviz file

Just so you know what we are working with, here's the .dot file for the model above:

```splus
digraph G {

	mpg [shape = square];
	wt [shape = square];
	disp [shape = square];
	mpg_var [label="0.22", shape = plaintext];
	wt_var [label="1", shape = plaintext];
	disp_var [label="1", shape = plaintext];


	# Single arrow paths
	wt -> mpg [label="-0.54"];
	disp -> mpg [label="-0.36"];

	# Variances
	mpg_var -> mpg;
	wt_var -> wt;
	wt -> disp [dir=both, label="0.89"];
	disp_var -> disp;

	{rank=min ; };
	{rank=same; mpg wt disp};
	{rank=max ; mpg_var wt_var disp_var};

}
```

You can manually edit this (it's just text) to get a different layout.

On Mac, plot will open this file in your default app for .dot files. I set this to [graphviz](http://graphviz.org).

On Mac also, Omnigraffle opens .dot, and allows awsome publication quality graphics. So we can make the above example into this in about 1 minute (I timed it):


![omnigraffle edit of mpg](/media/plot_the_plot_thickens/1simpleModel_omnigraffle.png "A Neat model of Miles/gallon")


## Parameters for plot.MxModel()

The parameters of plot give you a lot of flexibility. You can set the name of the file (it defaults to the model name), show unstandardized output, set the rounding for loadings, choose to show labels rather than estimates of paths, show or hide fixed paths, and means, and error variance.

```splus
plot(model, std = TRUE, digits = 2, dotFilename = "name", pathLabels = c("none", "labels", "both"),
  showFixed = FALSE, showMeans = TRUE, showError = TRUE, ...)

```

#### std and digits

You can optionally output unstandardized output using `std`, and control the precision with `digits`

```splus
plot(m1, std=F, digits = 3)
```

#### file output and filename

The path model can be written to a file (the default is the name of the model with ".dot" suffix.

Don't write any file

```splus
plot(m1, dotFilename = NA)
```

Override the default name

```splus
plot(m1, dotFilename = "my nice example") 

```

Give a full file path

```splus
plot(m1, dotFilename = "~/tmp.dot") # specify a file

```

#### What to show

pathLabels	Whether to show labels on the paths. both will show both the parameter and the label. ("both", "none" or "labels")

showFixed	Whether to show fixed paths (defaults to FALSE)

showMeans	Whether to show means

showError	Whether to show errors
