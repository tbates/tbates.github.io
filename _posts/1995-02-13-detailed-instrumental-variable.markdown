---
layout: post
title: "Instrumental Variables"
date: 1995-02-13 00:00
comments: true
categories: advanced
---

### This is not finished: e-mail me to prioritise this page if you want it sooner.

IV [Instrumental variable](https://en.wikipedia.org/wiki/Instrumental_variable) analyses are widely used in fields as diverse as economics, and epidemiology. This page shows how to implement these analyses in `OpenMx` and `umx`.

IV analyses allow us to estimate causal relationships when confounding is likely but controlled experiments are not feasible [1]

### Motivation: linear regression can be misleading
Consider some explanatory equation e.g. `Y ~ X + ε`. This claims that Y is influenced by X. If, however covariates are correlated with the error terms, ordinary least squares regression produces biased and inconsistent estimates.[2]

Such correlation with error occurs when:

1. The DV (Y) causes one or more of the covariates ("reverse" causation).
2. One or more explanatory variables is unmeasured.
3. Covariates are subject to measurement error.

Of course one or more of these are almost inevitable, making regression results suspect and often misleading.

If an `instrument` is available, these problems can be overcome. An instrumental variable is a variable that does not suffer from the problems of the confounded predictor. It must:

1. Not be in the explanatory equation.
2. Controlling for ("conditional on") any other covariates, it must correlate with the endogenous explanatory variable(s).

In linear models, there are two main requirements for using an IV:

1. The instrument must be correlated with the endogenous explanatory variables, conditional on the other covariates.
2. The instrument cannot be correlated with the error term in the explanatory equation (conditional on the other covariates)

Based on Professor [David Evans'](http://www.di.uq.edu.au/professor-david-evans) [presentation]() at the [2016 International twin workshop](), 

This example, we fit the same model to each of two groups, allowing the residual variances to differ between the groups, then testing if those can be equated.

```r
require(umx)
data(demoOneFactor)
```

### 1. Make two models. As an example I'll just make a copy of model 1

```r
latents  = c("G")
manifests = names(demoOneFactor)

m1 <- umxRAM("model1", data = mxData(cov(demoOneFactor[1:200,]), type = "cov", numObs = 500),
      umxPath(latents, to = manifests),
      umxPath(var = manifests),
      umxPath(var = latents, fixedAt = 1.0)
)
m2 <- mxModel(m1, name = "model2",
	mxData(cov(demoOneFactor[300:500,]), type = "cov", numObs = 500)
)
```

### 2. Nest them in a multi-group "supermodel" and run

```r
m3 = mxModel("super", m1, m2, 
	mxFitFunctionMultigroup(c("model1", "model2"))
)
m3 = mxRun(m3);
# 3 request saturated model
summary(m3, refModels = mxRefModels(m3))
```

