---
layout: post
title: "umxSummary"

comments: true
categories: advanced
---


At its simplest, just pass a model to `umxSummary` to receive a default summary:

```r
require(umx)
manifests = names(demoOneFactor)

m1 = umxRAM("OneFactor", data = demoOneFactor,
	umxPath(latents, to = manifests),
	umxPath(v.m. = manifests),
	umxPath(v1m0 = latents)
)
```

```R
umxSummary(m1, std = TRUE)
```

|name       | Estimate|   SE|
|:----------|--------:|----:|
|G_to_x1    |     0.40| 0.02|
|G_to_x2    |     0.50| 0.02|
|G_to_x3    |     0.58| 0.02|
|G_to_x4    |     0.70| 0.02|
|G_to_x5    |     0.80| 0.03|
|x1_with_x1 |     0.04| 0.00|
|x2_with_x2 |     0.04| 0.00|
|x3_with_x3 |     0.04| 0.00|
|x4_with_x4 |     0.04| 0.00|
|x5_with_x5 |     0.04| 0.00|
|G_with_G   |     1.00| 0.00|
|one_to_x1  |    -0.04| 0.02|
|one_to_x2  |    -0.05| 0.02|
|one_to_x3  |    -0.06| 0.03|
|one_to_x4  |    -0.06| 0.03|
|one_to_x5  |    -0.08| 0.04|

χ²(5) = 7.4, p = 0.193; CFI = 0.999; TLI = 0.999; RMSEA = 0.031


By default raw parameters are shown, but standardized estimates can be requested, as above by using  `umxSummary(model, std=TRUE)`

For RAM models, the output can filter "NS" or "SIG" parameters:

 ```r
umxSummary(m1, filter = "SIG") # show only significant paths
umxSummary(model, filter = "NS") # show only NS paths
 ```

*advanced tip*:  What if I have raw data and no refmodels?

By default, OpenMx doesn't compute the independence and saturated models for raw data models (it can take some time, so is off by default). By default `umxRAM` computes the independence and saturated models for all data types. In some circumstances, however, you might find you have a model that lacks reference models. If so, here is how to call `umxSummary` and pass in reference models:

```R
umxSummary(model, refModels = mxRefModels(model, run = TRUE))
```

### Other parameters in umxSummary

umxSummary(model, std=F, digits = 2, report = c("markdown", "html"), filter = c("ALL", "NS",
  "SIG"), SE = TRUE, RMSEA_CI = FALSE)

## confint()
You can display the SE-based confidence intervals from a model using `confint`. You will get a table like this:

```R
                  2.5%        97.5%
G_to_x1     0.36633842  0.427170822
G_to_x2     0.46749315  0.538820807
G_to_x3     0.53666526  0.616661746
```

You can calculate "proper" Confidence intervals using `umxCI`.

## parameters()

`umx`'s `parameters` function gives a great deal of flexibility displaying the parameters of a model.

1. You can show only those parameters meeting some magnitude criterion:

```R
parameters(m1, thresh="above", b=.4)
     name Estimate
2 G_to_x2     0.50
3 G_to_x3     0.58
4 G_to_x4     0.70
5 G_to_x5     0.80
```

2. You can filter by parameter name, e.g. only means:

```R
parameters(m1, patt="one_to")
        name Estimate
11 one_to_x1    -0.04
12 one_to_x2    -0.05
13 one_to_x3    -0.06
14 one_to_x4    -0.06
15 one_to_x5    -0.08
```

## residuals()
Viewing residuals can be very helpful in understanding model misspecification.

The residuals function returns a nice table for you:

```R
residuals(m1)
 
|   |x1   |x2    |x3   |x4    |x5 |
|:--|:----|:-----|:----|:-----|:--|
|x1 |.    |.     |0.01 |.     |.  |
|x2 |.    |.     |0.01 |-0.01 |.  |
|x3 |0.01 |0.01  |.    |.     |.  |
|x4 |.    |-0.01 |.    |.     |.  |
|x5 |.    |.     |.    |.     |.  |
```

You can zoom in on bad values with, e.g. `suppress = .01`, which will hide values smaller than this. `digits` can control rounding.


Other functions to look at `vcov`
