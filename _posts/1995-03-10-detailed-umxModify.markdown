---
layout: post
title: "umxModify & umxCompare"

comments: true
categories: advanced
---

### Why make a new model when you can update one you already have?

In `umx`, models can be modified. Want to add a new path? Go ahead - no need to start from scratch. You can add, or remove anything, re-run, and compare. 

This tutorial covers using `umxModify` to do this.

The easiest and most powerful way to modify `umx` models is with the `umxModify` function.

`umxModify` is a convenience function to add, set, or drop parameters, re-name, and re-run a model.

Its main benefit is compactness. `umxModify()` can modify, run, and compare all in 1-line. So, the equivalent to the above three lines is:


<a name="overview"></a>

For what follows, we'll need a model, so: 

```r
manifests = c("mpg", "disp", "gear")
m1 <- umxRAM("big_motor_bad_mpg",
	umxPath(c("disp", "gear"), to = "mpg"),
	umxPath("disp", with = "gear"),
	umxPath(var = manifests),
	data = mtcars, type = "cov"
)
```

Now show a summary.

```R
umxSummary(m1, show = "std")

```

![model 1](/media/1_make_a_model/mtcar2.png "Model 1")

<a name="modify"></a>
## Modify a model

[Fundamentally](https://en.wikipedia.org/wiki/Causal_model), modeling is in the service of understanding causality and we do that primarily via model comparison: Better theories fit the data better than do worse theories.

So, "do more gears give better miles per gallon"? In graph terms, this is asking, "is the path from to gear to mpg significant?" There are two ways to test this with `umx`.

### 1. Overwriting a path with OpenMx's mxModel function

Using OpenMx's mxModel function, new paths over-write existing paths. So adding a new path, with value fixed to zero will accomplish our goal:

```r
m2 = mxModel(m1, umxPath("gear", to = "mpg", fixedAt = 0))
m2 = mxRun(m2)
```

You can then compare the two models

```r
umxCompare(m1, m2)
```

You can also do this with `umxModify`:

```R
m2 = umxModify(m1, umxPath("gear", to = "mpg", fixedAt = 0), comp=T)
```

### 2. Use umxModify() and labels 

The easiest and most powerful way to modify models is with umx's `umxModify` function. 

`umxModify` is a convenience function to add, set, or drop parameters, re-name, and re-run a model.

Its main benefit is compactness. `umxModify()` can modify, run, and compare all in 1-line.

For example, this one-liner drops a path labelled "gear_to_mpg", tests the effect, and returns the updated model:

```r
m2 = umxModify(m1, update = "gear_to_mpg", name = "drop effect of gear", comparison = TRUE)
```

χ²(1) = 0.08, p = 0.773; CFI = 1.017; TLI = 1.05; RMSEA = 0


|Model               | EP|∆ -2LL    |∆ df |p     |       AIC|Compare with Model |
|:-------------------|--:|:---------|:----|:-----|---------:|:------------------|
|big_motor_bad_mpg   |  6|          |     |      | -0.047875|                   |
|drop effect of gear |  5|0.1309833 |1    |0.717 | -1.916892|big_motor_bad_mpg  |



### More advanced options in umxModify

1. Pattern matching with regex
A powerful feature of `umxModify` is regular expressions. These let you drop collections of paths by matching patterns. So, 

```r
fit2 = umxModify(fit1, update = "Cs_r1_c[0-9].", regex = TRUE, name = "drop_all_cols_of_row1_of_Cs", comparison = T)
```

Will drop all paths with labels matching  "Cs_r1_c" followed by any other digits. i.e., all columns of row 1.

In addition to the `lastFit` parameter (the mxModel you wish to update and re-run), umxModify takes the following options:

`update` specifies what to update before re-running. It can be a list of labels, a regular expression (set regex = T) or an object such as an `mxCI` (mx confidence interval request).

1. update by matching a label

```r
fit2 = umxModify(fit1, update = "Cs", name = "newModelName") 
```
2. update by matching a regular expression

```r
fit2 = umxModify(fit1, update = "C[sr]", regex = TRUE, name = "drop_Cs_andCr")
```

3. update by passing in a new object to be added to the model

```r
fit2 = umxModify(fit1, update = mxCI("Cs"), name = "withCI")
```
### free and value

By default, matched labels will be dropped, i.e., "free = FALSE value = 0"

Set `free = TRUE` to free (instead of fix) a variable.

Set `value = X` to set the value of the matched paths to value X (instead of the default 0)

To update only parameters that are already free, set `freeToStart = TRUE`. This defaults to NA - i.e, state is ignored.

### Confidence Intervals

As in mxRun, you can set `intervals` = TRUE to run confidence intervals (see mxRun)

### comparison

To run `umxCompare`() and report on the old and new models, just set "comparison = TRUE"