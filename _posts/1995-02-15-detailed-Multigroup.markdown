---
layout: post
title: "Multiple groups"

comments: true
categories: advanced
---


In `umx`, multi-group models are just sub-models inside a `umxSuperModel` This is a container that uses `mxFitFunctionMultigroup` as a fit function.

The most explicit way to make a multi-group model is to create each group as its own model in the normal way, then place these into `umxSuperModel`.

For the case of a `umxRAM` model, where all the groups will be the same except for the data they contain, `umxRAM` supports a `group = ` parameter. This will be familiar to [lavaan](http://lavaan.ugent.be) users and functions the same in `umx`. Both ways are demonstrated next.

### Placing sub-models into a Supermodel

This example, we build a model for each of two groups, allowing the residual variances to differ between the groups (different [labels](https://tbates.github.io/advanced/1995/10/03/detailed-Labels.html) for the residuals in each group). They are then made into a supermodel. We then test if the residuals can be equated.

```r
require(umx)
data(demoOneFactor)
```

### 1. Make two models with different data.


```r
manifests = names(demoOneFactor)

m1 = umxRAM("model1", data = demoOneFactor[1:200, ],
      umxPath("G", to = manifests),
      umxPath(v.m. = manifests),
      umxPath(v1m0 = "G")
)

# model 2 with a different set of data
m2 = umxRAM("model2", data = demoOneFactor[300:500, ], autoRun = FALSE,
      umxPath("G", to = manifests),
      umxPath(v.m. = manifests),
      umxPath(v1m0 = "G")
)

```

*user tip*: You can avoid running `umxRAM` models by setting `autoRun=FALSE`` in `umxRAM()`

### 2. Nest them in a multi-group "supermodel" and run

```r
m3 = umxSuperModel("myfirstsupermodel", m1, m2)
```

*Note:* As of 2019-07-28, OpenMx had an [issue](https://github.com/OpenMx/OpenMx/issues/221) with reporting fit indices.

TODO: multi-group: Set the residuals free in these two models

### Multi-group with umxRAM "group ="

```R
data("HS.ability.data", package = "OpenMx")

cov(HS.ability.data[, c("visual"  , "cubes"   , "flags")])
cov(HS.ability.data[, c("paragrap", "sentence", "wordm")])
cov(HS.ability.data[, c("addition", "counting", "straight")])

HS = "spatial =~ visual   + cubes    + flags
verbal  =~ paragrap + sentence + wordm
speed   =~ addition + counting + straight"

m1 = umxRAM(HS, data = umx_scale(HS.ability.data))

# Multiple groups
m1 = umxRAM(HS, data = umx_scale(HS.ability.data), group = "school")
 ```

