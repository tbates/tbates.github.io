---
layout: post
title: "Build & run a model in a minute!"
date: 2020-11-30 00:00
comments: true
categories: models tutorial
---

<a name="top"></a>
umx stands for "user" OpenMx helper library. It's purpose is to help with [Structural Equation Modeling](http://en.wikipedia.org/wiki/Structural_equation_modeling) in [OpenMx](http://openmx.psyc.virginia.edu).

So, let's do some modeling... 

If you haven't installed devtools yet, [do that now](/models/tutorial/2020/12/10/Install.html), and follow the link back here.

Once you have `devtools`, then you can update and load `umx`:

``` splus
# install and load umx
devtools::install_github("tbates/umx")
library("umx")
```

<a name="overview"></a>
## Build and Run: An overview
Now, let's build, run, summarize, modify/compare, and display a model. Real science is all about comparing different theoretical predictions: the idea that there are, say, two forms of dyslexia is tested not against a null hypothesis that there are none, but against some competing model: that there is one form, for instance. Whereas the answer to "does this theory fit better than no theory" is always "yes" if we have enough subjects, that's an incredibly low bar, and doesn't lead to increases in knowledge: these come from pitting one model (human-created theory) against another, to see which is closer to the truth. This bed-rock metric of closer-further gives us a boot strap to iteratively choose the ideas (products of human creativity) that are ever closer to reality. 

### Two theories to compare
Here, we begin with two patsy ideas: one that miles/gallon (mpg) goes up as car engine size goes down **and** as number of cylinders goes up (cyl). A contrasting theory might predict that it is only the number of cylinders that matters. We can drop number of cylinders to test the idea that the only determinant (in this confounded play dataset) of mpg is inches<sup>3</sup> of displacement.

We will use the built-in [mtcars](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html) data set. miles/gallon is `mpg`, displacement is `disp`, and cylinders is `disp`, with number of cylinders just coming along as a side-effect of increasing displacement.

We'll use umx to build both models, and compare them.

#### Starting with what you know

In `lm`, model 1 would be "mpg ~ disp + gear", and model 2, "mpg ~ disp"

[Sewall Wright](http://en.wikipedia.org/wiki/Sewall_Wright"Wikipedia Entry: Sewall Wright") invented SEM to allow us to think in explicit graphs. So, here's what that language implies:

![model of mpg](/media/1_make_a_model/mpg_1a_theory.png "A model of Miles/gallon")

Let's start off with something very simple: the means and variances of three raw variables.

With umxPath, you can specify a variance (a 2-headed path originating and temrinating on one variable) with the argument "var = "
To specify a mean (a path from the constant one to a varaible), just use the argument "means ="

``` splus
manifests = c("disp", "gear", "mpg")
m1 <- umxRAM("big_motor_bad_mpg", data = mtcars[, manifests],
	umxPath(var   = manifests),
	umxPath(means = manifests)
)
m1 = mxRun(m1)
plot(m1, std=F)
```

![independence model](/media/1_make_a_model/independence model.png "Independence model of three variables")

This should also be a warning to us: the variances are very different from one another... Good advice to help the optimiser get to a solution in our real model might be to convert the displacement into litres (x 0.0163871). We'll ignore this for now.

As you can see, this is an "independence model": No covariances were included, so all variables are modeled as uncorrelated. It would fit poorly in this case.

``` splus
umxSummary(m1)
```

χ²(90) = 52.37, p < 0.001; CFI = 0; TLI = 0; RMSEA = 0.717

Yikes... clearly some unmodelled covariance here... Let's apply our theorized models.

``` splus
m1 <- umxRAM("big_motor_bad_mpg", data = mxData(mtcars[,manifests], type="raw"),
	# One headed paths
	umxPath(from = c("disp", "gear"), to = "mpg"),
	# Means
	umxPath(means = manifests),
	# Variances and covariances
	umxPath(cov = c("disp", "gear")),
	umxPath(var = manifests)
	# TODO add a check for "Error in i[[1]] : this S4 class is not subsettable" data provided not as data = 	
)

# Now mxRun, and show a summary.
m1 = umxRun(m1)
umxSummary(m1, show = "std")
```

This saturated model fits perfectly, of course.
So `umxSummary` shows that m1 fits well: χ²(2) = 0, p 1.000; CFI = 1.042; TLI = 1.063; RMSEA = 0.

We also get path estimates ("**show** = *std*" requests both the standardized paths).

|   | name           | Estimate | Std.Error | Std.Estimate | Std.SE |
|:--|:---------------|:---------|:----------|:-------------|:-------|
| 1 | disp -> mpg    |  -0.041  | 0.0056    | -0.840       | 0.115  |
| 2 | gear -> mpg    |   0.111  | 0.9363    |  0.014       | 0.115  |
| 3 | mpg <-> mpg    |  10.226  | 2.5975    |  0.282       | 0.072  |
| 4 | disp <-> gear  | -50.803  | 9.9254    | -0.556       | 0.109  |

We can plot these standardized (or raw) coefficients on a diagram the way Sewall Wright would like us too:

``` splus
plot(m1)
```
![model 1](/media/1_make_a_model/mtcar2.png "Model 1")

```splus
    confint(m1)
```

| Parameter      | lbound   | estimate  | ubound      |
|:---------------|:---------|:----------|:------------|
| cyl_to_mpg     | -2.974   | -1.587    | -0.201      |
| disp_to_mpg    | -0.040   | -0.021    | -0.001      |
| mpg_with_mpg   | 5.337    | 8.461     | 15.006      |
| cyl_with_cyl   | 1.959    | 3.090     | 5.346       |
| cyl_with_disp  | 104.881  | 193.432   | 839.877     |
| disp_with_disp | 4537.337 | 14881.785 | 1976322.799 |

What did lm think these should be?

```splus
l1 = lm(mpg ~ 1 + disp + gear, data = mtcars)
coef(l1)
```

| (Intercept) | disp        | cyl         |
|:------------|:------------|:------------|
| 34.66099474 | -0.02058363 | -1.58727681 |

```splus
    confint(l1)
```

| Parameter   | 2.5 %       | 97.5 %        |
|:------------|:------------|:--------------|
| (Intercept) | 29.45178692 | 39.8702025668 |
| disp        | -0.04156253 | 0.0003952592  |
| cyl         | -3.04316181 | -0.1313918048 |

If you were happy with that, [click here](#modify) to go to modify and compare.

To go over what we've just seen slowly... just read on where I break that down into a series of steps:


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
By default, umxReRun fixes the value of matched labels to zero. Learn more at the [umxReRun tutorial](umxReRun tutorial).

**tip**: To discover the labels in a model, use umxGetParameters(model)
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
	m2 = umxReRun(m1, update = "gear_to_mpg", name = "drop effect of gear"), comparison = TRUE)
```

**Footnotes**
[^1]: `devtools` is @Hadley's package for using packages not on CRAN.

<!--
#### TODO
1. Examples using  [personality](https://en.wikipedia.org/wiki/Five_Factor_Model) data.
2. IQ example. A model in which all facets load on each other. compare to *g*
-->
