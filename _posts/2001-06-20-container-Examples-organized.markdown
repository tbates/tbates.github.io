---
layout: post
title: "Gallery of Example Models!"

comments: true
categories: basic
---

<style type="text/css">
	ul {
	  -webkit-columns: 3 150px;
	  -moz-columns: 3 150px;
	  columns: 3 150px;
	  -webkit-column-gap: 2em;
	  -moz-column-gap: 2em;
	  column-gap: 2em;
	}
</style>


<a  name="top"></a>

<p style="text-align: center;">This is a gallery of example models. To learn about installing umx, or take a basic tutorial, start at the home page.</p>


*note*: This page expresses the goal for umx's coverage of core copy-and-paste model templates. Goal deadline to have it completed by end 2019.

### Basic path-based models in `umx`
* [umxPath](/advanced/1995/11/20/detailed-umxPath.html)
* Making [Cholesky-style path connections](/models/twin/1980/06/15/twin-Cholesky.html) with `umxPath`

### Exploratory and Confirmatory Factor Analysis
* Factor analysis with `umxFactanal`
* Factor scores with `umxFactanal`
* Confirmatory Factor Analysis with one or more factors
* CFA with ordinal data
* Joint ordinal/continuous factor analysis

### SEM, indirect effects, mediation analysis
* Regression with structural equation models
* Ordinal regression
* Mediation
* Moderation

### Measurement models and Psychometrics
<!-- * Item response theory -->
<!-- * Item factor analysis -->
* Measurement invariance
<!-- * Differential item functioning -->
<!-- * Test equating -->

### Multiple groups
* [Multiple group analysis](/advanced/1995/02/15/detailed-Multigroup.html)
* `[umxSuperGroup](/advanced/1995/02/15/detailed-Multigroup.html)`

### Growth and change
* [Growth model](https://tbates.github.io/models/1970/08/13/models-growth_curve.html)
<!-- * Latent growth model -->
<!-- * Latent growth mixture model -->
<!-- * Regime switching model -->
<!-- * Independent mixture model -->
<!-- * Growth Mixture model -->
<!-- * Factor mixture model -->
<!-- * Dynamical systems analysis -->
<!-- * Latent differential equations -->

<!--
### Multilevel SEM
* Multilevel regression models
* Multilevel factor models
* Multilevel structural equation models
* Multilevel mediation models Moderation
* Mediated moderation models
* Product of latent variables

### Latent classes
* Latent class analysis
* Latent profile analysis
* Latent transition analysis
* Latent factor regression
* State space models
* Single-subject models
* Multi-subject models
* Hidden Markov models
* Network models
-->

### Modeling different types of Data correctly
* Raw data
* Weighted least squares
* Polychoric correlations
* Continuous variables
* Ordinal variables
* Joint ordinal & continuous variables

### Modeling predictors, effects, definition variables, weights, missingness correctly
* Extracting means, covariances, and thresholds
* Definition variables
<!-- * Fixed & random effects -->
* Sample weights
<!-- * Missing data -->
<!-- * Missing at random -->
<!-- * Non-ignorable missingness -->
* Censoring

### How do I simulate data, or do a power analysis?
* Power analysis
* Simulations
* [Meta analysis](https://cran.r-project.org/web/packages/metaSEM/vignettes/Examples.html)

### Wrangling data: scaling, renaming, residualizing etc.
* [Scaling Data]()
* [Wrangling Data]()
* [Renaming Data]()
* [Residualizing Data]()
* [Wide 2 long and long 2 wide]()


### Twin Models
* [ACE](/models/twin/1980/06/10/twin-umxACE.html) / [ADE](/models/twin/1980/06/10/twin-umxACE.html) 
* ACEv
* Common pathway umxCP
* Independent pathway umxIP
* Sex limitation
* GxE interaction
* Simplex
<!-- * Direction of causation -->
<!-- * Two-stage Twin family models -->
<!-- * Assortative mating models -->
<!-- * Niche selection -->
<!-- * Extended pedigree models -->

<!-- ### GREML and genomic SEM -->
<!-- * Molecular genetic variance component analysis -->
<!-- * Genomic Relatedness Matrix -->
<!-- * Restricted Maximum Likelihood -->
<!-- * Genetic Association analysis -->
<!-- * More advanced powers -->

### Optimizers
* Full Information Maximum Likelihood
* Weighted least squares

### Parameter estimates and fit statistics
* Goodness-of-fit
<!-- * Getting chi-squared statistics with mxRefModels -->
* Using mxSE to get standard errors of functions of free parameters
* Using umxCI for profile likelihood confidence intervals
<!-- * Robust Standard Errors -->
* Factor Scores
<!-- * Jack-knifing -->
<!-- * Cross-validation -->
* Modification indices with umxMI
* Bootstrap Likelihood ratio tests

### How do I add covariates, different intervals for growth...
* Age
<!-- * Variable ages or assessment intervals for all participants -->
<!-- * Data harmonization -->

### How to pick starting values
 * Let umx do it
 * Make an educated guess
 * Use mxAutoStart

### How to modify Graphical output
  * How do I plot results?


#### Posts tagged as example models

<ul>
  {% for post in site.categories.models %}
	{% if post.url %}
  <li><a href="{{ post.url }}">{{ post.title }}</a></li>
	{% endif %}
  {% endfor %}
</ul>
