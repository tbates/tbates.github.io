---
layout: post
title: "Data Wrangling"

comments: true
categories: technical
---

<a name="top"></a>

<a name="overview"></a>
# Overview

There are a range of cases where it is useful to manipulate data for modeling: for convenience (such as re-naming variables), to help ensure good solutions, e.g., by re-scaling variables, and in more focussed cases, like using the same scale factor for repeated measures in wide (e.g. twin) data. This post covers `umx` support for these needs.

We saw back in basic modeling post that data can vary substantially in mean and variance, and that this can make life hard for the optimizer.

### umx_residualise

We often want to residualise several variables prior to analysis. In twin-data, it is critical to use the same residual formula for all copies of a variable in the wide dataset. This can lead to complex, error-prone and lengthy code. For instance, in a recent paper, this is how I was residualizing some variables:

```r
twinData$MPQAchievement_T1 <- residuals(lm(Achievement_T1 ~ Sex_T1 + Age_T1 + I(Age_T1^2), data = twinData, na.action = na.exclude))                                                    
twinData$MPQAchievement_T2 <- residuals(lm(Achievement_T2 ~ Sex_T2 + Age_T2 + I(Age_T2^2), data = twinData, na.action = na.exclude))
```
One complex line of code for each twin. And I repeated this for 10 more variables: 20 lines of complex code&hellip; Lot&#x27;s of opportunity for a tupo &#x263A;

You also have to remember to `na.exclude` your `lm`() call.

With `umx_residualise` this can be reduced in two ways. This one-line residualizes both twin's data, and doesn't require typing all the suffixes:

```r
twinData = umx_residualise(Achievement ~ Sex + Age + I(Age^2), suffix = "_T", data = twinData)
```

`umx_residualise` can also residualise more than one dependent variable (though not with formulae yet). So this works:

```r
twinData = umx_residualise(c("Achievement", "Motivation"), c("Sex", "Age"), suffix = "_T", data = twinData)
```

### umx_scale

As usual, the post assumes you've loaded `umx`:

```r
library("umx")
```

Starting with our very simple model of three raw variables:

```R
m1 = umxRAM("my_first_model", data = mtcars,
	umxPath(cov = c("disp", "wt")),
	umxPath(c("disp", "wt"), to = "mpg"),
	umxPath(v.m. = c("disp", "wt", "mpg"))
)
```

If we `plot` this, we can see that displacement has a MUCH bigger variance than the other variables...

```R
 plot(m1, mean = FALSE)
```
 
![unscaled_model](/media/1_make_a_model/unscaled_model.png "unscaled model of three variables")

Having variances differ by orders of magnitude can make it hard for the optimizer. In such cases, you can often get better results making variables more comparable: in this case, for instance, by converting disp  (with its units of cubic inches) into displacement in litres. This will keep the variance of displacement smaller, and closer to that of the other variables.

```R
df = mtcars
df$engine_litres = .016 * df$disp
m1 <- umxRAM("scaled", data = df,
	umxPath(cov = c("engine_litres", "wt")),
	umxPath(c("engine_litres", "wt"), to = "mpg"),
	umxPath(v.m.   = c("engine_litres", "wt", "mpg"))
)
```

 `plot(m1, mean=FALSE)`
 
![scaled_disp](/media/1_make_a_model/scaled_disp.png "disp in litres")


A common workflow is to standardize all variables. *note*: Plot can give you a standardized output: just say` std=TRUE`

```R
df = umx_scale(mtcars)
m1 <- umxRAM("scaled", data = df,
	umxPath(cov = c("disp", "wt")),
	umxPath(c("disp", "wt"), to = "mpg"),
	umxPath(v.m.   = c("disp", "wt", "mpg"))
)
plot(m1, mean=FALSE)
 
```

![scaled](/media/1_make_a_model/scaled.png "All scaled")

### Renaming variables

Above, in the process of getting a variable with smaller variance, we created the less cryptic "engine_litres" variable name. `umx` provides `umx_rename` to ease this more generally.

```R
df = umx_scale(mtcars)
df = umx_rename(df, old=c("disp", "wt"), replace=c("engine_displacement", "car_weight"))

m1 <- umxRAM("scaled", data = df,
	umxPath(cov = c("engine_displacement", "car_weight")),
	umxPath(c("engine_displacement", "car_weight"), to = "mpg"),
	umxPath(v.m.   = c("engine_displacement", "car_weight", "mpg"))
)

plot(m1, std=TRUE, mean = FALSE)
```

![renamed](/media/1_make_a_model/renamed.png "All renamed")


e-mail me if you want more on scaling, or:

1. TODO: A tutorial on residualizing regular or wide (e.g. twin data) with `umx_residualize` and `umx_scale_wide_twin_data`.
2. TODO: A tutorial on going from wide to long and vice versa with `umx_long2wide` and `umx_wide2long`.
3. TODO: A tutorial on data simulation with `umx_make_TwinData`, `umx_make_fake_data`, and `umx_make_MR_data`

