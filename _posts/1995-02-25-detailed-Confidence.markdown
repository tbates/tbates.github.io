---
layout: post
title: "Get more confidence (intervals), easily!"

comments: true
categories: advanced
---


#### This page is not finished. When done it will explain using umx to get CIs from models. 

CIs –&nbsp;or profile-based confidence intervals are key to understanding how big the likely true effects of your causes are.

First, run our first model again:

```r
m1 = umxRAM("cars", data =  mtcars, type = "cov",
	umxPath(c("disp", "gear"), to = "mpg"),
	umxPath("disp", with = "gear"),
	umxPath(var = c("disp", "gear", "mpg"))
)
```

Here's the one line to get CIs

```r
umxConfint(m1, parm= "all", run=TRUE)
                 lbound  estimate    ubound lbound Code ubound Code
disp_to_mpg      -0.052    -0.041    -0.030           0           0
gear_to_mpg      -1.750     0.111     1.973           0           0
mpg_with_mpg      6.298     9.907    16.890           0           0
disp_with_disp 9459.638 14876.544 25369.879           0           0
disp_with_gear  -98.406   -49.202   -20.861           0           0
gear_with_gear       NA     0.527     0.866          NA           0

```


PS: OpenMx has a confint method (this used to be how to access umx's confint methods). It returns SE-based bounds

```r
confint(m1, run = TRUE) # lots more to learn about ?confint.MxModel

Wald type confidence intervals (see ?mxCI for likelihood-based CIs)
                        2.5%         97.5%
disp_to_mpg      -0.05159987    -0.0300958
gear_to_mpg      -1.69503585     1.9174272
mpg_with_mpg      5.05248336    14.7614100
disp_with_disp 7589.36713111 22163.7204380
disp_with_gear  -84.29849884   -14.1062932
gear_with_gear    0.26895182     0.7856374

```

## More about ?umxConfint.MxModel

### parm
the `parm` parameter defaults to "existing": Show existing confidence intervals (and create all if none exist).
The alternative is to give a vector of names.

### level = 0.95
The default confidence interval is 95%. You can ask for others, for instance .99

```r
umxConfint(m1, run = TRUE, level = .99) 
```

### run = FALSE
By default umxConfint doesn't run the model (that's because CIs can be computationally intensive). Might change in future.

```r
umxConfint(m1, run = FALSE) 
```

###  showErrorcodes = FALSE,

By default, we don't show the errorcodes. Turn this on to see them (if any)

```r
umxConfint(m1, run = TRUE, showErrorcodes = TRUE) 
```

That's it!