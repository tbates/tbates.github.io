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

`umx` automatically and systematically labels parameters allowing models to be displayed and modified using these labels.

`labels` can be used to access a parameter (e.g. via `parameters`), to set that parameter (e.g. via `umxSetParameters`) or equate parameters (parameters with the same label have to take the same value, as well as to modify a model, via `umxModify`.

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

# Sidebar: Can I label matrices not created by umxRAM or other umx models?

Yes. By default, OpenMx doesn't label parameters, requiring them to be addressed using "bracket addresses", i.e `MyModel.S[2,2]` which addresses the parameter in column 2 and row 2 of the S matrix of a model called MyModel.

You can label any matrix (or entire model) using `umxLabel`

```r
m1 = umxLabel(m1)
parameters(m1) 

```

The default "matrix address" labels, i.e "One Factor.S[2,2]" are now set Informative labels: "G_to_x1", "x4_with_x4", etc.


<a name = "finding"></a>
## Showing parameters of a model (and their labels): the parameters() function

`umx` implements a `parameters` function to get all the labeled parameters from a model for you.

You can see how it works with this demo model:

```r
require(umx)
data(demoOneFactor)
manifests = names(demoOneFactor)
m1 <- umxRAM("One Factor", data = demoOneFactor, type = "cov",
	umxPath("G", to = manifests),
	umxPath(var = manifests),
	umxPath(var = "G", fixedAt = 1)
)
```


Let's get the parameters:

```r
parameters(m1)
#          name Estimate
# 1     G_to_x1     0.40
# 2     G_to_x2     0.50
# 3     G_to_x3     0.58
# 4     G_to_x4     0.70
# 5     G_to_x5     0.80
# 6  x1_with_x1     0.04
# 7  x2_with_x2     0.04
# 8  x3_with_x3     0.04
# 9  x4_with_x4     0.04
# 10 x5_with_x5     0.04

```

#### Filtering the parameter list to show just the labels you're looking for

Often there are many labels in a model. `parameters` allows you to "filter" this list, i.e., view just the ones you want. You can even write filters using regular expressions (statements that match wildcards and text patterns)!

So a simple filter on our 1-factor model `m1` might show only paths containing `G_to`

```r
parameters(m1, "G_to", free = TRUE) # Just labels beginning "G_to"
```

A clever regular-expression version uses ^ to "anchor" the expression to the start of the label.


<a name = "equating"></a>
# Get, Set, and Equate parameters by label
A primary use for labels is to equate parameters. If parameters have the same label, they are forced to have identical values. This also allows communicating a value across models in a [supermodel](http://tbates.github.io/advanced/1995/02/15/detailed-Multigroup.html).

**Properties of a parameter**

Parameters know three things:

1. Whether they are free.
2. What their current value is.
3. What their label is.

In this tutorial, we are going to [get](#getLabels) a parameter by it's label. We will then [set](#setLabels) a parameter value by label. Finally, we will use a label to [equate](#equate) two parameters.

Parameters are usually set in the process of model building or using `umxModify`, however you can also  use `umxSetParameters` to
select parameters in a model, and set their value, label, free state.

For all these examples, we will use our old friend, `m1`, so if you haven't made him, do so now:

```r
require(umx)
data(demoOneFactor)
m1 <- umxRAM("One Factor", data = demoOneFactor, type = "cov",
	umxPath("G", to = c('x1', 'x2', 'x3', 'x4', 'x5')),
	umxPath(var = c('x1', 'x2', 'x3', 'x4', 'x5')),
	umxPath(var = "G", fixedAt = 1)
)
```

<a name="getLabels"></a>
### Getting (reading) existing labels with umxGetParameters

Another feature we've used but not highlighted above is the `free` option. Compare these two outputs:

```r
umxGetParameters(m1) # All parameters
umxGetParameters(m1, free = TRUE) # Just parameters that are free
umxGetParameters(m1, free = FALSE) # Just parameters that are fixed
umxGetParameters(m1, free = TRUE, regex="^G") # Only free parameters with labels that start with a "G"
# "G_to_x1" "G_to_x2" "G_to_x3" "G_to_x4" "G_to_x5"

```

TIP: For RAM models, a quick way to get an overview of a model is with `tmx_show`

```r
tmx_show(m1)

# Values of S matrix (0 shown as .):
# 
# |   |x1   |x2   |x3   |x4   |x5   |G  |
# |:--|:----|:----|:----|:----|:----|:--|
# |x1 |0.04 |.    |.    |.    |.    |.  |
# |x2 |.    |0.04 |.    |.    |.    |.  |
# |x3 |.    |.    |0.04 |.    |.    |.  |
# |x4 |.    |.    |.    |0.04 |.    |.  |
# |x5 |.    |.    |.    |.    |0.04 |.  |
# |G  |.    |.    |.    |.    |.    |1  |
# 
# Values of A matrix (0 shown as .):
# 
# |   |x1 |x2 |x3 |x4 |x5 |G    |
# |:--|:--|:--|:--|:--|:--|:----|
# |x1 |.  |.  |.  |.  |.  |0.4  |
# |x2 |.  |.  |.  |.  |.  |0.5  |
# |x3 |.  |.  |.  |.  |.  |0.58 |
# |x4 |.  |.  |.  |.  |.  |0.7  |
# |x5 |.  |.  |.  |.  |.  |0.8  |
# |G  |.  |.  |.  |.  |.  |.    |

```

<a name="setLabels"></a>
### Setting a value by label

A common task in model modification is to set a parameter to 0. You can do this with `umxSetParameters`
by default, `umxSetParameters` also sets the `free` status of the affected labels to `FALSE`

```r
m2 = umxSetParameters(m1, labels="G_to_x5", values = 0)

parameters(m2, patt="G_to_x5")
#     name Estimate
#  G_to_x5      0.8

```

<a name="equate"></a>
### Equating two paths by  setting their label

Let's force G_to_x5 to have the same estimated value as G_to_x4:

```r
m2 = umxSetParameters(m1, labels="G_to_x5", newlabels = "G_to_x4")
m2 = mxRun(m2)
umxSummary(m2, std = TRUE)
parameters(m2) 
```

*Note*: the normal way to do this would be via `umxModify`



