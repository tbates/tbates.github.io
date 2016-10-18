---
layout: post
title: "Modification indices"

comments: true
categories: models tutorial
---

note: This page is not finished.


<a name="overview"></a>
## Modification Indices: Model-autopilot (desination unspecified).

Throughout these tutorials, I've encouraged you to compare theories. More often than not, however, the best fitting theory will still not yield a model which is "well fitting" according to accepted model-fit indices. The reason may be that no current theory fits the data very well (an opportunity for creativity and additional experimentation). It is often the case, however, that paths tangential to the main theory are needed: for instance a covariance between two very similar items. These additions are, of course, exploratory and should be reported as such. Preferably, cross-validate the modifications in new data.

Modification indices attempt an automated discovery of paths which will improve model fit by testing how much the fit improves if (current) fixed parameter is freed-up. 

umxModificationIndices(model) can re-estimate the whole model with each change (MI.full) or leave all other parameters fixed (MI). MI.full is more informative, but can take a significant amount of time.

One method to list "significant" modifications is to take a p-value for change of <= 0.01 


qchisq(p=1-0.01, df=1), or 6.63, is suggestive of a modification.


```splus
# Create a model
require(OpenMx); data(demoOneFactor)
latents <- c("G")
manifests <- names(demoOneFactor)
myData = mxData(cov(demoOneFactor), type = "cov", numObs = 500, means = colMeans(demoOneFactor))

m1 <- umxRAM("One Factor", data = myData,
	mxPath(latents, to= manifests[1:4]),
	umxPath(v1m0 = latents),
	umxPath(v.m. = manifests)
)

# TODO altern umxRAM to all X5<->x5 as valid path.

umxSummary(m1)
Looks fine
"χ²(5) = 7.38, p 0.194; CFI = 0.999; TLI = 0.999; RMSEA = 0.031"
```

Fit is less-good than we desire.

```splus
# See if it should be modified
# Notes
#  Using full = FALSE for faster performance
#  Using matrices= 'A' and 'S' to not get MIs for
#    the F matrix which is always fixed.

fim <- mxMI(factorRun, matrices = c('A', 'S'), full = FALSE)
round(fim$MI, 3)
plot(fim$MI, ylim=c(0, 10))
abline(h=qchisq(p=1-0.01, df=1)) # line of "significance"

```