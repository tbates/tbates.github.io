---
layout: post
title: "What you expect is what you get"
date: 2020-10-20 00:00
comments: true
categories: models tutorial
---

<a name="top"></a>
The [OpenMx](http://openmx.psyc.virginia.edu) philosophy is "no block boxes". 

Unlike, say, Mplus, OpenMx doesn't do things behind the scenes. Partly the OpenMx philosophy is aided by R - it makes function defaults transparent: When you omit `arrows = 1`, you can see (glass box) that `mxPath` is going to set arrows to 1, becaue that default is in the function definition.

This means, however, that out of the box, OpenMx requires explicit setting of many things you might &ldquo;expect&rdquo;. In particular, it doesn't set start values or labels. It also doesn't add objects you don't explicitly request. So it doesn't add residual variances or covariances among exogenous variables.

`umx` takes a different perspective, best phrased as *"What you expect is what you get"*. 

It tries to do what you expect, much like people expected *"I didn't have sex with that woman"* to mean nothing happened. So…

# Things that go without saying…

What goes without saying? Let's take the example of this model: What does it claim?
                             
![A >B](/media/umxFixed/A->B.png)

Most people (I predict) would answer "A causes B".

This, to be precise, leaves a lot of expectations unstated - a lot is &ldquo;expected&rdquo;. Fully verbalized, people who know this means "changes in A cause changes in B" expect also that:

1. A and B are measures (squares) with [variance](http://en.wikipedia.org/wiki/Index_of_dispersion"Wikipedia Entry: Index of dispersion").
2. A accounts for some of the variance in B
3. But not all of it: B has [residual variance](http://en.wikipedia.org/wiki/Explained_variation"Wikipedia Entry: Explained variation").
4. Variance in A is [exogenous](http://en.wikipedia.org/wiki/Exogeny"Wikipedia Entry: Exogeny") to the model
 * As such, the variance of B is fixed at 1 (in [standardized](http://en.wikipedia.org/wiki/Standard_score"Wikipedia Entry: Standard score") terms)

How to implement this without black boxes?

In the SEM package, `specifyModel` can give exogenous variables fixed variance, and account for residual variance in endogenous variables.

Let's take a more representatively complex model:

![Duncan](/media/umxFixed/Duncan.png)

How would we state the claims of this model, and what do we expect an intelligent assistant to take taken for granted?

The claim is 

1. Respondents and their friends each have a latent trait of "Aspiration"
2. These are formed from their [IQ](http://en.wikipedia.org/wiki/Intelligence_quotient"Wikipedia Entry: Intelligence quotient"),  [SES](http://en.wikipedia.org/wiki/SES"Wikipedia Entry: SES"), and parental aspiration.
	* SES effects impact on both respondent and friend's aspiration.
3. Latent aspiration affects occupational and educational aspiration.
4. The aspiration latent traits interact with each other.

These are definitely your choice and will need to tell mxModel. That would look thus:

```splus

umxData <- function(observed, type, means = NA, numObs = NA) {
	setter <- function(x, value) assign(x, value, envir=parent.frame(2))
	setter("manifestVars", names(observed))
	return(mxData(observed, type, means = NA, numObs = NA))
}

rFormants = c("RSES", "FSES", "RIQ", "RParAsp")
fFormants = c("FSES", "RSES", "FIQ", "FParAsp")
rAsp = c("ROccAsp", "REdAsp")
fAsp = c("FOccAsp", "FEdAsp")
m1 = mxModel("Duncan", type = "RAM", 
	latentVars = latents, manifestVars = manifests,
	mxData(mtcars[,manifests], "raw"),
	# 1. Respondents and their friends each have a latent trait of "Aspiration"
	# 2. formed from IQ, SES, and parental aspiration.
	mxPath(from = rFormants, to = latent[1]),
	mxPath(from = fFormants, to = latent[2])
	# 3. Latent aspiration affects occupational and educational aspiration.
	mxPath(from = latent[1], to = rAsp),
	mxPath(from = latent[2], to = fAsp)
	# 4. The aspiration latent traits interact with each other.
	mxPath(from = latents, connect = "all.bivariate")
)
    
```

Additional items of note are that:

1. Aspiration is not are not completely determined by the exogenous measures.
2. The occupational and educational aspiration manifests are not completely determined by latent aspiration.
3. The measured variables forming aspiration covary each with the other, and are exogenous to the model.

```splus
# Two-pairs of exogenous variables reflected in 2 latent aspiration factors
mxPath(from = c("RIQ", "RSES"), to = "RGenAsp")
mxPath(from = c("FIQ", "FSES"), to = "FGenAsp")

# Latent aspiraiton influences outcomes 
# we want to understand
mxPath(from = "RGenAsp", to =  c("ROccAsp", "REdAsp"))
mxPath(from = "FGenAsp", to =  c("FOccAsp", "FEdAsp"))

# And the peers influence each other
# on one another
mxPath(from = "FGenAsp", to =  "RGenAsp")
mxPath(from = "RGenAsp", to =  "FGenAsp")
```

To this, we know we need to add variance for the exogenous variables like RIQ, and the latents, and residual variance for the DVs: like REdAsp. In umx we can do this in two lines.

```splus
umxFixed(c("RIQ" ,"RSES", "FIQ","FSES", "FGenAsp", "RGenAsp"), data = theData)
umxCovary(c("RIQ" ,"RSES", "FIQ","FSES"))
```

umxCovary just wraps the following 1-liner, but is cleaner to type.

```splus
	mxPath(from = vars, connect = "unique.bivariate", arrows = 2)
```

`umxFixed` looks in the data for the columns. Found columns, it sets the variance for. Others, it adds residuals

```splus
umxCovary <- function(vars)){
	return(mxPath(from = vars, connect = "unique.bivariate", arrows = 2))
}
```


```splus
# Variances for the 4 exogenous variables (sigmas)
mxPath(from = c("RIQ" ,"RSES", "FIQ","FSES"), arrows = 2)

# And two for the latents
mxPath(from = "ROccAsp", arrows = 2)
mxPath(from = "FOccAsp", arrows = 2)
```

Plus covariances among all the exogenous variables

```splus
mxPath(from = c("RIQ", "RSES", "FIQ", "FSES"), connect = "unique.bivariate", arrows = 2)
```

```splus    
uxmFixed(c("RIQ", "RSES", "FSES", "FIQ"))
umxResidual("ROccAsp", "FOccAsp") # latents have some exogenous variance (sigma)

# OR
umxVariance("ROccAsp", "FOccAsp", with data = Fixed, without = free) # latents have some exogenous variance (sigma)
```


The table below shows that dropping this path did not lower fit significantly(χ²(1) = 0.01, p = 0.905):

| Comparison        | EP | Δ -2LL     | Δ df  | p     | AIC   | Compare with Model |
|:------------------|:---|:-----------|:------|:------|:------|:-------------------|
| <NA>              | 4  | NA         | NA    | <NA>  | -4.00 | big_motor_bad_mpg  |
| no effect of gear | 3  | 0.0141     | 1     | 0.905 | -5.98 | big_motor_bad_mpg  |


Advanced tip: `umxReRun()` can modify, run, and compare all in 1-line

``` splus
	m2 = umxReRun(m1, update = "gear_to_mpg", name = "dop effect of gear"), comparison = TRUE)
```

**Footnotes**
[^1]: `devtools` is @Hadley's package for using packages not on CRAN.

#### TODO
1. Examples using  [personality](https://en.wikipedia.org/wiki/Five_Factor_Model) data.
2. IQ example. A model in which all facets load on each other. compare to *g*

