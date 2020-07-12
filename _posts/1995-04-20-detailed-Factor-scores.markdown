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
Unlike `fact.anal` which doesn&rsquo;t allow missing data, `umxEFA` support scores even in data with missing cells.

Like `fact.anal`, to get scores from `umxEFA` you simply set `scores = "Regression"`. `umxEFA` supports alternative methods for computing them.

Here&rsquo;s a quick 2-factor model of some variables in the built-in `mtcars` data set:

```r
myVars = c("mpg", "disp", "hp", "wt", "qsec")
x = umxEFA(mtcars[, myVars], factors =   2, rotation = "promax", scores= "Regression")
x
```

| row | F1          | F2          |
|:----|------------:|------------:|
| 1   | -0.50791846 | -0.18514471 |
| 2   | -0.33064492 |  0.06552157 |
| 3   | -0.94419567 |  0.50718985 |
| 4   | -0.15293406 |  0.65402567 |
| 5   |  0.34436572 | -0.60262537 |
| 6   |  0.00162507 |  0.96319721 |
| 7   |  0.66518005 | -1.47386057 |
| ... | ...         |  ...        |
 

#### Factor scores from arbitrary RAM models.

```r
require(umx)
data(demoOneFactor)

manifests = names(demoOneFactor)
m1 = umxRAM("OneFactor", data = demoOneFactor,
	umxPath("G", to = manifests),
	umxPath(v.m. = manifests),
	umxPath(v1m0 = "G")
)
```
	
We can compute factor scores thus:

```r
fs = umxFactorScores(m1, 'Regression')
```
| row | G     |
|:----|------:|
| 1   | -0.17 |
| 2   | -0.11 |
| 3   | -2.14 |
| 4   | -0.16 |
| 5   |  1.11 |
| 6   |  0.11 |
| 7   | -0.02 |
| 8   |  0.93 |

### Create some missing data and compute factor scores

All the data-points of demoOneFactor are present. Let&rsquo;s delete 10% from each column at random:

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
# 1. update model with new data
m2 = mxModel(m1, mxData(df, type = "raw"))
# 2. score factors
fs = umxFactorScores(m2, 'Regression')
umx_round(fs, digits=3)
```

| row | G      |
|----:|-------:|
| 1   | -0.167 |
| 2   | -0.106 |
| 3   | -2.137 |
| 4   | -0.157 |
| 5   |  1.106 |
| 6   |  0.110 |


Just saved yourself $1000 buying Mplus for factor scores with missing data!