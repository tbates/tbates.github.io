---
layout: post
title: "EFA (Exploratory factor analysis) using umx"

comments: true
categories: models
---

[Factor analysis](https://en.wikipedia.org/wiki/Factor_analysis) takes a number of measured variables (manifest variables) and accounts for these in terms of a (smaller) number of latent variables, and uncorrelated residual variance, specific to each manifest variable. The number of factors to retain can be estimated using various methods including Horn's parallel analysis. These factors define a multi-dimensional space within which the items are located. The factors themselves can be transformed (rotated) to a simpler structure.

Performing a factor analysis in R is straightforward, as long as one does not have missing data. This code snippet gives an example of an analysis of 5 variables from the ubiquitous `mtcars` data set, retaining 2-factors: 

```splus
vars = c("mpg", "disp", "hp", "wt", "qsec")

factanal(~ mpg + disp + hp + wt + qsec, factors = 2, rotation="promax"data = mtcars)
#      Factor1 Factor2
# mpg  -0.851   0.345
# disp  0.871  -0.356
# hp    0.621  -0.701
# wt    0.996
# qsec -0.123   0.906
```

In umx, we can replicate this analysis with the `umxEFA` function:

```splus
m2 = umxEFA(name = "test", factors = 2, data = mtcars[, vars])
x = mxStandardizeRAMpaths(m2, SE=T)
x[,c(2,8,9)]

manifests <- names(data)
m1 <- umxRAM(model = name, data = data, autoRun = FALSE,
	umxPath(factors, to = manifests, connect = "unique.bivariate"),
	umxPath(v.m. = manifests),
	umxPath(v1m0 = factors, fixedAt = 1)
)

# loadings matrix is just:
load = m2$A$values[manifests, latents]

if rotation == "varimax"){
	load = varimax(load, normalize = TRUE, eps = 1e-5))
} else if (roations == "promax"){
	load = promax(load, m = 4)
}

m2$A$values[manifests, latents] = load

require(umx)
data(demoOneFactor)
latents   = c("g", "f")
manifests = names(demoOneFactor)
myData    = mxData(cov(demoOneFactor), type = "cov", numObs = 500)
m1 <- umxRAM("f", data = myData,
	umxPath(latents, to = manifests, connect="unique.bivariate"),
	umxPath(var = manifests),
	umxPath(var = latents, fixedAt = 1)
)
plot(m1)

```
