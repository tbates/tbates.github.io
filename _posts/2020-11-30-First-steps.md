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
# load umx library
library("umx")
# note: the umx philosophy extends to help ?umx is not just boilerplate documentation.
# All functions are fully documented, with awesome complete examples.
```

<a name="overview"></a>
## Build and Run: An overview
Now, let's build, run, summarize, modify/compare, and display a model. Real science is all about comparing different theoretical predictions: the idea that there are, say, two forms of dyslexia is tested not against a null hypothesis that there are none, but against some competing model: that there is one form, for instance. Whereas the answer to "does this theory fit better than no theory" is always "yes" if we have enough subjects, that's an incredibly low bar, and doesn't lead to increases in knowledge: these come from pitting one model (human-created theory) against another, to see which is closer to the truth. This bed-rock metric of closer-further gives us a boot strap to iteratively choose the ideas (products of human creativity) that are ever closer to reality. 

### Two theories to compare
Here, we begin with two patsy ideas: one that miles/gallon (mpg) goes up as car engine size goes down **and** as car weight goes down (weight). A contrasting theory might predict that it is only weight that matters, not engine capacity. We can drop capacity to test the idea that the only determinant (in this confounded play dataset) of mpg is weight.

We will use the built-in [mtcars](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html) data set. miles/gallon is `mpg`, displacement is `disp`, and weight is `wt`.

We'll use umx to build both models, and compare them.

#### Starting with what you know

In `lm`, model 1 would be "mpg ~ disp + wt". Model 2 would be "mpg ~ disp"

[Sewall Wright](http://en.wikipedia.org/wiki/Sewall_Wright"Wikipedia Entry: Sewall Wright") invented SEM to allow us to think in explicit graphs. So, here's what that language implies:

![model of mpg](/media/1_make_a_model/mpg_1a_theory.png "A model of Miles/gallon")

Let's start off with something very simple: the means and variances of three raw variables. This is also called an "independence model".

The equivalent of `lm` is `umxRAM`. Like lm, we're going to feed this model container a data set (`data = mtcars`). The string "my_first_model" is a name that is used to refer to the model, and which is used in output as well. Just make it informative.

``` splus
m1 <- umxRAM("my_first_model", data = mtcars)
```

Now, instead of just one formula, we're going to give `umxRAM` a list of  `umxPaths` to specify all the lines, boxes, and circles in the figure above.

With `umxPath`, you can specify a variance (a 2-headed path originating and terminating on one variable) with the argument `var =`
To specify a mean (a path from the constant one to a variable), just use the argument `means =`

``` splus
manifests = c("disp", "gear", "mpg")
m1 <- umxRAM("big_motor_bad_mpg", data = mtcars,
	umxPath(var   = manifests),
	umxPath(means = manifests)
)
```

Now we can run this model with `mxRun`, get a summary, and even plot the output.

``` splus
m1 = mxRun(m1)
umxSummary(m1)
plot(m1, std = F)
```

nb: *You'll need to have GraphViz installed for plot to work flawlessly: if it doesn't work, don't worry. Later posts will explain how to get great graphics*!

Here's the plot:

![independence model](/media/1_make_a_model/independence model.png "Independence model of three variables")

This should also be a warning: the variances are very divergent... It would help the optimiser if we convert displacement into litres. We'll ignore this for now.

As you can see, this is an "independence model": No covariances were included, so all variables are modelled as uncorrelated. It would fit poorly in this case.

``` splus
umxSummary(m1)
```
χ²(90) = 52.39, p < 0.001; CFI = 0; TLI = 0; RMSEA = 0.717

Yikes... clearly some un-modelled covariance here... Let's apply our theorized models.

``` splus
m1 <- umxRAM("big_and_heavy", data = mxData(mtcars, type = "raw"),
	# One headed paths
	umxPath(from = c("disp", "wt"), to = "mpg"),
	# Means
	umxPath(means = c("disp", "wt", "mpg")),
	# Variances and covariances
	umxPath(cov = c("disp", "wt")),
	umxPath(var = c("disp", "wt", "mpg"))
)

# Now mxRun, and show a summary.
m1 = mxRun(m1)
umxSummary(m1, show = "std")
```

This saturated model fits perfectly, of course.
So `umxSummary` shows that m1 fits well: χ²(87) = 0.02, p < 0.001; CFI = 1; TLI = 1; RMSEA = 0

We also get path estimates ("**show** = *std*" requests the standardized paths).

|   | name           | Estimate | Std.Error | CI (SE-based)       |
|:--|:---------------|:---------|:----------|:--------------------|
| 1 |    disp_to_mpg |  -0.37   | 1.8e-01   |-0.37 [-0.72, -0.02] |
| 2 |      wt_to_mpg |  -0.54   | 1.8e-01   | -0.54 [-0.89, -0.2] |
| 3 |   mpg_with_mpg |   0.21   | 6.8e-02   |   0.21 [0.08, 0.35] |
| 4 | disp_with_disp |   1.00   | 1.9e-12   |            1 [1, 1] |
| 5 |   disp_with_wt |   0.89   | 3.7e-02   |   0.89 [0.82, 0.96] |
| 6 |     wt_with_wt |   1.00   | 2.5e-13   |            1 [1, 1] |


We can plot these standardized (or raw) coefficients on a diagram the way Sewall Wright would like us too:

``` splus
plot(m1, showMeans=F)
```

![model 1](/media/1_make_a_model/mtcar2.png "Model 1")

We can ask for the (unstandardized) confidence intervals with the usual `confint` function. Because these can take a long time for SEM models, the default is to require you to ask to run them.

```splus
    confint(m1, run = TRUE)
```

|                | lbound   | estimate  | ubound       |
|:---------------|:---------|:----------|:-------------|
| disp_to_mpg    | -0.035   | -0.018    | 0.000        |
| wt_to_mpg      | -5.641   | -3.351    | -1.060       |
| mpg_with_mpg   | 4.866    | 7.709     | 13.642       |
| disp_with_disp | 4536.833 | 15360.850 | 24081337.389 |
| disp_with_wt   | 58.605   | 107.685   | 286.965      |
| wt_with_wt     | 0.589    | 0.951     | 1.590        |
| one_to_mpg     | 30.631   | 34.960    | 39.291       |
| one_to_disp    | 173.627  | 230.815   | 287.822      |
| one_to_wt      | 2.871    | 3.218     | 3.560        |

What did lm think these should be?

```splus
l1 = lm(mpg ~ 1 + disp + wt, data = mtcars)
coef(l1)
```

| (Intercept) | disp        | cyl         |
|:------------|:------------|:------------|
| 34.96055404 | -0.01772474 | -3.35082533 |
   
```splus
    confint(l1)
```
|             | 2.5 %        | 97.5%       |
|:------------|:------------|:-------------|
| (Intercept) | 30.53357368 | 39.387534392 |
| disp        | -0.03652128 | 0.001071794  |
| wt          | -5.73173459 | -0.969916079 |

If you were happy with that, [click here](#modify) to go to modify and compare.


<a name="modify"></a>
## Modify a model

[Fundamentally](http://www.mii.ucla.edu/causality), modeling is in the service of understanding causality and we do that primarily via model comparison: Better theories fit the data better than do worse theories.

So, we can ask questions like "does lower weight give better miles per gallon"?

In graph terms, this is asking, "is the path from to wt to mpg significant?" There are two ways to test this with umx.

First, we can modify m1 by overwriting the existing path with one fixing the value to zero.

In base OpenMx code we'd say:

``` splus
m2 = mxModel(m1, mxPath(from = "wt", to = "mpg", free = F, values = 0)
m2 = mxRun(m2)
```

With umxPath we can save some typing and use `fixedAt`

``` splus
m2 = mxRun(mxModel(m1, umxPath("wt", to = "mpg", fixedAt = 0))
```

That gives us a second model, with a zero path from gear to mpg.

`umxReRun` gives us a nifty second way, using labels. You will use this often.

``` splus
m2 = umxReRun(m1, update = "wt_to_mpg", name = "no effect of wt")
```
By default, `umxReRun` fixes the value of matched labels to zero. Learn more at the [umxReRun tutorial](umxReRun tutorial).

**tip**: To discover the labels in a model, use `umxGetParameters(model)`

**gotcha**: mxModel doesn't add these labels by default –&nbsp; `umxModel` does.

You can also add labels to a model (or matrix) using`umxLabel`, and `umxRun` has the option to `addLabels`

**tip**: To discover the labels in a model, use `umxGetParameters(model)`

<a name="compare"></a>
## Compare two models

Now we can test if gear affects mpg by comparing these two models:

``` splus
umxCompare(m1, m2)
```

The table below shows that dropping this path did not lower fit significantly(χ²(1) = 0.01, p = 0.905):

|Model           |EP |Δ -2LL    |Δ df|p    |AIC     |Compare with Model|
|----------------|---|----------|----|-----|--------|-------------|
|big_and_heavy   | 9 |419.1343  |    |     |        |             |
|no effect of wt | 8 |8.0416014 | 1  |0.005|425.1759|big_and_heavy|

So, weight seems to matter, and you can increase mpg (and acceleration) by lightening your car.

Advanced tip: `umxReRun()` can modify, run, and compare all in 1-line

``` splus
m2 = umxReRun(m1, update = "gear_to_mpg", name = "drop effect of gear"), comparison = TRUE)
```

**Footnotes**
[^1]: `devtools` is @Hadley's package for using packages on GitHub.

<!--
#### TODO
1. Examples using  [personality](https://en.wikipedia.org/wiki/Five_Factor_Model) data.
2. IQ example. A model in which all facets load on each other. compare to *g*
-->
