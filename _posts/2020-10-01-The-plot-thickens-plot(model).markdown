---
layout: post
title: "A picture is worth a thousand words: Getting graphical Figures from OpenMx models"
date: 2020-10-01 00:00
comments: true
categories: models tutorial
---

# "The plot thickens"

#### This page is not finished. When done it will explain using plot() to produce figures from OpenMx
#### This is just a stub beginning!

## S3 method for class 'MxModel'

plot(model, std = TRUE, digits = 2, dotFilename = "name", pathLabels = c("none", "labels", "both"),
  showFixed = FALSE, showMeans = TRUE, showError = TRUE, ...)

Because path diagrams require laying out objects and paths, we use another product of Bell Labs, invented around the time that R's predecessor S was: Graphviz and the dot language.

At its simplest, you just provide a model, and plot() will create a path diagram.

```splus
plot(m1)
```

You can optionally output unstandardized output using `std`, and control the precision with `digits`

```splus
plot(m1, std=F, digits = 3)
```

The path model can be written to a file (the default is the name of the model with ".dot" suffix.

```splus
plot(m1, dotFilename= NA) # don't write any file
plot(m1, dotFilename= "~/tmp.dot") # specify a file

```

pathLabels	Whether to show labels on the paths. both will show both the parameter and the label. ("both", "none" or "labels")

showFixed	Whether to show fixed paths (defaults to FALSE)

showMeans	Whether to show means

showError	Whether to show errors

...	 Optional parameters


```splus
require(OpenMx)
data(demoOneFactor)
latents  = c("G")
manifests = names(demoOneFactor)
m1 <- umxRAM("One Factor", data = mxData(cov(demoOneFactor), type = "cov", numObs = 500),
	umxPath(latents, to = manifests),
	umxPath(var = manifests),
	umxPath(var = latents, fixedAt = 1.0)
)
m1 = mxRun(m1)
plot(m1)
```
**Footnotes**
