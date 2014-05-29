---
layout: post
title: "Hello World: Build & run a model in a minute!"
date: 2020-11-30 00:00
comments: true
categories: models tutorial
---

<a name="top"></a>
umx stands for "user" OpenMx helper library. It's purpose is to help with [Structural Equation Modeling](http://en.wikipedia.org/wiki/Structural_equation_modeling) in [OpenMx](http://openmx.psyc.virginia.edu).

So, let's do some modeling... 

First, I show how to install umx. If you've got it loaded up, skip down to **[overview](#overview)**

<a name="install"></a>
## Install umx
umx lives on [github](http://github.com/tbates/umx) – a great place for package development. Loading libraries from github differs slightly from the procedure you may be used to. instead of `install.packages("umx")`, we're going to use `devtools::install_github("umx")` [^1]

``` splus
install.packages("devtools")
library("devtools")
install_github("devtools")
```

Once you have `devtools`, then you can install and load `umx`:

``` splus
library("devtools")
# install and load umx
install_github("tbates/umx")
library("umx")
```
<a name="overview"></a>
## Build and Run: An overview
Now, let's build, run, summarize, modify/compare, and display a model.

We will use the built-in [mtcars](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html) data set.

We will model miles/gallon (mpg) as a function of engine size (disp) and number of gears (gear). Then we can drop number of gears to test the theory that the only determinant (in this confounded play dataset) of mpg is inches<sup>3</sup> of displacement.

In `lm`, this would be "mpg ~ disp + gear"

[Sewall Wright](http://en.wikipedia.org/wiki/Sewall_Wright"Wikipedia Entry: Sewall Wright") invented SEM to allow us to think in explicit graphs. So, here's what that language implies:

![model of mpg](/media/1_make_a_model/mpg_1a_theory.png "A model of Miles/gallon")

Here's what it looks like in OpenMx (and don't worry, I'm going to take you through it step by step below for people new to OpenMx)

``` splus
manifests = c("mpg", "disp", "gear")
m1 <- mxModel("big_motor_bad_mpg", type = "RAM",
	# Define all the boxes in our diagram
	manifestVars = manifests,	
	# Add paths from displacement and number of gears to mpg
	mxPath(from = c("disp", "gear"), to = "mpg"),

	# Allow displacement and number of gears to correlate
	mxPath(from = "disp", to = "gear", arrows = 2),

	# Residual variance in mpg (stuff not explained by disp and gear)
	mxPath(from = "mpg", arrows = 2),

	# In this (silly) toy model, we can fix the variance of our two IVs at their known values
	mxPath(from = "disp", arrows = 2, free = F, values = var(mtcars$disp)),
	mxPath(from = "gear", arrows = 2, free = F, values = var(mtcars$gear)),

	# Finally: the data we are testing our hypothesis against
	mxData(cov(mtcars[,manifests]), type = "cov", numObs = nrow(mtcars))
)

# Now Run that model, and show a summary.
m1 = umxRun(m1, setValues = T, setLabels = T)
umxSummary(m1, show = "both")
```
`umxSummary` shows that m1 fits well: χ²(2) = 0, p 1.000; CFI = 1.042; TLI = 1.063; RMSEA = 0.

We also get path estimates ("*both*" requests both the raw and standardized paths).

|   | name           | Estimate | Std.Error | Std.Estimate | Std.SE |
|:--|:---------------|:---------|:----------|:-------------|:-------|
| 1 | disp_to_mpg    | -0.041   | 0.0056    | -0.840       | 0.115  |
| 2 | gear_to_mpg    | 0.111    | 0.9363    | 0.014        | 0.115  |
| 3 | mpg_with_mpg   | 10.226   | 2.5975    | 0.282        | 0.072  |
| 4 | disp_with_gear | -50.803  | 9.9254    | -0.556       | 0.109  |

We can plot these standardized (or raw) coefficients on a diagram the way Sewall would like us too:

``` splus
plot(m1)
```

![model 1](/media/1_make_a_model/mtcar2.png "Model 1")

If you were happy with that, [click here](#modify) to go to modify and compare.

To go over what we've just seen slowly... just read on where I break that down into a series of steps:

1. [Build](#build)
2. [Run](#run)
3. [Report](#report)
4. [Compare](#compare)

<a name="build"></a>
## Build a model

To build a model, we need OpenMx and umx

``` splus
require("OpenMx")
require("umx")
```
And some data:

``` splus
data(demoOneFactor)
```

I like to begin with making up nice lists of the manifests. 

``` splus
manifests = c("mpg", "disp", "gear")
```

We will use this to tell the model which columns are being modeled, but it's also helpful to allow us to be clearer in listing what boxes  connect where in more complex models.

Now, the model. Let's build that up piece by piece. Nicely, mxModels can be updated trivially so we can do this "line by line"

First, make a model, give it a name, and let it know it is a RAM model (a model type that understands how to accepts mxPaths)

The name is a memorable string allowing us to refer across models (OpenMx handles multiple nested groups), and also for making `umxCompare` tables easier to understand. I usually pick a name that say what the model claims.

``` splus
m1 <- mxModel("big_motor_bad_mpg", type = "RAM")
```

**tip**: If it is not an existing model, the first parameter will be used as a name.

Let's add a list of manifests to m1:

``` splus
m1 <- mxModel(m1,
	manifestVars = manifests
)
```

`Important`: manifestVars is a special reserved word. RAM models need it, and will complain (informatively) if you forget to set this list of boxes for the model.

Now let's add the paths from `disp` and gear to mpg

``` splus
m1 <- mxModel(m1, 
	mxPath(from = c("disp", "gear"), to = "mpg")
)
```

This exposes a great advanced feature of `mxPath`: It is smart and powerful about reusing from and to. In this case, two paths to "mpg" are created, one from each of the two elements from. Learn more in the chapter on [Power with mxPath](todo).

So it's the same as:

``` splus
m1 <- mxModel(m1,
	mxPath(from = "disp", to = "mpg"),
	mxPath(from = "gear", to = "mpg")
)
```

*PS*: You can execute this - it will just re-write the two existing paths. This introduces a neat power in OpenMx: updating models by overwriting existing elements with new states.

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

<a name="modify"></a>
## Modify a model

[Fundamentally](http://www.mii.ucla.edu/causality), modeling is in the service of understanding causality and we do that primarily via model comparison: Better theories fit the data better than do worse theories.

So, "do more gears give better miles per gallon"?

In graph terms, this is asking, "is the path from to gear to mpg significant?" There are two ways to test this with umx.

First, a way that doesn't involve learning anything new: We can modify m1 by overwriting the existing path with one fixing the value to zero.

``` splus
m2 = mxModel(m1, mxPath(from = "gear", to = "mpg", free = F, values = 0)
m2 = mxRun(m2)
```
That gives us a second model, with a zero path from gear to mpg.

The second way, which you will use often, takes advantage of labels and umxReRun()

``` splus
m2 = umxReRun(m1, update = "gear_to_mpg", name = "no effect of gear")
```
That, by default, fixes the value of matched labels to zero. Learn more at the [umxReRun tutorial](umxReRun tutorial).

<a name="compare"></a>
## Compare two models

Now we can test if gear affects mpg by comparing these two models:

``` splus
umxCompare(m1, m2)
```

The table below shows that dropping this path did not lower fit significantly(χ²(1) = 0.01, p = 0.905):

| Comparison        | EP | Δ -2LL     | Δ df  | p     | AIC   | Compare with Model |
|:------------------|:---|:-----------|:------|:------|:------|:-------------------|
| <NA>              | 4  | NA         | NA    | <NA>  | -4.00 | big_motor_bad_mpg  |
| no effect of gear | 3  | 0.0141     | 1     | 0.905 | -5.98 | big_motor_bad_mpg  |


Advanced tip: `umxReRun()` can modify, run, and compare all in 1-line

``` splus
	m2 = umxReRun(m1, update = "gear_to_mpg", name = "dop effect of gear"), comparison = TRUE)
```

**Footnotes**
[^1]: `devtools` is @Hadley's package for using packages not on CRAN.

<!--
#### TODO
1. Examples using  [personality](https://en.wikipedia.org/wiki/Five_Factor_Model) data.
2. IQ example. A model in which all facets load on each other. compare to *g*
-->