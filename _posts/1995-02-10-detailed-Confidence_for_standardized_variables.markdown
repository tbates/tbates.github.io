---
layout: post
title: "Confidence on standardized parameters"

comments: true
categories: advanced
---

This page is not yet finished!

This Page will discuss getting CIs on standardized parameters. Often, raw parameters are valuable: They give us a read-out of effects in the natural units of the variables in the model, e.g. change in miles per gallon per kg of extra vehicle weight, instead of change in SDs of miles per gallon per SD of weight, which is less meaningful.

However, especially in social science, readers are used to standardized effects. In addition, readers might want an idea of the relative size of an effect, and standardized parameters convey this.

To standardize models in umx, you typically add `std=TRUE` to the summary method. Getting SEs around these standardized values can be more involved. There are four ways umx can give CIs on standardized values.

1. Using SEs from `umxSummary` (for RAM models).
2. Running the model on standardized data.
3. Using `mxSE` to compute a standardized effect, along with mxCIs on these.
4. Adding mxAlgebras to compute standardized effects, along with `mxCI`s added for these algebras. This approach is most accurate, can be time consuming, is not guaranteed (models can have problems moving parameters to non-significant levels without them hitting boundaries or illegal values.)

### 1. Using SEs

Method 1 is easiest, and this is what `umxSummary` does for you for RAM models.

Given a RAM model, `umxSummary` can report either raw or standardized parameter estimates, and also the SE or standardized SE.

```R
m1 = umxRAM("tim", data = mtcars,
	umxPath(c("wt", "disp"), to = "mpg"),
	umxPath("wt", with = "disp"),
	umxPath(v.m. = c("wt", "disp", "mpg"))
)

umxSummary(m1, std=T)
```

|name           | Std.Estimate| Std.SE|CI                   |
|:--------------|------------:|------:|:--------------------|
|disp_to_mpg    |        -0.36|   0.18|-0.36 [-0.71, -0.02] |
|wt_to_mpg      |        -0.54|   0.17|-0.54 [-0.89, -0.2]  |
|mpg_with_mpg   |         0.22|   0.07|0.22 [0.08, 0.35]    |
|disp_with_disp |         1.00|   0.00|1 [1, 1]             |
|disp_with_wt   |         0.89|   0.04|0.89 [0.81, 0.96]    |
|wt_with_wt     |         1.00|   0.00|1 [1, 1]             |
|one_to_mpg     |         5.89|   0.68|5.89 [4.56, 7.22]    |
|one_to_disp    |         1.89|   0.30|1.89 [1.31, 2.47]    |
|one_to_wt      |         3.34|   0.45|3.34 [2.45, 4.23]    |

χ²(0) = 0, p = 1.000; CFI = 1; TLI = 1; RMSEA = 0

The calculate 95% confidence intervals around the standardized parameter values are based on `std estimate - (1.96 × std.SE)` and `std estimate + (1.96 × std.SE)`.

PS: If you haven't tried `umxAPA` have a look now: it can take many objects, and turn them into APA-style report format. For instance, data, lm results, and also effects/SE pairings.

### 2.  Using scaled data

A second method is to `scale()` your data (the easiest way is with `umxScale`, which handles skipping over binary and factor variables properly), and run the model on this z-scored data. All estimates are automatically in standardized terms. You can also add mxCI calls to the model to get profile-based estimates of confidence rather than extrapolate from the SEs.

### 2.  Adding algebras which compute the scaled value and calling mxCI

If you are an advanced user, you might add `mxAlgebra` calls which compute the standardized parameters (`umxACE` does this, for instance).

To get CIs around these algebras, you can either call `mxSE`(), giving it the model and the algebra you wish to estimate CIs for, or add `mxCI` calls to the model requesting CIs for the cells you want from these algebras. The underlying parameters of the model are then varied when the model is run seeking the values which drive the model-fit to the edge of the requested confidence limit. This is done for each of the CIs you request.

*nb*: For large, complex, raw-data or ordinal models, profile CIs can be very time-consuming. 

```r
library(umx);
data(myFADataRaw, package="OpenMx")
manifests = paste0("x",1:6)
a1 = umxRAM("m1", 	data = myFADataRaw, type = "cov",
	umxPath(from = "g", to = manifests),
	umxPath(var  = manifests),
	umxPath(var  = "g", fixedAt = 1)
)
umxSummary(a1)
```

Now, we can add a set of standardization algebras

```r
a1 = umxConfint(a1, parm = "all", run=TRUE)
```
