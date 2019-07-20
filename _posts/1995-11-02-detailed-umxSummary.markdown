---
layout: post
title: "umxSummary"

comments: true
categories: advanced
---

## umxSummary()
At its simplest, just pass a model to `umxSummary` to receive a default summary:

```r
require(umx)
manifests = names(demoOneFactor)

m1 <- umxRAM("OneFactor", data = demoOneFactor,
	umxPath(latents, to = manifests),
	umxPath(v.m. = manifests),
	umxPath(v1m0 = latents)
)
```

```R
umxSummary(m1, showEstimates = "std")
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


By default raw parameters are shown, but standardized estimates can be requested, as above by using  `umxSummary(model, showEstimates = "std")`

For RAM models, the output can filter "NS" or "SIG" parameters:

 ```r
umxSummary(m1, filter = "SIG") # show only significant paths
umxSummary(model, filter = "NS") # show only NS paths
 ```

### What if I have raw data and no refmodels?

```R
umxSummary(model, refModels = mxRefModels(model, run = TRUE))
```
umxSummary(model, showEstimates = c("raw", "std", "none", "both", "list of column names"),
  digits = 2, report = c("1", "table", "html"), filter = c("ALL", "NS",
  "SIG"), SE = TRUE, RMSEA_CI = FALSE, matrixAddresses = FALSE, ...)


## confint()
* options

## parameters()
* model parameters

## residuals()
* options
 * filter minimum value to display

## vcov()
* options
 * filter minimum value to display

