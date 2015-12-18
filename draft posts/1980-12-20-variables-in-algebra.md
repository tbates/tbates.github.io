---
layout: post
title: "Variables in algebras"
date: 1980-12-20 00:00
comments: true
categories: models tutorial
---

You can do piece-wise model building: That way you always know where an error has occurred to within one line.

```splus
	t1 <- mxModel("m1", type = "RAM")
```

    NOTE: You can also plot the model at each stage with `plot(model)`. This is really helpful as you add paths!

One exception to the piece-wise rule, is that the manifestVars and latentVars must be added to the mxModel in one step. Let's do that.

```splus
t1 <- mxModel(t1, manifestVars = manifests, latentVars = latents)

```
So, while you will apparently get away with this:

```splus
	t1 <- mxModel(t1, manifestVars = manifests)
```

This will then fail:

```splus
	t1 <- mxModel(t1, latentVars   = latents)
#	Error in cbind(manifestXmanifest, matrix(value, currentManifest, newManifest),  :
#	  number of rows of matrices must match (see arg 3)
```

```splus
library(umx)
data(myFADataRaw, package = "OpenMx")
manifests = paste0("x", 1:6)
myData = myFADataRaw[, manifests]
latents = c("G")

t1 <- mxModel("m1", type = "RAM")
t1 <- mxModel(t1, manifestVars = manifests, latentVars = latents)
t1 <- mxModel(t1, mxPath(from = latents, to = manifests))
```
Let's see what we've made so far (nb: this is a great way to keep on track!!)

```splus
plot(t1, std = F, showFixed=T, showMeans=T, showError=T)
```
Add on with the model:

```splus
t1 <- mxModel(t1, mxPath(from = manifests, arrows = 2))
t1 <- mxModel(t1, mxPath(from = latents, arrows = 2, free = F, values = 1))
t1 <- mxModel(t1, mxData(cov(myData), type = "cov", numObs = nrow(myData)))

t1 = mxRun(t1)

# all good

bob = pi
t1 <- mxRun(mxModel(t1, mxAlgebra(name = "whats2bob", bob * 2)))
t1$algebras$whats2bob$result # 6.283185
bob = 7
t1 <- mxRun(mxModel(t1, mxAlgebra(name = "cell1_7", A[1,bob])))
t1$algebras$whats2bob$result # 14
t1$algebras$cell1_7$result[1] # 0

t1 <- mxRun(mxMatrix(1:bob))

```

