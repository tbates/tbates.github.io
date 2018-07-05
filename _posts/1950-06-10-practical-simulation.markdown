---
layout: post
title: "Simulation"

comments: true
categories: technical
---

<a name="top"></a>

# Simulation

Often having simulated data can help explore an idea, or test an idea.

This post covers

1. Using `mxGenerateData` to create data by specifying the path model that fits it.
2. Making twin data using `umx_make_TwinData`
3. Making  data for [Mendelian Randomization](https://en.wikipedia.org/wiki/Mendelian_randomization) using `umx_make_MR_data`

### 1. Making data by specifying the model it comes from

You can also use the `mxGenerateData` function to build a model which captures your data, and then generate data from that model!

Make a model

```r
m1 <- umxRAM("simData", data = letters[1:3],
	umxPath(means = letters[1:3], values= 0),
	umxPath(var   = letters[1:3], values= 1),
	umxPath("a", with= "b", values= .4),
	umxPath("a", with= "c", values= .3),
	umxPath("b", with= "c", values= .4)
)
```

If you just want a dataframe back:

```r
simData = mxGenerateData(m1, nrows=1000)
umxAPA(m2) # have a look at it.
```


|          |a           |b           |c            |
|:---------|:-----------|:-----------|:------------|
|a         |1 (0)       |            |             |
|b         |0.27 (0.03) |1 (0)       |             |
|c         |0.26 (0.03) |0.41 (0.03) |1 (0)        |
|Mean (SD) |0.02 (1)    |-0.03 (1)   |-0.03 (0.99) |


You can implant that dataframe into a new model

```r
m1$expectation$data =mxData(simData)
```

Or just ask `mxGenerateData` to do that for you:

```r
m2 = mxGenerateData(m1, nrows = 1000, returnModel = TRUE)
```

Neat huh! The help on `?mxGenerateData` is nice too!

### 2. Making Twin Data

`umx` offers `umx_make_TwinData`

This is a great way to create data for twin models, where you want

1. An MZ dataset and a DZ dataset
2. You know the Mzr and DZr or the A, C, and E values you want to simulate.

You can also add a moderator (dragging A across a range according to a moderator)

It's this easy:

```splus    
tmp = umx_make_TwinData(nMZpairs = 10000, AA = .30, CC = .00, EE = .70)
 AA  CC  EE 
0.3 0.0 0.7 
   a    c    e 
0.55 0.00 0.84 
```
The results come back as a list of 2 data sets: One for MZ and one for DZ.

#### How to consume the built datasets

```splus
mzData = tmp[[1]];
dzData = tmp[[2]];
cov(mzData); cov(dzData)
umxAPA(mzData)
str(mzData); str(dzData);     
```

|          |var_T1      |var_T2 |
|:---------|:-----------|:------|
|var_T1    |1           |       |
|var_T2    |0.31        |1      |
|Mean (SD) |0.01 (0.99) |0 (1)  |


####  Prefer to work in path coefficient values? (little a?)

```splus    
tmp = umx_make_TwinData(200, AA = .6^2, CC = .2^2)
```
You can omit `nDZpairs` (Defaults to MZ numbers)

Variance doesn't need to sum to 1:

```splus
tmp = umx_make_TwinData(100, AA = 3, CC = 2, EE = 3, sum2one = FALSE) 
cov(tmp[[1]])

```    

#### Moderator Example

```splus
    
x = umx_make_TwinData(100, AA = c(avg = .7, min = 0, max = 1), CC = .55, EE = .63)
str(x)
```
You can also make Thresholded data, just use MZr and DZr,, or create data for Bivariate GxSES  (see umxGxEbiv)


### 3. Making Mendelian Randomization Data

`umx_make_MR_data`allows you to simulate data based on Mendelian Randomization.

You get back a 4-variable data set: 

1. The outcome variable of interest (Y)
2. The putative causal variable (X)
3. A qtl (quantitative trait locus) influencing X
4. A confounding variable (U) affecting both X and Y.

Here's a simple example:
  
```r
df = umx_make_MR_data(nSubjects = 1000, Vqtl = 0.02, bXY = 0.1, bUX = 0.5, bUY = 0.5, pQTL = 0.5, seed = 123)
```

Which looks like this:

```r
umxAPA(df)
```

|          |X           |Y           |U           |qtl     |
|:---------|:-----------|:-----------|:-----------|:-------|
|X         |1 (0)       |            |            |        |
|Y         |0.39 (0.03) |1 (0)       |            |        |
|U         |0.54 (0.02) |0.54 (0.02) |1 (0)       |        |
|qtl       |0.18 (0.03) |0.04 (0.03) |0.02 (0.03) |1 (0)   |
|Mean (SD) |0 (1.02)    |0.01 (1)    |0.01 (1)    |1 (0.7) |

```r
umx_print(head(df))
```

|          X|          Y|          U| qtl|
|----------:|----------:|----------:|---:|
| -1.0023978| -0.9650462| -0.6018928|   1|
| -0.9593700| -0.1157263| -0.9936986|   0|
| -0.2573603| -0.0975572|  1.0267851|   1|
|  0.7112984|  0.0031000|  0.7510613|   0|
|  0.0026485| -0.1110663| -1.5091665|   0|
|  1.7699183| -0.2656627| -0.0951475|   1|
