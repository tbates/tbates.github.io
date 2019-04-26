require(umx)
data(demoOneFactor)
manifests = c("x1", "x2", "x3", "x4", "x5")
m1 <- umxRAM("OneFactor", data = demoOneFactor,
	umxPath("g", to = manifests),
	umxPath(var = manifests),
	umxPath(var = "g", fixedAt = 1)
)
umxSummary(m1, showEstimates = "std")
umxFitIndices(m1, showEstimates = "std")
plot(m1)

https://openmx.ssri.psu.edu/thread/765#comment-6757
https://openmx.ssri.psu.edu/node/1301
https://openmx.ssri.psu.edu/thread/2204#comment-4780
https://openmx.ssri.psu.edu/thread/697


<h1 id="modelfit">Model Fit Wish list</h1>

<p>OpenMx, Mx and other software return multiple fit indices, but a large number exist. This  page is a wish-list of indices, how OpenMx or umx computes them.</p>

<p>✓ = returned by OpenMx Summary. ✓(umx) means available via the umx::umxFitIndices function.</p>

<ol>
	<li>✓ χ² non-significant?</li>
	<li>✓ RMSEA &lt; .05?</li>
	<li>✓ RMSEA 90% CI lower bound &lt; .01  and upper &lt; .10 ?</li>
	<li>✓ (umx) Is the SRMR &lt; .08 ?</li>
	<li>✓ CFI > .95 ?</li>
	<li>✓ TLI</li>
chi-square:  X2 ( df=0 ) = -0.03191109,  p = 1
Information Criteria: 
      |  df Penalty  |  Parameters Penalty  |  Sample-Size Adjusted
AIC:    -0.03191109               11.96809                       NA
BIC:    -0.03191109               20.76250                 2.057929
CFI: 1.000335 
TLI: 1   (also known as NNFI) 
RMSEA:  0  [95% CI (NA, NA)]
Prob(RMSEA <= 0.05): NA
	<li>✓ Parameter estimates make sense/are significant</li>
	<li>All correlation residuals &lt; .10 (can check via helper?)</li>
	<li>All standardized residuals &lt; 1.96 ? [less important in large samples]
		<ul>
			<li>These two are suspect with missing data (if the data are not missing completely at random) FIML estimates of covariances etc. may not match their sample counterparts and residuals could exceed arbitrarily set thresholds for deviation. In addition, item 1 with raw data may be costly to obtain because it requires fitting a model with as many parameters as there are means and covariances. Most studies have at least some missing data and discarding or imputing these increase risk of biased results compared to FIML. It may be worth the loss of certain measures of fit to use FIML.</li>
		</ul>
	</li>
	<li>Is p-close non-significant ? [tests the null hypothesis that RMSEA in the population is &lt; .05]</li>
	<li>Does the quantile plot of standardized residuals look OK (do the standardized residuals fall along a diagonal line)?
		<ul>
			<li>R has great graphical capabilities, and if the missing data caveat does not apply, it would be a one- or two-liner to generate the QQ plot.</li>
		</ul>
	</li>
	<li>Are indirect effects statistically significant? [test with bootstrap method]
		<ul>
			<li>likelihood-based confidence interval on the function of parameters of interest - this would be very easy to request and faster than bootstrap (though that can usually be done quite easily as well).</li>
		</ul>
	</li>
	<li>Do we have sufficient statistical power for the test of the close-fit hypothesis and the test of the not-close-fit hypothesis? [generate script with Preacher&#8217;s web site]</li>
	<li>Can we argue against equivalent and near-equivalent models?</li>
</ol>

<h1 id="modelcomparison">Model comparison</h1>

<p>OpenMx uses mxCompare() to compare models.</p>

<ol>
	<li>Significant difference in chi-square?</li>
	<li>✓ Model with lowest AIC</li>
	<li>✓ Model with lowest BIC</li>
	<li>Model with lowest DIC?</li>
</ol>