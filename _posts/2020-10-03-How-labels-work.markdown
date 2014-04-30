---
layout: post
title: "How labels work in OpenMx, and how to get, set, and change them using umx."
date: 2020-10-03 00:00
comments: true
categories: models tutorial
---

### "In the beginning was the  label"

#### This page is not finished. When done it will explain how much more powerful OpenMx is when you label your parameters. 
#### Currently, this is just a very preliminary stub!

Labels are [great](http://www.amazon.com/Origin-Concepts-Oxford-Cognitive-Development). In [OpenMx](http://openmx.psyc.virginia.edu), labels are even greater. They get their power because, in OpenMx, in addition to having a value, every parameter can have a label. That label can be used to control the parameter. In OpenMx, if two parameters have the same label, they are forced to have identical states. So labels are a tool for setting equating parameters. They are especially powerful for allowing communication across [groups](groups in OpenMx), but also, as we will see here, within groups.

**Core concept in OpenMx**
Parameters know three things: Whether they are free, what their current value is, and, critically, what their label is.

In this tutorial, we are going to [get](#getLabels) a parameter by it's label. We will then [set](#setLabels) a value by label. Finally, we will use a label to [equate](#equate) two parameters.

For all these examples, we will use our old friend, `m1`, so if you haven't made him, do so now:

``` splus
latents = c("G")
manifests = names(demoOneFactor)
m1 <- mxModel("m1", type = "RAM",
	manifestVars = manifests,
	latentVars  = latents,
	mxPath(from = latents, to = manifests),
	mxPath(from = manifests, arrows = 2),
	mxPath(from = latents  , arrows = 2, free = F, values = 1),
	mxData(cov(demoOneFactor), type = "cov", numObs = nrow(demoOneFactor))
)
```

<a name="getLabels"></a>
### Getting (reading) existing labels

#### OpenMx Defaults

OpenMx has a built-in function for getting parameters from a model

Let's have a look at the `A` matrix, which contains our asymmetric paths

```splus
m1$matrices$A$labels # nb: By default, paths have no labels
```

|   | x1 | x2 | x3 | x4 | x5 |  G |
|---|----|----|----|----|----|----|
|x1 | NA | NA | NA | NA | NA | NA |
|x2 | NA | NA | NA | NA | NA | NA |
|x3 | NA | NA | NA | NA | NA | NA |
|x4 | NA | NA | NA | NA | NA | NA |
|x5 | NA | NA | NA | NA | NA | NA |
|G  | NA | NA | NA | NA | NA | NA |

Despite these free parameters having no labels, we can still address them in OpenMx.

```splus
omxGetParameters(m1) # nb: By default, paths have no labels, and starts of 0
```

| m1.A[1,6] |  m1.A[2,6] |  m1.A[3,6] |  m1.A[4,6] |  m1.A[5,6] |  m1.S[1,1] |  m1.S[2,2] | m1.S[3,3] |  m1.S[4,4] |  m1.S[5,5] |  
|-----------|------------|------------|------------|------------|------------|------------|-----------|------------|------------|  
|        0  |         0  |       0    |     0      |  0         |    0       |     0      |    0      |    0       |         0  |

Here you can see that OpenMx leaves labels blank by default

umxGetParameters(m1)

With `umxLabel`, you can easily add informative and predictable labels to each free path (works with matrix style as well!)

and use `umxStart`, to set sensible guesses for start values...
m1 = umxLabel(m1)
m1 = umxStart(m1)


<a name="setLabels"></a>
### Setting a value by label

``` splus
latents = c("G")
manifests = names(demoOneFactor)
m1 <- mxModel("m1", type = "RAM",
	manifestVars = manifests,
	latentVars  = latents,
	mxPath(from = latents, to = manifests),
	mxPath(from = manifests, arrows = 2),
	mxPath(from = latents  , arrows = 2, free = F, values = 1),
	mxData(cov(demoOneFactor), type = "cov", numObs = nrow(demoOneFactor))
)
```

<a name="equate"></a>
### Equating two paths by  setting their label

``` splus
latents = c("G")
manifests = names(demoOneFactor)
m1 <- mxModel("m1", type = "RAM",
	manifestVars = manifests,
	latentVars  = latents,
	mxPath(from = latents, to = manifests),
	mxPath(from = manifests, arrows = 2),
	mxPath(from = latents  , arrows = 2, free = F, values = 1),
	mxData(cov(demoOneFactor), type = "cov", numObs = nrow(demoOneFactor))
)
```

**Footnotes**
[^1]: 