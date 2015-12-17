---
layout: post
title: "Overview of umx functions: Quickly survey the key umx helpers available to you (plus some minor players)"
date: 1900-02-01 00:00
comments: true
categories: advancedRAM
---

umx allows you to more easily build, run, modify, and report models using OpenMx
with code. The core functions are linked below:

All the functions have explanatory examples, so use the help, even if you think it won't help :-)
Have a look, for example at `?umxRun`

The functions are grouped into "families". These families are collated in the help for each function.

Here are some of the most important.

1. Built-in Models
	* `umxACE()` *# Twin ACE model, all paths labeled*
		* The umx.twin library has several others:  `umxGxE()`, `umxCP()`, `umxIP()`
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
	* Miscellaneous
		* `umx_time(model)`  *# Report the time taken by a model in a compact friendly, programable format*
		* summaryAPA
		* umx_APA_pval
		* umx_aggregate
		* umx_print
		* umx_show
5. Modify models
	* `umxMI` # Report the top n modification indices
	* `umxAdd1` # add parameters and return a table of the effect on fit
	* `umxDrop1` # Drop parameters and return a table of the effect on fit
	* `parameters(model` *# A powerful assistant to get labels from a model. like `omxGetParameters` but uses regular expressions.*
		* ?umxGetParameters to learn more options, like regex filters
	* `umxReRun` *# re-run a model: Quickly drop or free parameters, rename the model, and re-run...*
6. Miscellaneous Functions
	* `umxHetcor(data, use = "pairwise.complete.obs")` *# Compute appropriate pair-wise correlations for mixed data types.*
	* `lower2full(lower.no.diag, diag=F, byrow=F)`  *# Create a full matrix from a lower matrix of data*
	* umx_APA_pval
	* umx_add_variances
	* umx_apply
	* umx_check_model
	* umx_check_multi_core
	* umx_check_OS
	* umx_checkpoint, umx_set_checkpoint
	* umx_check
	* umx_default_option
	* umx_explode
	* umx_get_CI_as_APA_string
	* umx_get_bracket_addresses
	* umx_get_checkpoint
	* umx_get_cores
	* umx_get_optimizer
	* umx_has_CIs
	* umx_has_been_run
	* umx_has_means
	* umx_has_square_brackets
	* umx_is_MxMatrix
	* umx_is_MxModel
	* umx_is_RAM
	* umx_is_cov
	* umx_is_endogenous
	* umx_is_exogenous
	* umx_is_ordered
	* umx_msg
	* umx_names
	* umx_object_as_str
	* umx_paste_names
	* umx_print
	* umx_rename
	* umx_reorder
	* umx_rot
	* umx_set_cores
	* umx_set_optimizer
	* umx_string_to_algebra
	* umx_trim
7. Miscellaneous Data Functions
	* umxHetCor
	* umxPadAndPruneForDefVars
	* umx_as_numeric
	* umx_cont_2_ordinal
	* umx_cov2raw
	* umx_lower2full
	* umx_make_bin_cont_pair_data
	* umx_merge_CIs
	* umx_read_lower
	* umx_residualize
	* umx_round
	* umx_scale_wide_twin_data
	* umx_scale
	* umx_swap_a_block
