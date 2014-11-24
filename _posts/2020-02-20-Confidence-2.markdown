---
layout: post
title: "Confidence on standardized parameters"
date: 2020-02-10 00:00
comments: true
categories: models tutorial
---

make a model...

```splus
library(umx);
data(myFADataRaw, package="OpenMx")
manifests = paste0("x",1:6)
myFADataRaw = myFADataRaw[, manifests]
a1 = umxRAM("m1",
	umxPath(from = "g", to = manifests),
	umxPath(var  = manifests),
	umxPath(var  = "g", fixedAt = 1),
	data = mxData(cov(myFADataRaw, use = "complete"), type = "cov", numObs = nrow(myFADataRaw))
)
a1 = umxRun(a1); umxSummary(a1)
```

Now, we can add a set of standardization algebras

```splus    
a1 = umx_add_std(a1, addCIs = TRUE)
a1 = umxRun(a1); umxSummary(a1)
```

If we set `intervals = TRUE` in `mxRun()` then we get the requested CIs. This is needed because CIs take time, so they are off by default.

```splus    
a1 = umxRun(a1, intervals = TRUE);
a1@output$confidenceIntervals

```
### umxSummary can format all this nicely for you.

```splus
umxSummary(a1)
# TODO modify this to report CIs
# 1. Incorporate estimate in the CI table
# 2. Use labels instead of bracket addressing from algebra
```
### Hard way to see how we do it inside

```splus
freeS = umx_make_bracket_addresses(a2@matrices$A, free= TRUE, newName="stdA")
# a3 = mxModel(a2, mxCI("stdS"))
a3 = mxModel(a2, mxCI(freeS))
a3 = mxRun(a3, intervals = TRUE); umxSummary(a3)
umx_report_time(a3)
summary(a3)$CI

```