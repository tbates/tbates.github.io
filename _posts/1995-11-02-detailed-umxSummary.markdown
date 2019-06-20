---
layout: post
title: "umxSummary"

comments: true
categories: advanced
---

### This page is not finished. When done it will explain using umx functions to display results the way you already know from R

## umxSummary()
At its simplest, just pass a model to umxSummary to receive a default summary:

```r
	umxSummary(model)
```

This will show the raw parameters and a write-up style fit summary.


 * standardized output

 ```r
     umxSummary(model, showEstimates = c("raw", "std"
 ```

 * filter "NS" or "SIG"

 ```r
     umxSummary(model, showEstimates = filter = "SIG" # show only significant paths
     umxSummary(model, showEstimates = filter = "NS" # show only NS paths
 ```

### What if I have raw data and no refmodels?

`splus
	umxSummary(model, refModels = mxRefModels(model, run = T))

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

