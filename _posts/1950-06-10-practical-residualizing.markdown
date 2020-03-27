---
layout: post
title: "Residualizing wide data"

comments: true
categories: technical
---

<a name="top"></a>

# Controlling for covariates

A common need is to residualize variables prior to modeling. You might, for instance, want to control for (residualize) the effects of age on depression scores.

This post covers:

1. Simple residualization using `umx_residualize`
2. Residualizing twin (wide) data using `umx_residualize`

### Simpler tasks: a formula interface to residualization

R has great support for linear modeling with an insightful formula interface. Getting residuals can still benefit from a helper, however.

Here's residualization using base `R`:  Here, you need to remember to set the `na.action` to "na.exclude", and then do the residualization as a second step after the modelling.

```R
m1 = lm(mpg ~ cyl + disp, data = mtcars, na.action = na.exclude)
r2$mpg = residuals(m1)
```

Compare this to the same kind of thing done using `umx_residualize`:

```R
r1 = umx_residualize(mpg ~ cyl + I(cyl^2) + disp, data = mtcars)
```

### Wide Data

A common data format for `umx` is wide: 1-family per row for twin data. This complixifies normal approaches to residualization.

You MUST residualise data for both twins using the same beta weights. This means making the data long, doing the model, get the residualization results, then setting the data back to wide format.

`umx_residualize` does this in one line:

```R
df= umx_residualize(var="DEP", covs="age", suffixes= c("_T1", "_T2"), data=df)
```
