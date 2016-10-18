---
layout: post
title: "Twin ACE Cholesky with umxACE"

comments: true
categories: models twin
---

The Multivariate ACE Cholesky is a core construct in behavior genetics (Neale & Maes, 1996), and umx supports this via umxACE.

The ACE model decomposes phenotypic variance into Additive genetic (A), unique environmental (E) and, optionally, either common or shared-environment (C) or non-additive genetic effects (D). This latter restriction emerges due to a lack of degrees of freedom to simultaneously model C and D given only MZ and DZ twin pairs. 

The Cholesky or lower-triangle decomposition allows a model that is both sure to be solvable, and also to account for all the variance (with some restrictions) in the data. This model creates as many latent A C and E variables as there are phenotypes, and, moving from left to right, decomposes the variance in each component into successively restricted factors (see Figure below).

<table border="0" cellspacing="5" cellpadding="5">
	<tr><th>Diagram</th><th>Matrix</th></tr>
	<tr> <td width="50%"> <img src="/media/umxTwin/ACE.png" width="330" height="337" alt="ACE"></td>
		<td>3 &times; 3 matrix-form of the Cholesky paths, with labels as applied by umxLabel.
			<table border="1">
				<tr><td></td>     <td>A1</td>    <td>A2</td>    <td>A3</td>    </tr>
				<tr><td>Var 1</td><td>a_r1c1</td><td></td>      <td></td>      </tr>
				<tr><td>Var 2</td><td>a_r2c1</td><td>a_r2c2</td><td></td>      </tr>
				<tr><td>Var 3</td><td>a_r3c1</td><td>a_r3c2</td><td>a_r3c3</td></tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan = "0">
			Multivariate ACE Cholesky model, showing the additive genetic component only (C and E take identical forms) and for one-twin only (each model in umxACE describes the A, C (or D), and E paths, constrained appropriately across the two-members of the pair, dependent on their zygosity. 
		</td>
	</tr>
</table>

### Data Input
The umxACE function flexibly accepts both raw data and summary covariance data (in which case the user must also supply numbers of observations for the data sets). In an important capability, the model transparently handles ordinal (binary or multi-level ordered factor data) inputs, and can handle mixtures of continuous, binary, and ordinal data in any combination. An experimental feature is under development to allow Tobit modeling.

*umxACE* also supports weighting of individual data rows. In this case, the model is estimated for each row individually, then each row’s likelihood is multiplied by its weight, and these weighted likelihoods summed to form the model likelihood, which is to be minimized. This feature is currently used in non-linear GxE model functions. In addition, umxACE supports varying the DZ genetic association (defaulting to .5) to allow exploring assortative mating effects, as well as varying the DZ "C" factor from 1 (the default for modeling family-level effects shared 100% by twins in a pair), to .25 to model dominance effects.

When it comes to interpretation and graphing, models built by umxACE() are able to be plotted and summarized using plot() and umxSummary() methods. umxSummary can report summary A, C, and E multivariate path-coefficients, along with model fit indices, and genetic correlations. The built-in plot() method is extended by umx to handle graphical reporting of ACE models, laying out models as seen in Figure 2.
ACE Examples

We first set up data for a summary-data ACE analysis of weight data (using a built-in example dataset from Nick Martin’s Australian twin sample:


```r    
require(umx); data(twinData)
selDVs = c("wt1", "wt2")
# Not working until a new version of OpenMx releases the updated dataset…
tmpTwin = twinData[twinData$cohort == "younger"]
dz = tmpTwin[tmpTwin$zyg == "DZFF", selDVs]
mz = tmpTwin[tmpTwin$zyg == "MZFF", selDVs]

# current version:
tmpTwin <- twinData
labList = c("MZFF", "MZMM", "DZFF", "DZMM", "DZOS")
tmpTwin$zyg = factor(tmpTwin$zyg, levels = 1:5, labels = labList)
selDVs = c("wt1", "wt2")
dz = tmpTwin[tmpTwin$zyg == "DZFF", selDVs]
mz = tmpTwin[tmpTwin$zyg == "MZFF", selDVs]
```

The next line shows how umxACE allows the user to easily build an ACE model with a single function call. umx will give some feedback, noting that the variables are continuous and that the data have been treated as raw. We could conduct this same modeling using only covariance data, offering up suitable covariance matrices to mzData and dzData, and entering the number of subjects in each via numObsDZ and numObsMZ.

```r
m1 = umxACE(selDVs = selDVs, dzData = dz, mzData = mz)
```
        
This model can be run:

```r
m1 = mxRun(m1) # Run the model
```
and then plotted:

```r
plot(m1) # output shown in below
```

<img src="/media/umxTwin/weight_ACE_plot.png" width="330" height="337" alt="ACE_uni_plot">


Or summarized in table and graphical form:

```r
umxSummary(m1) # Create a tabular summary of the model
-2 × log(Likelihood) = 12186.28 (df = 4)
```

|    |    a1|c1 |    e1|
|:---|-----:|:--|-----:|
|wt1 | -0.92|.  | -0.39|
[Standardized solution]

By default the report table is written to the console in markdown-format. By setting report = "html", the user can request a rendered html be opened in the default browser. Whether the parameter table is standardized or not is set using the `showStd = TRUE` parameter (the default). The user can request the genetic correlations with `showRg = TRUE` (the default is FALSE). If Confidence intervals have been computed, these can be displayed with `CIs = TRUE`.

The user can control the precision of output with the digits = parameter. The umxSummary function can also call the plot in line (`file = "name"`). More advanced features include that the function can also return the standardized model (`returnStd = TRUE`). A model fit comparison can also be requested by offering up the comparison model in comparison = model.

The help (`?umxACE`) for umxACE gives extensive examples, including binary, ordinal, and joint data setup and analysis.
