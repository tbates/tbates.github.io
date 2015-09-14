---
layout: post
title: "Multiple groups"
date: 2020-02-15 00:00
comments: true
categories: models tutorial
---

### This is a work in progress: email me to prioritize this page if you want it sooner.

```splus
require(OpenMx)
require(umx)
data(demoOneFactor)
```

### 1. Make two models. As an example I'll just make a copy of model 1

```splus
latents  = c("G")
manifests = names(demoOneFactor)

m1 <- umxRAM("model1", data = mxData(cov(demoOneFactor), type = "cov", numObs = 500),
      umxPath(latents, to = manifests),
      umxPath(var = manifests),
      umxPath(var = latents, fixedAt = 1.0)
)
m2 <- mxModel(m1, name = "model2")
```

### 2. Nest them in a multi-group "supermodel" and run

```splus
m3 = mxModel("bob", m1, m2, mxFitFunctionMultigroup(c("model1", "model2")) )
m3 = mxRun(m3);
# 3 request saturated model
x = omxSaturatedModel(m3)
```

