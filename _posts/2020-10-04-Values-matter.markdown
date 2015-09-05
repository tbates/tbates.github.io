---
layout: post
title: "Values and why they are important in OpenMx"
date: 2020-10-04 00:00
comments: true
categories: models tutorial
---

### Values matter

#### nb: This page is not finished. 

Values matter if life. In OpenMx, values matter to. They are where model estimation starts from. Once run, they are the best estimates of our parameters.

### Core concepts about parameters in OpenMx

Parameters know three things: Whether they are free, what their current value is, and, critically, what their label is.

In this tutorial, we are going to [set](#setStarts) values, [get values](#getValues). In more [advanced tutorials](TODO: constraints and labels), we will learn how to equate values using constraints and labels.

### Setting start values in a path

``` splus
latents = c("G")
manifests = names(demoOneFactor)
df = mxData(cov(demoOneFactor), type = "cov", numObs = nrow(demoOneFactor))
m1 <- mxModel("One Factor", data = df,
	umxPath(latents, to = manifests),
	umxPath(var = manifests),
	umxPath(v1m0 = latents)
)

```

### Set values in a matrix

Values are reused to fill the cells of a matrix:

``` splus
mxMatrix(name = "IamAllOnes", type = "Full", nrow = 3, ncol = 3, values = 1, byrow = TRUE)
$values
     [,1] [,2] [,3]
[1,]    1    1    1
[2,]    1    1    1
[3,]    1    1    1

```

R fills by column. You can say byrow = TRUE to do what humans do: fill across a line before moving to the next.

``` splus
mxMatrix(name = "IwasFilledByRow", type = "Full", nrow = 3, ncol = 3, values = 1:9, byrow = TRUE)
$values
     [,1] [,2] [,3]
[1,]    1    2    3
[2,]    4    5    6
[3,]    7    8    9
```


