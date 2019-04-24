---
layout: post
title: "Values and why they are important"

comments: true
categories: advanced 
---

### Values matter

Parameters know three things: Whether they are *free*, what their *label* is, and, importantly, what their current *value* is.

As in life, so too in `umx`: "values matter".

Values are where model estimation starts from.

Once run, a model's values are the best estimates of its `parameters()`.

In this tutorial, we are going to [set](#setStarts) values, and [get values](#getValues). In a more [advanced tutorial](http://tbates.github.io/advanced/2020/10/03/detailed-How-labels-work.html), we will learn how to equate values using constraints and labels.


### Setting start values in a path
as we saw in the introductory chapters, `umxRAM` does a good job at guessing start values. Sometimes, however, you want to set your own start values, or, indeed, to fix values at certain points. This is done with the `values` parameter of `umxPath`: 

```splus
latents = c("G")
manifests = names(demoOneFactor)
df = mxData(cov(demoOneFactor), type = "cov", numObs = nrow(demoOneFactor))

m1 <- umxRAM("One Factor", data = df,
	umxPath(latents, to = manifests, values = .5), # start path estimate for these paths at .5
	umxPath(var = manifests, values= .1), # set starting values of manifest residuals to .1
	umxPath(v1m0 = latents) # fix value of mean at zero, and value of variance to 1
)

```

### Set values in a matrix

In R matrices, values flow down columns. To do what humans do (fill across a row before moving to the next), you can say `byrow = TRUE`.

It's the same for `mxMatrices`, except these have a special "values" slot, which holds the values matrix (mxMatrices have to have a slab of three inner matrices to represent not only the value of a cell, but whether that cell is free, and what its label is).


```splus
mxMatrix(name = "IwasFilledByRow", type = "Full", nrow = 3, ncol = 3, values = 1:9, byrow = TRUE)
$values
     [,1] [,2] [,3]
[1,]    1    2    3
[2,]    4    5    6
[3,]    7    8    9
```

*nb*: Values are re-used (if needed) fill the cells of a matrix:

```splus
a = mxMatrix(name = "IamAllOnes", type = "Full", nrow = 3, ncol = 3, values = 1, byrow = TRUE)
a$values
     [,1] [,2] [,3]
[1,]    1    1    1
[2,]    1    1    1
[3,]    1    1    1

```




More to do...

```splus
umxGetParameters(model)
```

```splus
umxSetParameters(model, labels, values="")
```
