---
layout: post
title: "Data Wrangling"

comments: true
categories: technical
---

<a name="top"></a>

<a name="overview"></a>
# Overview

There are a range of cases where it is useful to manipulate data for modeling: for convenience (such as re-naming variables), to help ensure good solutions, e.g., by re-scaling variables, and in more focussed cases, like using the same scale factor for repeated measures in wide data. This post covers umx support for these needs.

We saw back in basic modeling post that data can vary substantially in mean and variance, and that this can make life hard for the optimizer.

As usual, the post assumes you've loaded `umx`:
```r
library("umx")
```

Starting with our very simple model of three raw variables:

```R
m1 <- umxRAM("my_first_model", data = mtcars,
	umxPath(cov = c("disp", "wt")),
	umxPath(c("disp", "wt"), to = "mpg"),
	umxPath(v.m.   = c("disp", "wt", "mpg"))
)
```

If we `plot` this, we can see that displacement has a MUCH bigger variance than the other variables...

```R
 plot(m1, mean=FALSE)
 ```
 
![unscaled_model](/media/1_make_a_model/unscaled_model.png "unscaled model of three variables")

Having variances differ by orders of magnitude can make it hard for the optimizer. In such cases, you can often get better results making variables more comparable: in this case, for instance, by converting displacement into litres to keep its variance closer to that of the other variables.

```R
df = mtcars
df$engine_litres = .016 * df$disp
m1 <- umxRAM("scaled", data = df,
	umxPath(cov = c("engine_litres", "wt")),
	umxPath(c("engine_litres", "wt"), to = "mpg"),
	umxPath(v.m.   = c("engine_litres", "wt", "mpg"))
)
```

Which is more comparable across variables:

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
 plot(m1, std=T, mean=FALSE)

 ```

![renamed](/media/1_make_a_model/renamed.png "All renamed")

