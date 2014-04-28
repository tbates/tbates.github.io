---
layout: post
title: "Values and why they are important"
date: 2020-10-04 00:00
comments: true
categories: models tutorial
---

### Values matter!

Values matter. In OpenMx, values matter even more. They are where the model starts, and, once run, they are the best estimates of our parameters.

**Core concept in OpenMx**
Parameters know three things: Whether they are free, what their current value is, and, critically, what their label is.

In this tutorial, we are going to [set](#setStarts) values, [get values](#getValues). In more [advanced tutorials](), we can equate values using [constraints]() and labels.

### setting start values

Set values in a matrix

``` splus
mxMatrix(name="IamAllOnes", type="Full", nrow=1, ncol=3, values=1, label=labels, byrow = T)

```

Tip: R fills by column. You can say byrow = T to do what humans do: fill across a line before moving to the next.

``` splus
latents = c("G")
manifests = names(demoOneFactor)
m1 <- mxModel("One Factor", type = "RAM",
	manifestVars = manifests,
	latentVars  = latents,
	mxPath(from = latents, to = manifests),
	mxPath(from = manifests, arrows = 2),
	mxPath(from = latents  , arrows = 2, free = F, values = 1),
	mxData(cov(demoOneFactor), type = "cov", numObs = nrow(demoOneFactor))
)
```


**Footnotes**
[^1]: 