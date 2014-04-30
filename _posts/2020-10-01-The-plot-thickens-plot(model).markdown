---
layout: post
title: "A picture is worth a thousand words: Getting graphical Figures from OpenMx models"
date: 2020-10-01 00:00
comments: true
categories: models tutorial
---

# "The plot thickens"

#### This page is not finished. When done it will explain using plot.MxModel() to produce figures from OpenMx
#### This is just a stub beginning!

```splus
require(OpenMx)
data(demoOneFactor)
latents  = c("G")
manifests = names(demoOneFactor)
m1 <- mxModel("One Factor", type = "RAM", 
	manifestVars = manifests, latentVars = latents, 
	mxPath(from = latents, to = manifests),
	mxPath(from = manifests, arrows = 2),
	mxPath(from = latents, arrows = 2, free = F, values = 1.0),
	mxData(cov(demoOneFactor), type = "cov", numObs = 500)
)
m1 = umxRun(m1, setLabels = T, setValues = T)
plot(m1)

```
**Footnotes**
[^1]: 