---
layout: post
title: "Power of the path"
date: 2020-09-20 00:00
comments: true
categories: advanced
---

## "Staying on the (Wright) path"

`umxPath` is a core umx function.

It has a full set options to facilitate easy path specification, streamlining script writing, and increasing readability.

Let's start using `umxPath` to specify a [CFA](https://en.wikipedia.org/wiki/Confirmatory_factor_analysis) model with a slight increase in complexity: two linked latent factors forced to be the same:

![UmxPath Model1](/media/umxPath/umxPath_model1.png)

We'll also use umxRAM so we get automatic labeling and good start values.

```splus
# 1. grab some data
data(myFADataRaw, package = "OpenMx")
# 2. set up some handy lists
manifests = paste0("x", 1:3) # "x1" "x2" "x3"
latents = c("A","B")
df = myFADataRaw[, manifests]

m1 <- umxRAM("m1", data = mxData(df, "raw"),
	# 1-headed paths from latent B to each of the manifests
	umxPath("B", to = manifests),
	# a slightly silly linking of latent 1 with latent 2
	umxPath("A", with = "B", fixedAt = 1),
	# each of the manifests and latents needs a mean and variance
	umxPath(v.m. = manifests),
	umxPath(v1m0 = latents)	
)
plot(m1, showFixed = TRUE)
    
```

### Shortcuts

You just learned two shortcuts offered by umxPath: The "v1m0" and "v.m." options are short for "variance @1, mean @ zero" and "variance free, mean free" respectively.
We could break this out into 4 lines if desired:

```splus
umxPath(means = manifests),
umxPath(var   = manifests),
umxPath(means = latents, fixedAt = 0),
umxPath(var   = latents, fixedAt = 1),
```

For comparison, see how you would do that using `mxModel` and `mxPath`:

```splus
data(myFADataRaw, package = "OpenMx")
manifests = paste0("x", 1:3)
latents = c("A","B")
df = myFADataRaw[, manifests]

m1 <- mxModel("m1", type="RAM", 
	latentVars = latents,
	manifestVars = manifests,
	mxPath(from = "B", to = manifests),
	mxPath(from = "A", to = "B", arrows = 2, free = F, values = 1),
	mxPath(from = "one", to = manifests),
	mxPath(from = "one", to = latents, free = F, values = 0),
	mxPath(from = manifests, arrows = 2, free = F, values = 1),
	mxPath(from = latents  , arrows = 2, free = F, values = 1),
	mxData(df, "raw")
)    
```

*note*: mxModel does not run the model, has start values of zero or .1, and no labels.

The new terms for *connecting variables* are shown below, along with their `mxPath` equivalents

|New Term         | Example           | mxPath Equivalent                |
|-----------------|:-------------------|:---------------------------------|
| var             | var  = "X"         | from = "X", arrows = 2           |
| with            | "X", with = "Y"    | from = "X", to = "Y", arrows = 2 |
| cov             | cov = c("X","Y")   | from = "X", to = "Y", arrows = 2 |
| means           | means = c("X","Y") | from = "one", to = c("X","Y")    |
| v1m0            | v1m0 = c("X")      | requires two lines               |
| v.m.            | v.m. = c("Y")      | requires two lines               |
| unique.bivariate| unique.bivariate = c("X","Y", "Z") | from = c("X","Y", "Z"), connection = "unique.bivariate", arrows = 2|
| Cholesky        | Cholesky = c("X","Y"), to = c("a", "b") | a complex series of paths|

The intuition for `v.m.` is v for variance, m for means, and dot for "any value"

### unique.bivariate
`unique.bivariate` is a massive time saver and error-preventer. It allows a 1-line specification of bivariate paths between all distinct pairs of variables.

So to create paths "A&harr;B", "B&harr;C", and "A&harr;C", you can say just:

```splus
umxPath(unique.bivariate = c('A', 'B', 'C')
```
and get back the equivalent of 

```splus
umxPath("A", with  = "B")
umxPath("A", with  = "C")
umxPath("B", with  = "C")
```

### Cholesky

[Cholesky](/twin/2010/06/15/Cholesky.html) has a page of its own as this feature moves us into twin modeling.


### New words for setting values

The new words for *setting values* are shown below, along with their mxPath equivalents

| New term     | mxPath Equivalent                                  |
|:-------------|:---------------------------------------------------|
| fixedAt = 1  | free = FALSE, values = 1                           |
| firstAt = 1  | free = c(FALSE, TRUE, TRUE), values = c(1, NA, NA) |
| freeAt  = .6 | free = TRUE, values = .6                           |

`firstAt` saves you laboriously counting out and keeping check of linked lists of free and value items. `freeAt` allows you to manually set a starting value.


### Connection types

umxPath still lets you do anything mxPath does, and one cool thing about mxPath is it has many connection types.
I've exposed just unique.bivariate as a `umxPath` parameter, but the complete list of options is

1. "single"
2. "all.pairs"
3. "all.bivariate"
4. "unique.pairs"
5. "unique.bivariate"

Default value is "single".

### Values and labels

You might have noticed that we can say things like

```splus
umxPath(c("A", "B", "C"), values = 1)
```

Two things are happening here. First, the values field is being "recycled" for each of the three paths being created here, so the three paths will be started at 1. Second is the from field is being recycled into the to field. so:

```splus
umxPath(from  = "A")
```
is the same as:

```splus
umxPath(from  = "A", to = "A")
```

#### QuickLook: look often, run once

*Tip*: `plot`() is a great way to see what you are doing in a model as you build it: look often build once

```splus
    plot(umxRAM("tim", umxPath(c("mpg", "cyl", "disp"), value=1), data=mtcars, run=F))
	# hmmm single-headed arrows... should use "var = "
```
![quicklook](/media/umxPath/quickLook.png)
