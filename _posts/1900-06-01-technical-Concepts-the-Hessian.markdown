---
layout: post
title: "Matrix concepts: Not positive definite, Hessian, Jacobian"

comments: true
categories: technical
---

This is a stub article: email `maintainer("umx")` if you'd like it finished.

### What is the Hessian?

* The Hessian is the matrix of second partial derivatives of the fit function with respect to the parameters, and is the inverse of the covariance matrix of the parameters.

### What is the Jacobian?


```r
    
 # list up manifests and latents
 manifests = nfc_items

 m2 <- umxRAM("NFCIQ", data = mxData(cov(nfc[,manifests], use = "pair"), type = "cov", numObs = nrow(nfc),
 	umxPath(var = manifests),
 	umxPath(v1m0 = "NFC"),
 	# Create NFC as a latent, loading on each NfC item
 	umxPath("NFC", to = manifests),
 	umxPath(facets, to = "NFC"),
 	# Let all the facets intercorrelate
 	umxPath(unique.bivariate = letters[1:3])
 )
 umxSummary(m2, show="std")


 m2 = umxRAM("formative", data = mxData(theData, type = "cov", numObs = nrow(demoOneFactor),
   umxLatent("G", formedBy = manifests, data = theData)
 )
 umxSummary(m2, show="std")
 plot(m2)
     
``` 
