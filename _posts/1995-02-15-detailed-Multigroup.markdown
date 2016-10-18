---
layout: post
title: "Multiple groups"

comments: true
categories: advanced
---

### This is a work in progress: email me to prioritize this page if you want it sooner.

In OpenMx, multi-group models are just sets of models along with a container model that uses `mxFitFunctionMultigroup` 
as a fit function.

We can make trivial example that shows how this works.

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

