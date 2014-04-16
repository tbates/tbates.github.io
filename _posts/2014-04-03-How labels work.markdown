---
layout: post
title: "How labels work."
date: 2014-04-03 00:00
comments: true
categories: models tutorial
---

### "In the beginning was the  label"

Labels are great. In OpenMx, labels are even greater. They get their power because in addition to a value, every parameter in OpenMx can have a label, and that label. In OpenMx, if two parameters have the same label, they are forced to have identical states. So labels are a tool for equating parameters within and across groups.

**Core concept in OpenMx**
Parameters know three things: Whether they are free, what their current value is, and, critically, what their label is.

In this tutorial, we are going to [set](#setLabels) labels, [get labels](#getlabels), and use labels to [equate](#equate) parameters.

<a name="getlabels"></a>
### Getting (reading) existing labels

Get Labels in a model
omxGetParameters(m1) # nb: By default, paths have no labels, and starts of 0

umxGetParameters(m1)

With `umxLabel`, you can easily add informative and predictable labels to each free path (works with matrix style as well!)

and use `umxStart`, to set sensible guesses for start values...
m1 = umxLabel(m1)
m1 = umxStart(m1)


``` splus
latents = c("G")
manifests = names(demoOneFactor)
m1 <- mxModel("One Factor", type = "RAM",
	manifestVars = manifests,
	latentVars  = latents,
	mxPath(from = latents, to = manifests),
	mxPath(from = manifests, arrows = 2),
	mxPath(from = latents  , arrows = 2, free = F, values = 1),
	mxData(cov(demoOneFactor), type = "cov", numObs = nrow(demoOneFactor))
)
```


**Footnotes**
[^1]: 