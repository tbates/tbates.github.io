---
layout: post
title: "How labels work in OpenMx, and how to get, set, and change them using umx."
date: 2020-10-03 00:00
comments: true
categories: models tutorial
---

### "In the beginning was the  label"

#### This page is not finished.

<%= table_of_contents(current_page) %>

OpenMx is MUCH more powerful when label your parameters.

Contrary to popular opinion, labeling things is [great!](http://www.amazon.com/Origin-Concepts-Oxford-Cognitive-Development). Labels are how we articulate concepts and invest meaning in things.

In [OpenMx](http://openmx.psyc.virginia.edu), labels are just as great. They get their power because when you label parameters, those labels can be used to control the parameter.

There are two ways in which labels are great: two parameters with the same label are just one parameter (i.e., labels implement constraints without all the hassle and time of constraints). Second, we can fix parameters by their label.

<a name="background"></a>
### A bit of background

#### How umx labels paths and matrices
By default, OpenMx doesn't label parameters. If you use umxRAM, then all your paths will be labelled. The labelling rule is

1. one-headed: <from> + "_to_" <to>
2. two-headed: <from> + "_with_" <to>
3. means: "mean_" <to>

So a path from "E" to "days_of_school" will be labelled "E_to_days_off_school"

For matrix based models, the rule is simpler (and more general). All cells are labeled

```splus
<matrixName> + "_r" <rowNumber> + "_c" <cellNumber>
```

So a cell on row 2, column 3 of a matrix called "a" would be labelled "a_r2_c3"

<a name = "finding"></a>
#### Finding labels

require(OpenMx)
data(demoOneFactor)
latents  = c("G")
manifests = names(demoOneFactor)
m1 <- mxModel("One Factor", type = "RAM",
	manifestVars = manifests, latentVars = latents,
	mxPath(from = latents, to = manifests),
	mxPath(from = manifests, arrows = 2),
	mxPath(from = latents, arrows = 2, free = FALSE, values = 1),
	mxData(cov(demoOneFactor), type = "cov", numObs = 500)
)
umxGetParameters(m1) # Default "matrix address" labels, i.e "One Factor.S[2,2]"
m1 = umxLabel(m1)
umxGetParameters(m1, free = TRUE) # Informative labels: "G_to_x1", "x4_with_x4", etc.
# Labeling a matrix
a = umxLabel(mxMatrix(name = "a", "Full", 3, 3, values = 1:9))
a$labels

<a name = "equating"></a>
### Equate parameters by label
A primary use for labels is to equate parameters. If parameters have the same label, they are forced to have identical values. They are especially powerful for allowing communication across [groups](groups in OpenMx), but also, as we will see here, within groups.

**Core concept in OpenMx**

Parameters know three things:
1. Whether they are free.
2. What their current value is.
3. What their label is.

In this tutorial, we are going to [get](#getLabels) a parameter by it's label. We will then [set](#setLabels) a parameter value by label. Finally, we will use a label to [equate](#equate) two parameters.

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
# we could also use
# umx_show(m1)
```

|   | x1 | x2 | x3 | x4 | x5 |  G |
|---|----|----|----|----|----|----|
|x1 | NA | NA | NA | NA | NA | NA |
|x2 | NA | NA | NA | NA | NA | NA |
|x3 | NA | NA | NA | NA | NA | NA |
|x4 | NA | NA | NA | NA | NA | NA |
|x5 | NA | NA | NA | NA | NA | NA |
|G  | NA | NA | NA | NA | NA | NA |

Despite these parameters having no explicit labels, we can still address them in OpenMx using bracket labels.

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

``` splus
m1 = umxLabel(m1)
m1 = umxStart(m1)
```

`umxRAM` does this for you, writing systematic path-based labels to every matrix label cell in the form `var1_to_var2` for single-heaed arrows, and `var1_with_var2` for double headed arrows.

Let's do that now

``` splus
manifests = names(demoOneFactor)
m1 <- umxRAM("m1", data = mxData(cov(demoOneFactor), type = "cov", numObs = nrow(demoOneFactor)),
	umxPath(from = "G", to = manifests),
	umxPath(var = manifests),
	umxPath(var = "G", fixedAt = 1)	
)
```

<a name="setLabels"></a>
### Setting a value by label

``` splus
m1 = omxSetParameters(m1, labels="x1_to_x5", values = 0)

umxGetParameters(m1, "^x1.*5$") # umxGetParameters can filter using regular expressions!
```

<a name="equate"></a>
### Equating two paths by  setting their label

``` splus
# force G_to_x5 to have the same estimated value as G_to_x4
m1 = omxSetParameters(m1, labels="G_to_x5", newlabels = "G_to_x4")
umxSummary(mxRun(m1), show = "std")
```

**Footnotes**
[^1]: 