---
layout: post
title: "Build & run a model in base OpenMx functions"
date: 2020-11-25 00:00
comments: true
categories: models tutorial
---

In the last post, we used `umxPath` and `umxRAM`. Here, I show how this differs from the built-in OpenMx `mxModel` and `mxPath` functions

`umxRAM` saves you specifying three things from the get go: Model type, manifestVars and latentVars. 

Fourthly, it mirrors `lm`, `plot` etc. in having an explicit **data** = *myData* argument.

Finally, umxPath differs from mxPath in that it supports a range of new arguments to say what you want more succinctly and (I think, more readably).
So to list all that in one place:

1. The Model type
 * In OpenMx, all models are built using mxModel. You need to tell the model that the type you want is "RAM". Using umxRAM, that is just not needed.
2. The manifestVars don't need to be listed
 * OpenMx requires all the boxes in a diagram to be listed explicitly with `manifestVars = manifests`. In umxRAM, the manifests are simply the names found in umxPath statements that are also in the data.
3. The latentVars don't need to be listed
 * In umx, latents are just path elements not found in the data.
4. data is explicitly passed in as `data = `
 * In `mxModel`, data is just another thing listed in the model. By contrast, like lm, umxRAM has a data parameter.

This last feature has some additional benefits. You can pass in raw data, and mxRAM will build the mxData statement you need.

#### mxPath vs umxPath

mxPaths take `from`, `to`, `arrows` (1 or 2), `values`, and free parameters, amongst others. So, a path with 2 arrows, fixed at 1 requires you to specify all of those things:

```splus
mxPath(from = "A", to = "B", arows = 2, values = 1, free = FALSE)
```

umxPath adds some new terms which link these actions together:

```splus
mxPath("A", with = "B", fixedAt = 1)
```

Equivalently:

```splus
mxPath(cov = c("A", "B"), fixedAt = 1)
```

You can learn more about these additional parameters at `?umxPath`

What follows in this post, is the construction of our toy model using base OpenMx functions. Nicely, mxModels can be updated trivially so we can do this "line by line"

1. [Build](#build)
2. [Run](#run)
3. [Report](#report)
4. [Compare](#compare)

<a name="build"></a>
## Build a model

To build the model, we need OpenMx and umx

``` splus
require("OpenMx")
require("umx")
```
And some data:

``` splus
data(mtcars)
```

I like to begin with making up a list of the manifests.

``` splus
manifests = c("mpg", "disp", "gear")
```

We will use this to tell the model which columns are being modeled, but it's also helpful to allow us to be clearer in listing what boxes connect where in more complex models.

First, make a model, give it a name, and let it know it is a RAM model (a model type that understands how to accepts mxPaths)

The name is a memorable string allowing us to refer across models (OpenMx handles multiple nested groups), and also for making `umxCompare` tables easier to understand. I usually pick a name that say what the model claims.

``` splus
m1 <- mxModel("big_motor_bad_mpg", type = "RAM")
```

**tip**: If the first unnamed parameter is a string, it will be used as a name.

Next, we add a list of manifests to m1:

``` splus
m1 <- mxModel(m1, manifestVars = manifests )
```

`Important`: manifestVars is a special reserved word. RAM models need it, and will complain (informatively) if you forget to set this list of boxes for the model.
We don't have any latents in this model. If we did, they'd be included using `latentVars = c(list the latents)`

Now we can add the paths from `disp` and from `gear` to `mpg`

``` splus
m1 <- mxModel(m1,  mxPath(from = c("disp", "gear"), to = "mpg") )
```
By default, these are single-arrow paths, with free parameters defaulting to 0 (and probably jiggled to .01 when mxRun sees the model).

This exposes a great advanced feature of `mxPath`: It is smart and powerful about reusing from and to. In this case, two paths to "mpg" are created, one from each of the two elements from. Learn more in the chapter on [Power with mxPath](todo).

So that was the same as:

``` splus
m1 <- mxModel(m1,
	mxPath(from = "disp", to = "mpg"),
	mxPath(from = "gear", to = "mpg")
)
```

*PS*: You can execute this - it will just re-write the two existing paths. This introduces a neat power in OpenMx: updating models by overwriting existing elements with new states.

**PPS**: If you've got a dot graphing program installed, you can visualise what you've done in your model at every step.

Assuming you've got `umx` loaded, just say:

``` splus
	plot(m1)
```

Next, we allow displacement and number of gears to correlate (a two headed path between them)

``` splus
m1 <- mxModel(m1,
	mxPath(from = "disp", to = "gear", arrows = 2)
)
```

Here we add "arrows = 2". In the previous cases, we just used the default, which is 1 headed arrows.

Now, because they have no incoming paths, we can fix the variance of our two IVs at their known values

``` splus
m1 <- mxModel(m1,
	mxPath(from = "disp", arrows = 2, free = F, values = var(mtcars$disp)),
	mxPath(from = "gear", arrows = 2, free = F, values = var(mtcars$gear))
)
```
Here we add "free = FALSE". In the previous cases, we just used the default, which is for the paths to be free.

We can test whether mpg is completely explained by examining its residual variance.

``` splus
m1 <- mxModel(m1,
	mxPath(from = "mpg", arrows = 2)
)
```

Finally, we must add the data against which we are testing our hypothesis:

``` splus
m1 <- mxModel(m1,
	mxData(cov(mtcars[,manifests]), type = "cov", numObs = nrow(mtcars))
)
```

We can be a bit more verbose about that for clarity

``` splus
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

**nb**: See tutorials on using [labels](todo: Using labels), and on [values](todo:Using start values).

``` splus
m1 <- umxRun(m1, setLabels = T, setValues = T)
```

This exposes a lovely (and unique) feature of OpenMx: running a model returns a valid model that can be updated and run again 
<!-- TODO  sidebar -->

<a name="report"></a>
## Report on the model

``` splus
umxSummary(m1, show = "std")
```

**Fit Statistics**

| name           | matrix | row  | col  | Std.Estimate | Std.SE | CI                   |
|:---------------|:-------|:-----|:-----|:-------------|:-------|:---------------------|
| disp_to_mpg    | A      | mpg  | disp | -0.840       | 0.115  | -0.84 [-1.06, -0.62] |
| gear_to_mpg    | A      | mpg  | gear | 0.014        | 0.115  | 0.01 [-0.21, 0.24]   |
| mpg_with_mpg   | S      | mpg  | mpg  | 0.282        | 0.072  | 0.28 [0.14, 0.42]    |
| disp_with_gear | S      | disp | gear | -0.556       | 0.109  | -0.56 [-0.77, -0.34] |


χ²(2) = 0, p 1.000; CFI = 1.042; TLI = 1.063; RMSEA = 0

Now we can compare this to competing models.