---
layout: post
title: "Values and why they are important"

comments: true
categories: advanced 
---


Parameters know three things: Whether they are *free*, what their *label* is, and, importantly, what their current *value* is.

Values are where model estimation starts from, and, once run, a model's values are the best estimates of its `parameters()`.

In this tutorial, we are going to [set](#setStarts) values, and [get values](#getValues). In a more [advanced tutorial](http://tbates.github.io/advanced/1995/10/03/detailed-Labels.html), we will learn how to equate values using constraints and labels.


### Setting start values in a path
As we saw in the introductory chapters, `umxRAM` does a good job at guessing start values. Sometimes, however, you want to set your own start values, or, indeed, to fix values at certain points. This is done with the `values` parameter of `umxPath`: 

```r
manifests = names(demoOneFactor)

m1 = umxRAM("One Factor", data = demoOneFactor,
	umxPath(latents, to = manifests, values = .5), # Start path estimate for these paths at .5
	umxPath(var = manifests, values= .1), # Set starting values of manifest residuals to .1
	umxPath(means = manifests, freeAt= 0), # Start values of manifest means at 0.
	umxPath(v1m0 = "G") # Fix value of mean at zero, and value of variance to 1
)

```

### Set values in a matrix

In R matrices, values flow down columns. To do what humans do (fill across a row before moving to the next), you can say `byrow = TRUE`.

It's the same for `mxMatrices`, except these have a "values" slot, which holds the values matrix (`mxMatrices` consist of a slab of three matrices representing not only the value of a cell, but whether that cell is free, and what its label is).


```r
tmp = mxMatrix(name = "IwasFilledByRow", type = "Full", nrow = 3, ncol = 3, values = 1:9, byrow = TRUE)
tmp$values
     [,1] [,2] [,3]
[1,]    1    2    3
[2,]    4    5    6
[3,]    7    8    9
```

*nb*: Values are re-used (if needed) fill the cells of a matrix:

```r
tmp = mxMatrix(name = "IamAllOnes", type = "Full", nrow = 3, ncol = 3, values = 1:3, byrow = TRUE)
tmp$values
     [,1] [,2] [,3]
[1,]    1    2    3
[2,]    1    2    3
[3,]    1    2    3

```

To set a value by label, use `umxSetParameters`.

```r
m2 = umxSetParameters(m1, labels= "G_to_x1", values=0)

```

To modify a model setting a value by label, use `umxModify`
