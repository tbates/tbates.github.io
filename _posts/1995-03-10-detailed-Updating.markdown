---
layout: post
title: "Updating models: umxReRun and umxCompare"
date: 1995-03-10 00:00
comments: true
categories: advanced
---

note: This page is not finished.

### Why make a new model when you can update one you already have?

In OpenMx, models can be modified. Want to add a new path? Go ahead - no need to start from scratch.

You can add, or remove anything, re-run, and compare.

This tutorial will cover using umxReRun to update models.


<a name="overview"></a>
## Build and Run: An overview

``` splus
manifests = c("mpg", "disp", "gear")
m1 <- umxRAM("big_motor_bad_mpg",
	umxPath(c("disp", "gear"), to = "mpg"),
	umxPath("disp", with = "gear"),
	umxPath(var = "mpg"),
	umxPath(var = "disp", fixedAt = var(mtcars$disp)),
	umxPath(var = "gear", fixedAt = var(mtcars$gear)),
	data = mxData(cov(mtcars[,manifests]), type = "cov", numObs = nrow(mtcars))
)

# Now show a summary.
umxSummary(m1, show = "both")

```

![model 1](/media/1_make_a_model/mtcar2.png "Model 1")

<a name="modify"></a>
## Modify a model

[Fundamentally](http://www.mii.ucla.edu/causality), modeling is in the service of understanding causality and we do that primarily via model comparison: Better theories fit the data better than do worse theories.

So, "do more gears give better miles per gallon"?

In graph terms, this is asking, "is the path from to gear to mpg significant?" There are two ways to test this with umx.

### Removing a path

1. Overwrite existing paths, fixing a value to zero.

``` splus
m2 = mxModel(m1, mxPath(from = "gear", to = "mpg", free = F, values = 0)
m2 = mxRun(m2)
```
``` splus
umxCompare(m1, m2)
```

2. Use a label and umxReRun()

By default, umxReRun fixes the value of matched labels to zero.

``` splus
m2 = umxReRun(m1, update = "gear_to_mpg", name = "no effect of gear")
```

`umxReRun()` can modify, run, and compare all in 1-line

``` splus
	m2 = umxReRun(m1, update = "gear_to_mpg", name = "drop effect of gear"), comparison = TRUE)
```


umxReRun Is a convenience function to re-run an mxModel, optionally adding, setting, or dropping parameters. The main utility of `umxReRun` is compactness. 

For example, this one-liner drops a path labelled "Cs", tests the effect, and returns the updated model

```r
fit2 = umxReRun(fit1, update = "Cs", name = "newModelName", comparison = T) 
```
A powerful feature of umxReRun is regular expressions. These let you drop collections of paths by matching patterns. So, 

```r
fit2 = umxReRun(fit1, update = "Cs_r1_c[0-9].", regex = TRUE, name = "drop_all_cols_of_row1_of_Cs", comparison = T)
```
Will drop all paths with labels matching  "Cs_r1_c" followed by anyother digits. i.e., all columns of row 1.

### Parameters of unxReRun

In addition to the `lastFit` parameter (the mxModel you wish to update and re-run), umxReRun takes the following options:

`update` specifies what to update before re-running. It can be a list of labels, a regular expression (set regex = T) or an object such as an `mxCI` (mx confidence interval request).

```r
# 1. update by matching a label
fit2 = umxReRun(fit1, update = "Cs", name = "newModelName") 

# 2. update by matching a regular expression
fit2 = umxReRun(fit1, update = "C[sr]", regex = TRUE, name = "drop_Cs_andCr")

# 3. update by passing in a new object to be added to the model
fit2 = umxReRun(fit1, update = mxCI("Cs"), name = "withCI")
```
### free and value

By default, matched labels will be dropped, i.e., "free = F value = 0"

Set "free = TRUE" to free a variable. Set "value = X" to set the value of the matched paths to value X	

freeToStart	
Whether to update parameters based on their current free-state. free = c(TRUE, FALSE, NA), (defaults to NA - i.e, not checked)

### confidence Intervals

As in mxRun, you can set `intervals` = TRUE to run confidence intervals (see mxRun)

### comparison

To run umxCompare() and report on the old and new models, just set "comparison = TRUE"

```r
# 1. just run the new model
fit2 = umxReRun(fit1, update = "Cs", name = "newModelName") 

# 2. run new model, and compare to the lastFit
fit2 = umxReRun(fit1, update = "Cs", name = "newModelName", comparison = T) 
```