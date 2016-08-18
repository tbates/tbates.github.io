---
layout: post
title: "Growth Curve"
date: 1970-08-13 00:00
comments: true
categories: models
---

### This is not finished: e-mail me to prioritise this page if you want it sooner.

[Latent growth](https://en.wikipedia.org/wiki/Latent_growth_modeling) models are common used when a measure is repeated over time, and we wish to propose and test a model in which the manifest variable is accounted for in terms of a mean and a growth function. This page shows how to implement these analyses in `umx` and `OpenMx`.


```splus
require(umx)
data(myLongitudinalData)

latents = c("intercept", "slope")
manifests = c("x1", "x2", "x3", "x4", "x5")
m1 <- umxRAM("Linear Growth Curve", data = myLongitudinalData,
	# Latent variances and covariance
	umxPath(unique.pairs = c("intercept", "slope"), values = 1, labels = c("vari", "cov", "vars")),
	# Fix intercept loadings @0 and slope loadings @c(0,1,2,3,4) (linear)
	umxPath("intercept", to = manifests, fixedAt = 1),
	umxPath("slope", to = manifests, fixedAt = 0:(length(manifests) - 1)),
	# Allow latent means to be estimated
	umxPath(means = c("intercept", "slope"), labels = c("meani", "means")),
	# Equate manifest residuals, and fix means @0
	umxPath(var = manifests, labels = "residual"), # one label equates these!
	umxPath(mean = manifests, fixedAt = 0)
)
umxSummary(m1); round(coef(m1), 2)
# https://www.dropbox.com/s/ljqrhpuskbihda3/IV_Model.png?dl=0

```
