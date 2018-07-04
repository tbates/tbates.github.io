---
layout: post
title: "Simulation"

comments: true
categories: technical
---

<a name="top"></a>

# Simulation

Often you need simulated data to explore an idea.

`umx` offers `umx_make_TwinData`

You can also use the `mxGenerateData` function to build a model which captures your data, and then generate data from that model!

Make a model

```r
m1 <- umxRAM("simData", data = letters[1:3],
	umxPath(means = letters[1:3], values= 0),
	umxPath(var   = letters[1:3], values= 1),
	umxPath("a", with= "b", values= .4),
	umxPath("a", with= "c", values= .3),
	umxPath("b", with= "c", values= .4)
)
```

If you just want a dataframe back:

```r
simData = mxGenerateData(m1, nrows=1000)
umxAPA(m2) # have a look at it.
```


|          |a           |b           |c            |
|:---------|:-----------|:-----------|:------------|
|a         |1 (0)       |            |             |
|b         |0.27 (0.03) |1 (0)       |             |
|c         |0.26 (0.03) |0.41 (0.03) |1 (0)        |
|Mean (SD) |0.02 (1)    |-0.03 (1)   |-0.03 (0.99) |


You can implant that dataframe into a new model

```r
m1$expectation$data =mxData(simData)
```

Or just ask `mxGenerateData` to do that for you:

```r
m2 = mxGenerateData(m1, nrows = 1000, returnModel = TRUE)
```

Neat huh!
