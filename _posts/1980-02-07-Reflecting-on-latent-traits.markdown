---
layout: post
title: "Latent traits unmeasured (Reflective and Formative) variables"
date: 1980-02-07 00:00
comments: true
categories: models
---

#### When finished, this page will explain using umx to make latent variables

Until now, to keep things simple as we learn, We have only had measured variables (boxes) on the diagram.

Of course, much of the power  (and struggle) with SEM comes from the ability to use latent traits. These are represented on the diagram as circles. Conceptually, they are constructs that our theory postulates exist and which explain the state of our measured variables.

So, just like physicists never directly see electrons (and this lead some positivists to deny the validity of atomic theory), so to we never see things like extraversion: We only see behaviors – like a person being the centre of attention at a party, and we attribute these to our un-seen causal construct, extraversion. This is a powerful value of latent trait modelling: we are building causal models to explain what we see, not merely describe it. Extraversion then needs to be broken down into causal components and mechanisms which explain the desire to go to a party, whether we like most people we meet etc.

A simple example of building a latent variable exists on the fron page of the OpenMx website.
Here it is:

```splus
require(umx)
data(demoOneFactor)
latents   = c("g")
manifests = names(demoOneFactor)
myData    = mxData(cov(demoOneFactor), type = "cov", numObs = 500)
m1 <- umxRAM("OneFactor", data = myData,
	umxPath(latents, to = manifests),
	umxPath(var = manifests),
	umxPath(var = latents, fixedAt = 1)
)
umxSummary(m1, showEstimates = "std")
plot(m1)
```

![g](/media/latents/OneFactor.png)