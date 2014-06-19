---
layout: post
title: "Matrix concepts: Not positive definite, Hessian, Jacobian"
date: 1900-06-01 00:00
comments: true
categories: models
---

### What is the Hessian?

* The Hessian is the matrix of second partial derivatives of the fit function with respect to the parameters, and is the inverse of the covariance matrix of the parameters.

### What is the Jacobian?


```splus
    
 # list up manifests and latents
 manifests = c(nfc_items)
 latents = c("NFC")

 m2 <- mxModel("NFCIQ", type = "RAM",
 	latentVars   = latents,
 	manifestVars = manifests,
 	umxLatent(Latent, formedBy = manifestlist, data=data, endogenous=T, manifestVariance = 1)
     umxLatent(latent = NULL, formedBy = NULL, forms = NULL, data = NULL, type = NULL)
	  
 	mxPath(from = manifests, arrows = 2),
 	# create NFC as a latent, loading on each NfC item
 	mxPath(from = "NFC", to = nfc_items),
 	mxPath(from = facets, to = "NFC"),
 	# Let all the facets intercorrelate
 	mxPath(from = facets, connect = "unique.bivariate", arrows = 2, free = T),
 	mxData(cov(nfc[,manifests], use = "pair"), type = "cov", numObs = nrow(nfc))
 )
 m2 = umxRun(m2, setValues = T, setLabels = T);
 umxSummary(m2, show="std")


 m2 = mxModel("formative", type = "RAM",
     manifestVars = manifests,
     latentVars   = latents,
     # Factor loadings
     umxLatent("G", formedBy = manifests, data = theData),
 	mxData(theData, type = "cov", numObs = nrow(demoOneFactor))
 )
 m2 = umxRun(m2, setValues = T, setLabels = T); umxSummary(m2, show="std")
 umxPlot(m2)
     
``` 
