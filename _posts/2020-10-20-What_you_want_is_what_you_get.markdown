---
layout: post
title: "What you expect is what you get"
date: 2020-10-20 00:00
comments: true
categories: models tutorial
---

# Ignore this post: it's a work in progress...

This post refers to where we'd like umx to end up: As an intelligent research assistant: asking when you are unclear, but also able to understand your intentions.

We are not there yet: It's quite hard to take an [intentional stance](http://en.wikipedia.org/wiki/Intentional_stance"Wikipedia Entry: Intentional stance")!

When done, the first product of this thinking will be the `umxRAM()` function. Until then, read this as a document in flux.


<a name="top"></a>
The [OpenMx](http://openmx.psyc.virginia.edu) philosophy is "no black boxes". 

Unlike, say, Mplus, OpenMx doesn't do things behind the scenes. This means you get just what you request: Nothing more, and nothing less.

Partly the OpenMx philosophy is aided by R - it makes function defaults transparent: When you omit `arrows = 1`, you can see (glass box) that `mxPath` is going to set arrows to 1, because that default is in the function definition.

This means, however, that out of the box, OpenMx requires explicit setting of many things you might &ldquo;expect&rdquo; to happen automagically. In particular, OpenMx doesn't set values or labels. It also doesn't add paths or objects you don't explicitly request. So it doesn't add residual variances or covariances among exogenous variables.

The goal of `umx` is to take a slightly different perspective, perhaps best phrased as *"What you expect is what you get"*.

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
5. A and B have means as well as variances

How to implement this without black boxes?

```splus
df = myFADataRaw[, 1:2]
names(df) <- c("A", "B")
summary(lm(B~A, data = df))
```
This tells us that B = A × 𝛽1 + , where 𝛽1 = 0.64 CI95%[0.57, 0.71]. R² = 0.40 (F(1, 498) = 336.1,  p-value: << .001)

Now in OpenMx:

```splus
umxResiduals <- function(vars){
	mxPath(vars, arrows = 2) 	
}
umxMeans <- function(vars){
	mxPath("one", to = vars, arrows = 1)
}

manifests  = names(df)
m1 <- mxModel("A_causes_B", type = "RAM",
	manifestVars = manifests,
	mxPath("A", to = "B"), 
	umxResiduals(manifests), 
	umxMeans(manifests), 
	mxData(df, type = "raw")
)

m1 = umxRun(m1, setLabels = T, setValues = T)
umx_show(m1)
plot(m1)
umxSummary(m1, show = "both")

```

Let's take a more representatively complex model:

![Duncan](/media/umxFixed/Duncan.png)

How would we state the claims of this model, and what do we expect an intelligent assistant to take taken for granted?

The claim is 

1. Respondents and their friends each have a latent trait of "Aspiration"
2. These are formed from their [IQ](http://en.wikipedia.org/wiki/Intelligence_quotient"Wikipedia Entry: Intelligence quotient"), [SES](http://en.wikipedia.org/wiki/SES"Wikipedia Entry: SES"), and parental aspiration.
	* SES effects impact on both respondent and friend's aspiration.
3. Latent aspiration affects occupational and educational aspiration.
4. The aspiration latent traits interact with each other.

These are definitely choices and will need to tell OpenMx. That would look thus:

```splus

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

1. Aspiration is not completely determined by the exogenous measures.
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
#### TODO

1. Lots!

**Footnotes**
[^1]: `devtools` is @Hadley's package for using packages not on CRAN.

<!-- 
SEM package
1. `specifyModel` can take a list of "fixed" variables: exogenous variables with fixed variance?
2. it also adds residual variance for endogenous manifests?

Lavaan
1. 
-->

