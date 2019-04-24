---
layout: post
title: "Labels to fix, drop, or equate paths."

comments: true
categories: advanced
content: true
toc: true
---

### "In the beginning was the  <strike>word</strike> label"

Making names for things is a key to [cognitive development](http://www.amazon.com/dp/0199838801). In [OpenMx](http://openmx.psyc.virginia.edu), labels are just as important. In fact, OpenMx is MUCH more powerful when label your parameters.

This power comes because those labels can be used to control the parameter.

There are two ways in which labels are valuable: two parameters with the same label are effectively just one parameter (i.e., labels implement constraints without all the hassle and time of constraints).

Second, we can change a model by addressing its parameters by label. That's how, for instance, `umxSetparameters`() works.

<a name="background"></a>
###  using umxLabel to create systematic paths and matrices for you.

By default, OpenMx doesn't label parameters. However, if you use umxRAM, then all your paths will be labelled. The labelling rule is

1. one-headed: &lt;from&gt; + &quot;_to_&quot; &lt;to&gt;
2. two-headed: &lt;from&gt; + &quot;_with_&quot; &lt;to&gt;
3. means: &quot;mean_&quot; &lt;to&gt;

So a path from "E" to "days_off_school" will be labelled "E_to_days_off_school"

For matrix based models, the rule is simpler (and more general). All cells are labeled

```r
<matrixName> + "_r" <rowNumber> + "_c" <cellNumber>

```

So a cell on row 2, column 3 of a matrix called "a" would be labelled "a_r2_c3"

<a name = "finding"></a>
#### Finding labels

```r
require(OpenMx)
data(demoOneFactor)
latents = c("G")
manifests = names(demoOneFactor)
m1 <- mxModel("One Factor", type = "RAM",
	manifestVars = manifests, latentVars = latents,
	mxPath(from = latents, to = manifests),
	mxPath(from = manifests, arrows = 2),
	mxPath(from = latents, arrows = 2, free = FALSE, values = 1),
	mxData(cov(demoOneFactor), type = "cov", numObs = 500)
)

```
###  Using the parameters()  function
umx implements a `parameters` function to get these for you.

```r
parameters(m1) # Default "matrix address" labels, i.e "One Factor.S[2,2]"
m1 = umxLabel(m1)
parameters(m1, free = TRUE) # Default "matrix address" labels, i.e "One Factor.S[2,2]"
# an alias for the same thing
umxGetParameters(m1, free = TRUE) # Informative labels: "G_to_x1", "x4_with_x4", etc.

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

# Labeling a matrix

```r
a = umxLabel(mxMatrix(name = "a", "Full", 3, 3, values = 1:9))
a$labels
     [,1]     [,2]     [,3]    
[1,] "a_r1c1" "a_r1c2" "a_r1c3"
[2,] "a_r2c1" "a_r2c2" "a_r2c3"
[3,] "a_r3c1" "a_r3c2" "a_r3c3"

```

<a name = "equating"></a>
# Equate parameters by label
A primary use for labels is to equate parameters. If parameters have the same label, they are forced to have identical values. They are especially powerful for allowing communication across [groups](http://tbates.github.io/models/tutorial/2020/02/15/multigroup-example.html), but also, as we will see here, within groups.

**Core concept in OpenMx**

Parameters know three things:
1. Whether they are free.
2. What their current value is.
3. What their label is.

In this tutorial, we are going to [get](#getLabels) a parameter by it's label. We will then [set](#setLabels) a parameter value by label. Finally, we will use a label to [equate](#equate) two parameters.

For all these examples, we will use our old friend, `m1`, so if you haven't made him, do so now:

```splus
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

```splus
m1 = umxLabel(m1)
m1 = umxStart(m1)
```

`umxRAM` does this for you, writing systematic path-based labels to every matrix label cell in the form `var1_to_var2` for single-heaed arrows, and `var1_with_var2` for double headed arrows.

Let’s do that now

```splus
manifests = names(demoOneFactor)
m1 <- umxRAM("m1", data = mxData(cov(demoOneFactor), type = "cov", numObs = nrow(demoOneFactor)),
	umxPath(from = "G", to = manifests),
	umxPath(var = manifests),
	umxPath(var = "G", fixedAt = 1)	
)
```

<a name="setLabels"></a>
### Setting a value by label

```splus
m1 = omxSetParameters(m1, labels="x1_to_x5", values = 0)

umxGetParameters(m1, "^x1.*5$") # umxGetParameters can filter using regular expressions!
```

<a name="equate"></a>
### Equating two paths by  setting their label

```splus
# force G_to_x5 to have the same estimated value as G_to_x4
m1 = omxSetParameters(m1, labels="G_to_x5", newlabels = "G_to_x4")
umxSummary(mxRun(m1), show = "std")
```


