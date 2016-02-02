---
layout: post
title: "Cholesky paths with umxPath"
date: 1980-06-15 00:00
comments: true
categories: models twin
---

This page will introduce writing Cholesky structures using umxPath to facilitate twin modeling.

It is not finished, and for now (and perhaps for sometime), I'd recommend you read [this page instead on the awesome umxACE](/models/twin/2020/05/06/Twin-umxACE.html) function

```splus
# ====================
# = Cholesky example =
# ====================
latents   = paste0("A", 1:5)
manifests = names(demoOneFactor)
myData    = mxData(cov(demoOneFactor), type = "cov", numObs = 500)
m1 <- umxRAM("Chol", data = myData,
	umxPath(Cholesky = latents, to = manifests),
	umxPath(var = manifests),
	umxPath(var = latents, fixedAt = 1.0)
)
```

We can see that this fits perfectly:

```splus
umxSummary(m1)

```

What about a 1-factor solution?

```splus
m2 = umxReRun(m1, "^A[2:5]", regex = TRUE)

```

```splus
latents   = paste0("A", 1)
manifests = names(demoOneFactor)
myData    = mxData(cov(demoOneFactor), type = "cov", numObs = 500)
m3 <- umxRAM("Chol", data = myData,
	umxPath(Cholesky = latents, to = manifests),
	umxPath(var = manifests),
	umxPath(var = latents, fixedAt = 1.0)
)
umxSummary(m3)
plot(m3)
```



```splus
data(twinData)
tmpTwin <- twinData
names(tmpTwin)
# "fam", "age", "zyg", "part", "wt1", "wt2", "ht1", "ht2", "htwt1", "htwt2", "bmi1", "bmi2"

# Set zygosity to a factor
labList = c("MZFF", "MZMM", "DZFF", "DZMM", "DZOS")
tmpTwin$zyg = factor(tmpTwin$zyg, levels = 1:5, labels = labList)

# Pick the variables
selDVs = c("bmi1", "bmi2") # nb: Can also give base name, (i.e., "bmi") AND set suffix.
# the function will then make the varnames for each twin using this:
# for example. "VarSuffix1" "VarSuffix2"
mzData <- tmpTwin[tmpTwin$zyg %in% "MZFF", selDVs]
dzData <- tmpTwin[tmpTwin$zyg %in% "DZFF", selDVs]
mzData <- mzData[1:200,] # just top 200 so example runs in a couple of secs
dzData <- dzData[1:200,]

latentA = paste0(c("A1"), "_T", 1:2)
latentC = paste0(c("C1"), "_T", 1:2)
latentE = paste0(c("E1"), "_T", 1:2)
latents = c(latentA, latentC, latentE)

mz = umxRAM("mz", data = mxData(mzData, type = "raw"),
	umxPath(v1m0 = latents),
	umxPath(v.m. = selDVs),
	# twin 1
	umxPath(Cholesky = "A1_T1", to = "bmi1"),
	umxPath(Cholesky = "C1_T1", to = "bmi1"),
	umxPath(Cholesky = "E1_T1", to = "bmi1"),
	# twin 2
	umxPath(Cholesky = "A1_T2", to = "bmi2"),
	umxPath(Cholesky = "C1_T2", to = "bmi2"),
	umxPath(Cholesky = "E1_T2", to = "bmi2"),
	# A C E links
	umxPath("A1_T1", with = "A1_T2", fixedAt = 1),
	umxPath("C1_T1", with = "C1_T2", fixedAt = 1),
	umxPath("E1_T1", with = "E1_T2", fixedAt = 0)
)
dz = mxModel(mz, name= "dz",
	mxData(dzData, type = "raw"),
	umxPath("A1_T1", with = "A1_T2", fixedAt = .5)
)

m1 = mxModel(mz, dz, mxFitFunctionMultigroup(c("mz", "dz")))
omxGetParameters(mz)
plot(dz, showFixed= T)


m1 = umxACE(selDVs = selDVs, dzData = dzData, mzData = mzData)
m1 = umxRun(m1)
umxSummary(m1)
umxSummaryACE(m1)
## Not run: 
plot(m1)
```