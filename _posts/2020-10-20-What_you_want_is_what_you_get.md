---
layout: post
title: "What you expect is what you get"
date: 2020-10-20 00:00
comments: true
categories: models tutorial
---

When done, the first product of this thinking will be the `umxRAM()` function. Until then, you can treat this as a road-map, or skip ahead to learn about more functions.


### Overview
This post refers to where we'd like umx to end up: As an intelligent research assistant: asking when you are unclear, but also able to understand your intentions.

It's quite hard to take an [intentional stance](http://en.wikipedia.org/wiki/Intentional_stance"Wikipedia Entry: Intentional stance")! So, read on.


<a name="top"></a>
The [OpenMx](http://openmx.psyc.virginia.edu) philosophy is "no black boxes". 

Unlike, say, Mplus, OpenMx doesn't do things behind the scenes. This means you get just what you request: Nothing more, and nothing less.

Partly the OpenMx philosophy is aided by R - it makes function defaults transparent: When you omit `arrows = 1`, you can see (glass box) that `mxPath` is going to set arrows to 1, because that default is in the function definition.

This means, however, that out of the box, OpenMx requires explicit setting of many things you might &ldquo;expect&rdquo; to happen automagically. In particular, OpenMx doesn't set values or labels. It also doesn't add paths or objects you don't explicitly request. So it doesn't add residual variances or covariances among exogenous variables.

The goal of `umx` is to take a slightly different perspective, perhaps best phrased as *"What you expect is what you get"*.

It will be conservative in doing what you expect, so when you say *"I, did not, ask for that path in this model"* it won't be there :-). So…

# Things that go without saying…

What goes without saying? Let's take the example of this model: What does it claim?
                             
![A >B](/media/umxFixed/A->B.png)

Most people would answer "A causes B" (can someone test that?).

This, to be precise, leaves a lot of expectations unstated - a lot is &ldquo;intended&rdquo; to be understood.

Fully verbalized, people who know this means "changes in A cause changes in B" expect also that:

1. A and B are measured (squares)
2. That A and B have [variance](http://en.wikipedia.org/wiki/Index_of_dispersion"Wikipedia Entry: Index of dispersion").
2. That A accounts for *some* of the variance in B.
3. But not all of it: B has [residual variance](http://en.wikipedia.org/wiki/Explained_variation"Wikipedia Entry: Explained variation").
4. Variance in A is [exogenous](http://en.wikipedia.org/wiki/Exogeny"Wikipedia Entry: Exogeny") to the model
 * As such, the variance of B is fixed at 1 (in [standardized](http://en.wikipedia.org/wiki/Standard_score"Wikipedia Entry: Standard score") terms)
5. A and B have means as well as variances.

How to implement this without black boxes? Let's look at an `lm` statement of A <- B:

```splus
df = myFADataRaw[, 1:2]
names(df) <- c("A", "B")
summary(lm(B ~ A, data = df))
```
This tells us that B = A × 𝛽1 + , where 𝛽1 = 0.64 CI95%[0.57, 0.71]. R² = 0.40 (F(1, 498) = 336.1,  p-value: << .001)

Now in OpenMx:

```splus
manifests  = names(df)
m1 <- mxModel("A_causes_B", type = "RAM",
	manifestVars = manifests,
	mxPath("A", to = "B"), 
	umxResiduals(manifests), 
	umxMeans(manifests), 
	mxData(df, type = "raw")
)

m1 = umxRun(m1, setLabels = T, setValues = T)
umxSummary(m1, show = "both")
umx_show(m1)
plot(m1)

```

Let's take a more representatively complex model:

<img src="/media/umxFixed/Duncan.png" alt="Duncan SEM model" width="520">
<!-- https://github.com/robwierzbowski/jekyll-picture-tag -->


How would we state the claims of this model, and what do we expect an intelligent assistant to take taken for granted?

The theoretical claim is:

1. Respondents and their friends each have a latent trait of "Aspiration"
2. These are formed from their [IQ](http://en.wikipedia.org/wiki/Intelligence_quotient"Wikipedia Entry: Intelligence quotient"), [SES](http://en.wikipedia.org/wiki/SES"Wikipedia Entry: SES"), and parental aspiration.
	* SES effects impact on both respondent and friend's aspiration.
3. Latent aspiration affects occupational and educational aspiration.
4. The aspiration latent traits interact with each other.

These four choices clearly will need to be specified by the researcher.

What can the assistant assume for any model? Clearly she can assume we intend this to be a RAM model if we are using `umxRAM`, She can also assume that anything in the data is manifest, and that anything not in the data is latent. She can assume that any variables in the data but never referred to in the model should be deleted. She should tell us about these assumptions and what they cause her to do.

That allows us to delete this code from a standard ram model:

```splus
type = "RAM", 
latentVars = latents,
manifestVars = manifests,
```

Now some harder decisions. There are three claims of the model not yet included, for which our assistant might be able to assume intended answers.

1. Should she assume that endogenous variables like occupational aspiration have residual variance?
	* If so, we should automatically add:

	```splus    
		umxPath(c(respondentAsp, friendAsp))
	```
	* I'm happy with this flagged as a default option in `umxRAM()`. So by default, `endogenous.residuals = TRUE`

2. Should she assume that exogenous variables have variance?

	```splus    
		umxPath(unique.bivariate = c(respondentFormants, friendFormants))
	```
	* I'm happy with this as an option in `umxRAM()`, but defaulting to `exogenous.variances = TRUE`?

3. Should she assume that exogenous variables all intercorrelate, and add this path automatically?

	```splus    
		umxPath(unique.bivariate = c(respondentFormants, friendFormants))
	```
	* I'm happy with this as an option in `umxRAM()`, but defaulting to `covary.exogenous = TRUE`

4. Should she assume that latent traits like Respondent's Aspiration have residual variance?
	* This seems wrong: The user can reasonably be expected to state this explicitly.

So then we would build this model in umx like as follows

First, let's define some handy lists:

```splus
respondentFormants = c("RSES", "FSES", "RIQ", "RParAsp")
friendFormants     = c("FSES", "RSES", "FIQ", "FParAsp")
respondentAsp      = c("ROccAsp", "REdAsp")
friendAsp          = c("FOccAsp", "FEdAsp")
```

Now using these we can specify the model as follows:

```splus
m1 = umxRAM("Duncan", data = mtcars,
	# Respondents and their friends each have a latent trait of "Aspiration" formed from IQ, SES, and parental aspiration.
	umxPath(respondentFormants, to = "RGenAsp"),
	umxPath(friendFormants,     to = "FGenAsp"),

	# Latent aspiration affects occupational and educational aspiration.
	umxPath("RGenAsp", to = respondentAsp),
	umxPath("FGenAsp", to = friendAsp),

	# The latent traits interact with each other.
	umxPath(all.bivariate = latents),

	# The aspiration latent traits have residual variance.
	umxPath(var = latents),

	# =================
	# = Assumed paths =
	# =================
	# covary.exogenous  = TRUE
	umxPath(all.bivariate = c(friendFormants, respondentFormants)),
	# endogenous.resid  = TRUE
	umxPath(var = c(respondentAsp, friendAsp)),
)    
```

#### TODO

Lots!

1. Should we have some new functions, like umxFixed, umxResidual, umxVariance or umxLatent()?

I think we should handle all of these with `umxPath` and some new verbs. So to add a covariance structure behind a formative variable, you can use umxPath like this:

```splus
umxPath(respondentFormants, to = "RGenAsp"),
umxPath(friendFormants,     to = "FGenAsp"),
umxPath(unique.bivariate = c(respondentFormants, friendFormants))
```
**Footnotes**

<!-- 
SEM package
1. `specifyModel` can take a list of "fixed" variables: exogenous variables with fixed variance?
2. it also adds residual variance for endogenous manifests?

Lavaan
1. 

Possible new functions...

```splus    
uxmFixed(c("RIQ", "RSES", "FSES", "FIQ"))
umxResidual("ROccAsp", "FOccAsp") # latents have some exogenous variance (sigma)
umxVariance("ROccAsp", "FOccAsp", with data = Fixed, without = free) # latents have some exogenous variance (sigma)
umxFixed(c("RIQ" ,"RSES", "FIQ","FSES", "FGenAsp", "RGenAsp"), data = theData)
umxCovary(c("RIQ" ,"RSES", "FIQ","FSES"))
```

-->
