---
layout: post
title: "Growth Curve"

comments: true
categories: models
---

### This is not finished: e-mail me to prioritise this page if you want it sooner.

[Latent growth](https://en.wikipedia.org/wiki/Latent_growth_modeling) models are common used when a measure is repeated over time, and we wish to propose and test a model in which the manifest variable is accounted for in terms of a mean and a growth function. This is implemented as a restricted common factor model.

This page shows how to implement these analyses in `umx` and `OpenMx`.

Let’s build this simple example based on 5 repeated measures (1:5) of "x". Graphically, the model looks like this (means not shown):

 
![latent growth in umx](https://tbates.github.com/media/growth/growth.png)

Here's the umx code: 7 lines without comments. Several assumptions, as you can see.

```r
require(umx)
data(myLongitudinalData)

latents = c("intercept", "slope")
manifests = c("x1", "x2", "x3", "x4", "x5")
m1 <- umxRAM("Linear Growth Curve", data = myLongitudinalData,
	# Latent variances and covariance
	umxPath(unique.pairs = c("intercept", "slope"), values = 1, labels = c("var_i", "cov", "var_s")),
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
plot(m1, means = T)

```
χ²(2494) = 9.19, p = 0.818; CFI = 1.003; TLI = 1.002; RMSEA = 0

| residual | var_i | cov  | var_s | mean_i | mean_s |
|:---------|:------|:-----|:------|:-------|:-------|
| 2.32     | 3.88  | 0.46 | 0.26  | 9.93   | 1.81   |

