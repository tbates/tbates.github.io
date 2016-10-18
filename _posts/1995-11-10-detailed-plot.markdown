---
layout: post
title: "plotting"

comments: true
categories: advanced
---

# "The plot thickens"

If you've used R, you'll be used to `plot` for graphical output. With *umx*,  `plot` works for RAM models! And for twin models! 

Just `plot(model)`, and you will get a path diagram display (You might need to install Graphviz, or another viewing app).

```r
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

`plot` writes a "[dot](http://graphviz.org/content/dot-language)" file. This is another Bell Labs invention (just like R (or S))to specify "graphs" (for our purposes, objects linked by lines) and lay them out (not an easy problem).

## Inside a Graphviz file

Just so you know what we are working with, here's the .gv file for the model above:

```r
digraph G {

	mpg  [shape = square];
	wt   [shape = square];
	disp [shape = square];
	mpg_var  [label="0.22", shape = plaintext];
	wt_var   [label="1",    shape = plaintext];
	disp_var [label="1",    shape = plaintext];

	# Single arrow paths
	wt   -> mpg [label="-0.54"];
	disp -> mpg [label="-0.36"];

	# Variances
	mpg_var  -> mpg;
	wt_var   -> wt;
	wt       -> disp [dir=both, label="0.89"];
	disp_var -> disp;

	{rank = min ; };
	{rank = same; mpg wt disp};
	{rank = max ; mpg_var wt_var disp_var};

}
```

You can manually edit this (it's just text) to get a different layout.

On Mac, `plot` will open this file in your default app for .gv files. I set this to [graphviz](http://graphviz.org).

On Mac also, Omnigraffle opens .gv, and allows awesome publication-quality graphics. So we can make the above example into this in about 1 minute (I timed it):


![omnigraffle edit of mpg](/media/plot_the_plot_thickens/1simpleModel_omnigraffle.png "A Neat model of Miles/gallon")

## Parameters for plot.MxModel()

The parameters of plot give you a lot of flexibility. You can set the name of the file (it defaults to the model name), show unstandardized output, set the rounding for loadings, choose to show labels rather than estimates of paths, show or hide fixed paths, and means, and error variance.

```r
plot(model, std = TRUE, digits = 2, file = "name", pathLabels = c("none", "labels", "both"),
  showFixed = FALSE, showMeans = TRUE, showError = TRUE, ...)

```

#### Standardized output and digit rouinding

You can optionally output unstandardized output using `std = FALSE`, and control the precision with `digits = `

```r
plot(m1, std=F, digits = 3)
```

#### Plot style: residuals, means, fixed paths
The correct way to draw a residual is a double headed arrow from an object back to the object. This is the default for `plot`.
Omingraffle doesn't import or allow you to edit these easily, so for omnigraffle editing, you might switch to resid = "line".

For clarity you can turn this off all together with resid = "none".  You can also suppress drawing means, and turn on drawing fixed paths as you choose.

```r
resid = c("circle", "line", "none")
showFixed = FALSE
showMeans = TRUE
```

#### File output and filename

The path model can be written to a file (the default is the name of the model with ".gv" suffix.

Don't write any file

```r
plot(m1, file = NA)
```

Override the default name

```r
plot(m1, file = "my nice example") 

```

Give a full file path

```r
plot(m1, file = "~/tmp.gv") # specify a file

```

#### What to show

`pathLabels`	Whether to show labels on the paths. both will show both the parameter and the label. ("both", "none" or "labels")

`showFixed`	Whether to show fixed paths (defaults to FALSE)

`showMeans`	Whether to show means

`showError`	Whether to show errors
