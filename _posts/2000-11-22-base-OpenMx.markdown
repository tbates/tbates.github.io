---
layout: post
title: "umx for OpenMx users"

comments: true
categories: basic
---

Previously, we saw how to make `umxRAM` models and use `umxPath`. The following is a guide for those familiar with OpenMx's `mxModel` and `mxPath` functions.

#### umxRAM vs mxModel

`umxRAM` differs from mxModel in eight major ways:

1. No Model `type` needed.
 * Unlike `mxModel`, `umxRAM` `umxACE` etc knows the model type that's not needed.
2. No `manifestVars` list.
 * In umxRAM, the manifests are simply the names found in umxPath statements that are also in the data. So OpenMx no need too explicitly list up `manifestVars`. 
3. No `latentVars` list.
 * In `umx`, latents are just variables not found in the data.
4. Data is explicitly passed in as `data = `
  * In `mxModel`, data has to be processed by mxData. umx can handle this for you, including dropping unused variables, taking a covariance matrix, etc.
5. Path labels are automatic
  * umxRAM gives plain english path names like "a_to_b". or `a_r1c1`. In `mxModel`, each parameter has no label by default.
6. Start values are automatic and smart.
  * In `mxModel`, each parameter starts at 0 unless manually set via `values=`.
7. No need to separately `mxRun` the model
  * In `umxRAM` the model is automatically run and output tables and graphs produced. (turn this off with `autoRun = FALSE`)
8. No need to separately `mxSummary` the model
  * In `umxRAM` the `umxSummary` is automatically printed.


#### mxPath vs umxPath

`umxPath` differs from mxPath in that it supports new arguments to say what you want with less typing and (I think) more readably.


`umxPath` adds several new verbs which describe common patterns:

```r
umxPath("A", with = "B", fixedAt = 1)
```

In  `mxPath`, `arrows`, `values`, and `free` among others must be set independently. So, a path with 2 arrows, fixed at 1 requires you to specify all of those things, and `to` can mean "with". 

```r
mxPath(from = "A", to = "B", arrows = 2, values = 1, free = FALSE)
```

In umx, you would say:

```r
umxPath(cov = c("A", "B"), fixedAt = 1)
# or
umxPath("A", with = "B", fixedAt = 1)

```

In total there are about a dozen new words for describing paths (`with`, `var`, `cov`, `unique.bivariate`, `unique.pairs`, `Cholesky`, `defn`, `means`, `v0m0`, `v1m0`, `v.m.`, `fixedAt`, `freeAt`, `firstAt`). You can learn more about and memorise these key new path writing ideas [here](/advanced/1995/11/20/detailed-umxPath.html)

What follows in this post, is the construction of our toy model using base OpenMx functions. Nicely, mxModels can be updated by passing an existing model into mxModel and adding or subtracting objects "line by line".

1. [Build](#build)
2. [Run](#run)
3. [Report](#report)
4. [Compare](#compare)

<a name="build"></a>

## Build a model

To build the model, we need umx and some data:

```r
require("umx")
data(mtcars)
```

I like to begin with making up a list of the manifests.

```r
manifests = c("mpg", "disp", "wt")
```

We will use this to tell the model which columns are being modeled, but it's also helpful to allow us to be clearer in listing what boxes connect where in more complex models.

First, make a model, give it a name, and let it know it is a RAM model (a model type that understands how to accepts mxPaths)

The name is a memorable string allowing us to refer across models (OpenMx handles multiple nested groups), and also for making `umxCompare` tables easier to understand. I usually pick a name that say what the model claims.

```r
m1 <- mxModel("big_motor_bad_mpg", type = "RAM")
```

**tip**: If the first unnamed parameter is a string, it will be used as a name.

Next, we add a list of manifests to m1:

```r
m1 <- mxModel(m1, manifestVars = manifests )
```

`Important`: manifestVars is a special reserved word. RAM models need it, and will complain (informatively) if you forget to set this list of boxes for the model.
We don't have any latents in this model. If we did, they'd be included using `latentVars = c("list", "the", "latents")`

Now we can add the paths from `disp` and from `wt` to `mpg`

```r
m1 <- mxModel(m1, mxPath(from = c("disp", "wt"), to = "mpg") )
```

These default to single-arrow paths with values left free, starting at 0 (probably jiggled to .01 when `mxRun` sees the model).

This exposes a great advanced feature of `mxPath` (and `umxPath`): They're smart about reusing `from` and `to`. In this case, two paths to "mpg" are created, one from each of the two elements from. Learn more in the chapter on [using umxPath](http://tbates.github.io/advanced/1995/11/20/detailed-umxPath.html).

So that was the same as:

```r
m1 <- mxModel(m1,
	mxPath(from = "disp", to = "mpg"),
	mxPath(from = "wt"  , to = "mpg")
)
```

*PS*: You can execute this - it will just re-write the two existing paths. This introduces a neat power in OpenMx: updating models by overwriting existing elements with new ones.

**PPS**: If you've got a graphviz graphing program installed, you can visualise what you've done in your model at every step.

Assuming you've got `umx` loaded, just say:

```r
	plot(m1)
```

Alternatively use the built in graphing function, `omxGraphviz`. This adds color, and uses circles to draw residuals (I use lines in `plot`), but doesn't show path values, doesn't allow customizing what gets drawn.

Next, we allow displacement and weight to correlate (a two headed path between them)

```r
m1 = mxModel(m1, mxPath(from = "disp", to = "wt", arrows = 2))
```

Here we add `arrows = 2`. In the previous cases, we just used the default, which is 1-headed arrows.

Now we need to give the IVs some variance (2-head arrows). To be kind to the optimizer, we can start these at the known values:

```r
m1 <- mxModel(m1,
	mxPath(from = "disp", arrows = 2, free = TRUE, values = var(mtcars$disp)),
	mxPath(from = "wt"  , arrows = 2, free = TRUE, values = var(mtcars$wt))
)
```

mpg will need some residual variance:

```r
m1 = mxModel(m1,
	mxPath(from = "mpg", arrows = 2)
)
```

Finally, we must add the data against which we are testing our hypothesis:

```r
m1 = mxModel(m1,
	mxData(cov(mtcars[,manifests]), type = "cov", numObs = nrow(mtcars))
)
```
**note**: with cov data, we no longer need a means statement. umxRAM is pretty smart about this and if you feed it raw data but no means, it will add means for the manifests and latents.

We can be a bit more verbose about that for clarity

```r
covData = cov(mtcars[,manifests], use ="pairwise.complete.obs")
numObs = nrow(mtcars)

m1 = mxModel(m1,
	mxData(covData, type = "cov", numObs = numObs)
)
```
Done! So now we have a complete model, with all our hypothesised paths (variances and covariances) and the data. We are ready to run the model.

<a name="run"></a>

## Run the model

Mow we run the model. In this case we take advantage of umxRun to also set labels and start values. Of course this won't touch fixed values.

**nb**: See tutorials on using [labels](http://tbates.github.io/advanced/1995/10/03/detailed-Labels.html), and on [values](http://tbates.github.io/advanced/1995/10/04/detailed-Values).

```r
m1 = umxRun(m1, setLabels = TRUE, setValues = TRUE)
```

This exposes a lovely (and unique) feature of OpenMx: running a model returns a valid model that can be updated and run again 
<!-- TODO  sidebar -->

<a name="report"></a>

## Report on the model

```r
umxSummary(m1, std = TRUE)
```

Now we can compare this to competing models with `umxCompare()`