---
layout: post
title: "Overview of umx functions: Quickly survey all the umx helpers available to you"
date: 1900-02-01 00:00
comments: true
categories: models
---

#### This page is not finished. When done it will list up the core umx functions
#### This is just a stub beginning!

umx allows you to more easily build, run, modify, and report models using OpenMx
with code. The core functions are linked below:

All the functions have explanatory examples, so use the help, even if you think it won't help :-)
Have a look, for example at `?umxRun`

The functions are grouped into "families". These families are collated in the help for each function.

The core family is helpers for [OpenMx](http://openmx.psyc.virginia.edu) that take care of repetitive tasks like labeling and start values, and which streamline the work flow of model comparison and graphing, while not sacrificing power.

Here are some of the most important.

1. Built-in Models
	* `umxACE()` *# Twin ACE model, all paths labeled*
	* umx.twin has `umxCP()`, `umxIP()`
2. Building Models
 * `umxRAM()` *# high-level model builder*
 * `umxpath()` *# high-level path builder*
 * Lower-level builders
  * `umxStart()` *# Add likely start values to a model: **very** helpful*
  * `umxLabel()` *# Add labels to paths: Labels allow you to set, equate, and drop paths by label!*
3. Run models
	* `umxRun()` *# Use in place of mxRun to: set labels, starts, compute saturated for raw data, run model until it returns green*
	* `umxReRun()` *# Modify a model (drop paths etc), run, and even return the comparison all in 1 line*
4. Reporting output
	* `umxSummary(model)` # *Get a brief summary of model fit, similar to a journal report (Χ², p, CFI, TLI, & RMSEA)*
	* plot() # *Create a graphical representation of a RAM model (outputs a [GraphViz](http://www.graphviz.org/Gallery.php) file)*
		`?umxPlot` to learn more options
5. Modify models
	* `umxMI()` # Report the top n modification indices
	* `umxAdd1()` # add parameters and return a table of the effect on fit
	* `umxDrop1()` # Drop parameters and return a table of the effect on fit
	* `parameters(model` *# A powerful assistant to get labels from a model. like `omxGetParameters` but uses regular expressions.*
		* ?umxGetParameters to learn more options, like regex filters
	* `umxReRun()` *# re-run a model: Quickly drop or free parameters, rename the model, and re-run...*
6. Data and package helpers
	* `umxHetcor(data, use = "pairwise.complete.obs")` *# Compute appropriate pair-wise correlations for mixed data types.*
	* `lower2full(lower.no.diag, diag=F, byrow=F)`  *# Create a full matrix from a lower matrix of data*
7. Miscellaneous
	* `umx_time(model)`  *# Report the time taken by a model in a compact friendly, programable format*
