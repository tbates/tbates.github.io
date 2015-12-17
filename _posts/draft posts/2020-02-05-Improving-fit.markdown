---
layout: post
title: "Improving models: residuals(), umxMI()"
date: 2020-02-05 00:00
comments: true
categories: advancedRAM
---

# Improving models

#### This page is not finished. When done it will explain umx functions to help you local why models are not well-fitting.

```splus    
library(umx)
data(demoOneFactor)
latents  = c("g")
manifests = names(demoOneFactor)
m1 <- mxModel("One Factor", type = "RAM", 
	manifestVars = manifests, latentVars = latents, 
	mxPath(latents  , to = manifests),
	mxPath(manifests, arrows = 2),
	mxPath(latents  , arrows = 2, free = F, values = 1.0),
	mxData(cov(demoOneFactor), type = "cov", numObs = 500)
)
m1 = umxRun(m1, setLabels = T, setValues = T)
residuals(m1)
residuals(m1, digits = 3)
residuals(m1, digits = 3, suppress = .005)
a = residuals(m1); 
```
