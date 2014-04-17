---
layout: post
title: "Overview of umx functions: Quickly survey all the umx helpers available to you"
date: 1900-02-01 00:00
comments: true
categories: models
---

umx allows you to more easily build, run, modify, and report models using OpenMx
with code. The core functions are linked below:

All the functions have explanatory examples, so use the help, even if you think it won't help :-)
Have a look, for example at `?umxRun`

The functions are grouped into "families". These families are collated in the help for each function.

The core family is helpers for [OpenMx](http://openmx.psyc.virginia.edu) that take care of repetitive tasks like labeling and start values, and which streamline the work flow of model comparison and graphing, while not sacrificing power.

Here are some of the most important.

1. Building Models
	* `umxStart()` *# Add likely start values to a model: **very** helpful*
	* `umxLabel()` *# Add labels to paths: Labels allow you to set, equate, and drop paths by label!*
	* `umxLatent()` *# Helper for building formative and reflective latent variables from their manifest indicators*
2. Run models
	* `umxRun()` *# Use in place of mxRun to: set labels, starts, compute saturated for raw data, run model until it returns green*
	* `umxReRun()` *# Modify a model (drop paths etc), run, and even return the comparison all in 1 line*
3. Reporting output
	* `umxSummary(model)` # *Get a brief summary of model fit, similar to a journal report (Χ², p, CFI, TLI, & RMSEA)*
	* `umxPlot(fit1, std=T, precision=3, dotFilename="name")` # *Create a graphical representation of a RAM model (outputs a [GraphViz](http://www.graphviz.org/Gallery.php) file)*
	* `umxSaturated(model)` *# Create a saturated model when raw data are being used. *
		* `summary(model, SaturatedLikelihood = model_sat$Sat, IndependenceLikelihood = model_sat$Ind)`
		* **nb**:* Saturated solutions are not computable for definition variables and some other models.
3. Modify models
	* `umxMI()` # Report the top n modification indices
	* `umxAdd1()` # add parameters and return a table of the effect on fit
	* `umxDrop1()` # Drop parameters and return a table of the effect on fit
	* `umxGetParameters(model, regex = "as_r_2c_[0-9]", free = T)` *# A powerful assistant to get labels from a model. like `omxGetParameters` but uses regular expressions.*
	* `umxReRun()` *# re-run a model: Quickly drop or free parameters, rename the model, and re-run...*
4. Data and package helpers
	* `umxHetcor(data, use = "pairwise.complete.obs")` *# Compute appropriate pair-wise correlations for mixed data types.*
	* `lower2full(lower.no.diag, diag=F, byrow=F)`  *# Create a full matrix from a lower matrix of data*
4. Miscellaneous
	* `umxTime(fit1)`  *# Report the time taken by a model in a compact friendly, programable format*