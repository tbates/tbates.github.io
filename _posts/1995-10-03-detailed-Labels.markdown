---
layout: post
title: "Labels to fix, drop, or equate paths."

comments: true
categories: advanced
content: true
toc: true
---

<!-- https://tbates.github.io/advanced/1995/10/03/detailed-Labels.html -->
### "In the beginning was the  <strike>word</strike> label"

Giving things names is key to [cognitive development](http://www.amazon.com/dp/0199838801), and labels are just as important in `umx`. Because you have MUCH more power to modify and update models when parameters are labeled, umx does this automatically and systematically for you.

This power comes because those labels can be used to control the parameter.

There are two ways in which labels are valuable: two parameters with the same label are effectively just one parameter (i.e., labels implement constraints without the hassles of mxConstraints).

Second, you can change a model by addressing its parameters by label. That's how, for instance, `umxSetparameters` works.

<a name="background"></a>
###  Path labels in umxRAM

If you use `umxRAM`, your paths will be get default labels according to the following rules:

1. one-headed paths: "fromVar_to_toVar"
2. two-headed paths: "fromVar_with_toVar"
3. means paths: "one_to_toVar"

So a path from "E" to "days_off_school" will be labelled "E_to_days_off_school"

###  Path labels in matrix-based models

For matrix based models, the rule is more general to cope with the varied uses of matrices in models. All cells are labeled: `matrixName_rROWNUM_cCOLNUM`

So the cell a[2,3] (matrix "a", row 2, col 3) will be labelled "a_r2_c3"

#### Example umxLabeled matrix

```r
a = umxLabel(mxMatrix(name = "a", "Full", 3, 3, values = 1:9))
a$labels
     [,1]     [,2]     [,3]    
[1,] "a_r1c1" "a_r1c2" "a_r1c3"
[2,] "a_r2c1" "a_r2c2" "a_r2c3"
[3,] "a_r3c1" "a_r3c2" "a_r3c3"

```


<a name = "finding"></a>
## Finding labels: the parameters() function

`umx` implements a `parameters` function to get all the labeled parameters from a model for you.

You can see how it works with this demo model:

```r
require(umx)
data(demoOneFactor)
manifests = names(demoOneFactor)
m1 <- umxRAM("One Factor", data = demoOneFactor, type = "cov",
	umxPath("G", to = manifests),
	umxPath(var = manifests, arrows = 2),
	umxPath(var = "G", fixedAt = 1)
)


```r
parameters(m1) 
         name Estimate
1     G_to_x1     0.40
2     G_to_x2     0.50
3     G_to_x3     0.58
4     G_to_x4     0.70
5     G_to_x5     0.80
6  x1_with_x1     0.04
7  x2_with_x2     0.04
8  x3_with_x3     0.04
9  x4_with_x4     0.04
10 x5_with_x5     0.04

```

#### Filtering the parameter list to show just the labels you're looking for

Often there are many labels in a model. `parameters` (or its alias `umxGetParameters`) allows you to "filter" this list, i.e., view just the ones you want. You can even write filters using regular expressions!

So a simple filter might show only paths containing `G_to`

```r
umxGetParameters(m1, "G_to", free = TRUE) # Just labels beginning "G_to"
```

A clever regular-expression version uses ^ to "anchor the expression" to the start of the label
```r
umxGetParameters(m1, "^G_to", free = TRUE) # Just labels beginning "G_to"
```

Another feature we've used but not highlighted above is the `free` option. Compare these two outputs:

```r
parameters(m1) # All parameters
parameters(m1, free = TRUE) # Just parameters that are free
parameters(m1, free = FALSE) # Just parameters that are fixed
```


<a name = "equating"></a>
# Equate parameters by label
A primary use for labels is to equate parameters. If parameters have the same label, they are forced to have identical values. They are especially powerful for allowing communication across [groups](http://tbates.github.io/advanced/1995/02/15/detailed-Multigroup.html), but also, as we will see here, within groups.

**Core concept in OpenMx**

Parameters know three things:
1. Whether they are free.
2. What their current value is.
3. What their label is.

In this tutorial, we are going to [get](#getLabels) a parameter by it's label. We will then [set](#setLabels) a parameter value by label. Finally, we will use a label to [equate](#equate) two parameters.

For all these examples, we will use our old friend, `m1`, so if you haven't made him, do so now:

```r
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

Let’s have a look at the `A` matrix, which contains our asymmetric paths

```r
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

```r
omxGetParameters(m1) # nb: By default, paths have no labels, and starts of 0
```

| m1.A[1,6] |  m1.A[2,6] |  m1.A[3,6] |  m1.A[4,6] |  m1.A[5,6] |  m1.S[1,1] |  m1.S[2,2] | m1.S[3,3] |  m1.S[4,4] |  m1.S[5,5] |  
|-----------|------------|------------|------------|------------|------------|------------|-----------|------------|------------|  
|        0  |         0  |       0    |     0      |  0         |    0       |     0      |    0      |    0       |         0  |

Here you can see that OpenMx leaves labels blank by default

umxGetParameters(m1)

With `umxLabel`, you can easily add informative and predictable labels to each free path (works with matrix style as well!)

and use `umxStart`, to set sensible guesses for start values...

```r
m1 = umxLabel(m1)
m1 = umxStart(m1)
```

`umxRAM` does this for you, writing systematic path-based labels to every matrix label cell in the form `var1_to_var2` for single-heaed arrows, and `var1_with_var2` for double headed arrows.

Let’s do that now

```r
manifests = names(demoOneFactor)
m1 <- umxRAM("m1", data = mxData(cov(demoOneFactor), type = "cov", numObs = nrow(demoOneFactor)),
	umxPath(from = "G", to = manifests),
	umxPath(var = manifests),
	umxPath(var = "G", fixedAt = 1)	
)
```

<a name="setLabels"></a>
### Setting a value by label

```r
m1 = omxSetParameters(m1, labels="x1_to_x5", values = 0)

umxGetParameters(m1, "^x1.*5$") # umxGetParameters can filter using regular expressions!
```

<a name="equate"></a>
### Equating two paths by  setting their label

```r
# force G_to_x5 to have the same estimated value as G_to_x4
m1 = omxSetParameters(m1, labels="G_to_x5", newlabels = "G_to_x4")
umxSummary(mxRun(m1), show = "std")
```

```r
parameters(m1) 

# How can I label matrices not created by umxRAM or other umx models?

By default, OpenMx doesn't label parameters, and they are addressed using "bracket addresses", i.e "MyModel.S[2,2]" 
which addresses the parameter in column 2 and row 2 of the S matrix of a model called MyModel.

You can label any matrix (or entire model) using `umxLabel`

```r
m1 = umxLabel(m1)
parameters(m1) 

```

The default "matrix address" labels, i.e "One Factor.S[2,2]" are now set Informative labels: "G_to_x1", "x4_with_x4", etc.

```



