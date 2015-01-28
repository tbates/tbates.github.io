---
layout: post
title: "What you expect is what you get"
date: 2020-10-20 00:00
comments: true
categories: models tutorial
---

This is a bit of a road-map essay, you can skip it without losing much.


### Overview
This post refers to where we'd like `umx` to end up: As an intelligent research assistant: asking when you are unclear, but also able to understand your intentions.

ideally it would be like [Palantir](www.Palantir.com) ☺

Assisting requires taking an [intentional stance](http://en.wikipedia.org/wiki/Intentional_stance"Wikipedia Entry: Intentional stance"). This is hard, and can lead to black-box behavior, so, read on.


<a name="top"></a>
The [OpenMx](http://openmx.psyc.virginia.edu) philosophy is "no black boxes". 

Unlike, say, Mplus, OpenMx doesn't do things behind the scenes. You get what you request: Nothing less, and Nothing more.

Partly the OpenMx philosophy is aided by R - it makes function defaults transparent: When you omit `arrows = 1`, you can see (glass box) that `mxPath` is going to set arrows to 1, because that default is in the function definition.

This means, however, that out of the box, OpenMx requires explicit setting of many things you might &ldquo;expect&rdquo; to happen automagically. In particular, OpenMx doesn't set values or labels. It also doesn't add paths or objects you don't explicitly request. So it doesn't add residual variances or covariances among exogenous variables.

The goal of `umx` is to take a slightly different perspective, perhaps best phrased as *"It's easy to realise your expectations"*.

`umx` is [conservative](https://en.wikipedia.org/wiki/Moral_Foundations_Theory) in doing what you expect.

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

Now with umx:

```splus
manifests  = names(df)
m1 <- umxRAM("A_causes_B", data = df,
	umxPath("A", to = "B"), 
	umxPath(var = manifests), 
	umxPath(means = manifests)
)

m1 = mxRun(m1)
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
		umxPath(var = c(respondentAsp, friendAsp))
	```
	* We might, like `sem` implement this (the skeleton is in the umxRAM function. But in practice, this is a one liner, that actually helps your thinking to add.
	* If `umxRAM()` were to default to  `endogenous.residuals = TRUE`, then you have to figure out what it has figured out are Endogenous variables (manifests with incoming arrows and no outgoing arrows).

2. Should she assume that exogenous variables have variance?

	```splus    
		umxPath(var = c(respondentFormants, friendFormants))
	```
	* Again, it's so easy to say with umxPath, that defaulting to `exogenous.variances = TRUE` causes more mental work than it saves, IMHO.

3. Users often want to set the first loading on a factor to 1, or set the variance of latent traits to 1 should she assume one of these for us?
	* My approach here is to make this easy to do in the same umxPath statement that creates the loadings or the latent variance.

So you can say:

	```splus    
		umxPath(var = "latentX", fixedAt = 1)
	```
but also:

	```splus    
		umxPath("latentX", to = c("DV1", "DV2", "DV3"), firstAt = 1) # fix the first path, leave the others free
	```
and

```splus    
umxPath(v1m0 = "latentX")
```

which is short-hand for

```splus    
umxPath(var   = "latentX", fixedAt=1)
umxPath(means = "latentX", fixedAt=0)
```

which is equivalent to:

```splus    
mxPath("latentX", free = FALSE, values = 1)
mxPath("latentX", free = FALSE, values = 0)
```


4. Should she assume that exogenous variables all intercorrelate, and add this path automatically?
	* `umxRAM()` could have the option  `covary.exogenous = FALSE`. but again, who does this help when this is so clear?

```splus    
umxPath(unique.bivariate = c(respondentFormants, friendFormants))
```

5. Should she assume that latent traits like Respondent's Aspiration have residual variance?
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

	# covary.exogenous  = TRUE
	umxPath(all.bivariate = c(friendFormants, respondentFormants)),
	# endogenous.resid  = TRUE
	umxPath(var = c(respondentAsp, friendAsp)),
)    
```

Pretty simples, no?


#### TODO

Lots!

**Footnotes**
