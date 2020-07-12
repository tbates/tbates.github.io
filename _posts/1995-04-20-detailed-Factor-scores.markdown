---
layout: post
title: "Factor scores with missing data!"

comments: true
categories: advanced
---

It is often useful to obtain scores for subjects on the latent variables in a model.

A familiar method is `scores` from `fact.anal`. This has several limits: It&rsquo;s limited to 
factor models and can&rsquo;t handle missing data. This tutorial covers both cases briefly, begining with `umxEFA`.

#### Factor scores from factor analysis

`umx` provides `umxEFA` to conduct exploratory factor analysis, and this supports returning scores for subjects.
Unlike `fact.anal` which doesn&rsquo;t allow missing data, umxEFA support scores even in data with missing cells.

Here&rsquo;s a quick 2-factor model of some variables in the built-in `mtcars` data set:

```r
myVars = c("mpg", "disp", "hp", "wt", "qsec")
x = umxEFA(mtcars[, myVars], factors =   2, rotation = "promax", scores= "Regression")
x
```

| row | F1          | F2          |
|:----|:------------|:------------|
| 1   | -0.50791846 | -0.18514471 |
| 2   | -0.33064492 |  0.06552157 |
| 3   | -0.94419567 |  0.50718985 |
| 4   | -0.15293406 |  0.65402567 |
| 5   |  0.34436572 | -0.60262537 |
| 6   |  0.00162507 |  0.96319721 |
| 7   |  0.66518005 | -1.47386057 |
| 8   | -0.35350661 |  1.42364717 |
 

```r
require(umx)
data(demoOneFactor)

manifests = names(demoOneFactor)
m1 = umxRAM("OneFactor", data = demoOneFactor, type = "cov",
	umxPath("G", to = manifests),
	umxPath(var = manifests),
	umxPath(var = "G", fixedAt = 1)
)

```
	
### Add raw data and compute factor scores

```r

# Swap in raw data in place of summary data
m2 = mxModel(m1, mxData(demoOneFactor, type = "raw"))

# Estimate factor scores for the model
fs = mxFactorScores(m2, 'Regression')

```

### Create some missing data and compute factor scores

All the data-points of demoOneFactor are present:

```r
all(complete.cases(demoOneFactor))
# [1] TRUE
```

Let’s delete 10% from each column at random:

```r
df = demoOneFactor
n = dim(df)[1];
for (i in dim(df)[2]) {
	df[sample(n, .1 * n), i] = NA
}
all(complete.cases(df))
```

Run again with the missing data:

```r

m2 <- mxModel(m1, mxData(df, type = "raw"))
# Estimate factor scores for the model
fs = mxFactorScores(m2, 'Regression')

```

Just saved yourself $1000 buying Mplus for factor scores with missing data!