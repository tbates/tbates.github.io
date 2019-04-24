---
layout: post
title: "umx for OpenMx users"

comments: true
categories: basic
---

Previously, I showed how to model with `umxPath` and `umxRAM`. Here, I compare this to built-in OpenMx `mxModel` and `mxPath` functions.

#### umxRAM vs mxModel

`umxRAM` saves you specifying three elements of the model:

1. The Model type
 * In OpenMx, all models are built using mxModel. You need to tell the model that the type you want is "RAM". Using umxRAM, that's not needed.
2. The manifestVars don't need to be listed
 * OpenMx requires all the boxes in a diagram to be listed explicitly with `manifestVars = manifests`. In umxRAM, the manifests are simply the names found in umxPath statements that are also in the data.
3. The latentVars don't need to be listed
 * In umx, latents are just variables not found in the data.

In addition, with umxRAM, data is explicitly passed in as `data = ` In `mxModel`, data is just another thing listed in the model.

This last feature has the benefit that you can pass in raw data, and `umxRAM` will create the `mxData` statement you need. It will also drop columns not referred to in the model.

#### mxPath vs umxPath

`umxPath` differs from mxPath in that it supports new arguments to say what you want more succinctly and (I think, more readably).

`mxPath` takes `from`, `to`, `arrows` (1 or 2), `values`, and `free` parameters, amongst others. So, a path with 2 arrows, fixed at 1 requires you to specify all of those things:

```r
mxPath(from = "A", to = "B", arrows = 2, values = 1, free = FALSE)
```

`umxPath` adds several new verbs which link these actions in common patterns:

```r
umxPath("A", with = "B", fixedAt = 1)
```

Equivalently:

```r
umxPath(cov = c("A", "B"), fixedAt = 1)
```

In total there are 14 new words for describing paths (with, var, cov, unique.bivariate, unique.pairs, Cholesky, defn, means, v0m0, v1m0, v.m., fixedAt, freeAt, firstAt). You can learn more about these additional parameters [here](/advanced/1995/11/20/detailed-umxPath.html)

What follows in this post, is the construction of our toy model using base OpenMx functions. Nicely, mxModels can be updated by passing an existing model into mxModel and adding or subtracting objects "line by line".

1. [Build](#build)
2. [Run](#run)
3. [Report](#report)
4. [Compare](#compare)

<a name="build"></a>

## Build a model

To build the model, we need umx and some data:

```splus
require("umx")
data(mtcars)
```

I like to begin with making up a list of the manifests.

```splus
manifests = c("mpg", "disp", "wt")
```

We will use this to tell the model which columns are being modeled, but it's also helpful to allow us to be clearer in listing what boxes connect where in more complex models.

First, make a model, give it a name, and let it know it is a RAM model (a model type that understands how to accepts mxPaths)

The name is a memorable string allowing us to refer across models (OpenMx handles multiple nested groups), and also for making `umxCompare` tables easier to understand. I usually pick a name that say what the model claims.

```splus
m1 <- mxModel("big_motor_bad_mpg", type = "RAM")
```

**tip**: If the first unnamed parameter is a string, it will be used as a name.

Next, we add a list of manifests to m1:

```splus
m1 <- mxModel(m1, manifestVars = manifests )
```

`Important`: manifestVars is a special reserved word. RAM models need it, and will complain (informatively) if you forget to set this list of boxes for the model.
We don't have any latents in this model. If we did, they'd be included using `latentVars = c("list", "the", "latents")`

Now we can add the paths from `disp` and from `wt` to `mpg`

```splus
m1 <- mxModel(m1, mxPath(from = c("disp", "wt"), to = "mpg") )
```

These default to single-arrow paths with values left free, starting at 0 (probably jiggled to .01 when `mxRun` sees the model).

This exposes a great advanced feature of `mxPath` (and `umxPath`): They're smart about reusing `from` and `to`. In this case, two paths to "mpg" are created, one from each of the two elements from. Learn more in the chapter on [using umxPath](http://tbates.github.io/ram/path/2020/09/20/Power-of-the-(mx)-Path.html).

So that was the same as:

```splus
m1 <- mxModel(m1,
	mxPath(from = "disp", to = "mpg"),
	mxPath(from = "wt"  , to = "mpg")
)
```

*PS*: You can execute this - it will just re-write the two existing paths. This introduces a neat power in OpenMx: updating models by overwriting existing elements with new ones.

**PPS**: If you've got a graphviz graphing program installed, you can visualise what you've done in your model at every step.

Assuming you've got `umx` loaded, just say:

```splus
	plot(m1)
```

Alternatively use the built in graphing function, `omxGraphviz`. This adds color, and uses circles to draw residuals (I use lines in `plot`), but doesn't show path values, doesn't allow customizing what gets drawn.

PS: the reason i don't use circles for variances is they are not (currently) imported nicely in Omnigraffle :-(.

```splus
	omxGraphviz(m1) # doesn't show path values.
```

Next, we allow displacement and weight to correlate (a two headed path between them)

```splus
m1 <- mxModel(m1, mxPath(from = "disp", to = "wt", arrows = 2))
```

Here we add `arrows = 2`. In the previous cases, we just used the default, which is 1-headed arrows.

Now we need to give the IVs some variance (2-head arrows). To be kind to the optimizer, we can start these at the known values:

```splus
m1 <- mxModel(m1,
	mxPath(from = "disp", arrows = 2, free = TRUE, values = var(mtcars$disp)),
	mxPath(from = "wt"  , arrows = 2, free = TRUE, values = var(mtcars$wt))
)
```

mpg will need some residual variance:

```splus
m1 <- mxModel(m1,
	mxPath(from = "mpg", arrows = 2)
)
```

Finally, we must add the data against which we are testing our hypothesis:

```splus
m1 <- mxModel(m1,
	mxData(cov(mtcars[,manifests]), type = "cov", numObs = nrow(mtcars))
)
```
**note**: with cov data, we no longer need a means statement. umxRAM is pretty smart about this and if you feed it raw data but no means, it will add means for the manifests and latents.

We can be a bit more verbose about that for clarity

```splus
covData = cov(mtcars[,manifests], use ="pairwise.complete.obs")
numObs = nrow(mtcars)

m1 <- mxModel(m1,
	mxData(covData, type = "cov", numObs = numObs)
)
```
Done! So now we have a complete model, with all our hypothesised paths (variances and covariances) and the data. We are ready to run the model.

<a name="run"></a>

## Run the model

Mow we run the model. In this case we take advantage of umxRun to also set labels and start values. Of course this won't touch fixed values.

**nb**: See tutorials on using [labels](http://tbates.github.io/models/tutorial/2020/10/03/How-labels-work.html), and on [values](http://tbates.github.io/models/tutorial/2020/10/04/Values-matter.html).

```splus
m1 <- umxRun(m1, setLabels = T, setValues = T)
```

This exposes a lovely (and unique) feature of OpenMx: running a model returns a valid model that can be updated and run again 
<!-- TODO  sidebar -->

<a name="report"></a>

## Report on the model

```splus
umxSummary(m1, show = "std")
```
Now we can compare this to competing models with `mxCompare()`