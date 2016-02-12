---
layout: post
title: "Statistical helper functions"
date: 1995-02-07 00:00
comments: true
categories: technical
---

There are many useful, but less-often called upon helpers in the umx library.
A great overview of these is sitting in the package help (`?umx`).

Have a read through. If there are any that are unclear, contact me, and I will add an explanation here.

### umx_residualise

As an example, we often want to residualise several variables prior to analysis. Sometimes even in wide data sets, but with the same residual 
formula for all copies of a variable in the wide dataset.

This can lead to complex, error-prone and lengthy code. For instance, in a recent paper, this is how I was residualizing some variables:

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

You could make it even briefer, but this is about where I am happy in terms of the brevity vs. explicit tradeoff.


On my **TODO** list are tutorial blogs about 

1. summaryAPA
2. 
