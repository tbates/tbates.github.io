---
layout: post
title: "Factor scores with missing data!"

comments: true
categories: advanced
---

# A simple one factor ordinal model

```r
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

```r

# Swap in raw data in place of summary data
m2 <- mxModel(m1, mxData(demoOneFactor, type = "raw"))

# Estimate factor scores for the model
fs = mxFactorScores(m2, 'Regression')

```

### Create some missing data and compute factor scores

All the data-points of demoOneFactor are present:

```r
all(complete.cases(demoOneFactor))
# [1] TRUE
```
Let's delete 10% from each column at random:

```r
df = demoOneFactor
n = dim(df)[1];
for (i in dim(df)[2]) {
	df[sample(n, .1 * n), i] = NA
}
all(complete.cases(df))
```

Run again with the missing data:

```r

m2 <- mxModel(m1, mxData(df, type = "raw"))
# Estimate factor scores for the model
fs = mxFactorScores(m2, 'Regression')

```

Just saved yourself $1000 buying Mplus for factor scores with missing data!