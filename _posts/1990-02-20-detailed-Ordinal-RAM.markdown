---
layout: post
title: "Factor scores with missing data!"
date: 2019-02-20 00:00
comments: true
categories: advanced
---

# A simple one factor ordinal model

```splus
require(OpenMx)
data(demoOneFactor)
latents = c("G")
manifests = names(demoOneFactor)
m1 <- umxRAM("OneFactor", data = mxData(cov(demoOneFactor), type = "cov", numObs = 500),
	umxPath(latents, to = manifests),
	umxPath(var = manifests),
	umxPath(var = latents, fixedAt = 1)
)
m1 = mxRun(m1)
umxSummary(m1, showEstimates = "std")

```
	
### Add raw data and compute factor scores

```splus

# Swap in raw data in place of summary data
m2 <- mxModel(m1, mxData(demoOneFactor, type = "raw"))

# Estimate factor scores for the model
fs = mxFactorScores(m2, 'Regression')

```

### Create some missing data and compute factor scores

All the data-points of demoOneFactor are present:

```splus
all(complete.cases(demoOneFactor))
# [1] TRUE
```
Let's delete 10% from each column at random:

```splus
df = demoOneFactor
n = dim(df)[1];
for (i in dim(df)[2]) {
	df[sample(n, .1 * n), i] = NA
}
all(complete.cases(df))
```

Run again with the missing data:

```splus

m2 <- mxModel(m1, mxData(df, type = "raw"))
# Estimate factor scores for the model
fs = mxFactorScores(m2, 'Regression')

```

Just saved yourself $1000 buying Mplus for factor scores with missing data!