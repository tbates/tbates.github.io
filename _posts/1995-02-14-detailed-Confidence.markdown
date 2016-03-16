---
layout: post
title: "Get more confidence (intervals), easily!"
date: 1995-02-14 00:00
comments: true
categories: advanced
---

# Confidence in 1 line:

#### This page is not finished. When done it will explain using umx to get CIs from models. 

CIs –&nbsp;or confidence intervals are key to understanding how big the likely true effects of your causes are.

First, run our very first model again:

``` splus
manifests = c("mpg", "disp", "gear")
m1 <- mxModel("car", type = "RAM",
	manifestVars = manifests,	
	mxPath(from = c("disp", "gear"), to = "mpg"),
	mxPath(from = "disp", to = "gear", arrows = 2),
	mxPath(from = "disp", arrows = 2, free = F, values = var(mtcars$disp)),
	mxPath(from = "gear", arrows = 2, free = F, values = var(mtcars$gear)),
	mxPath(from = "mpg", arrows = 2),
	mxData(cov(mtcars[,manifests]), type = "cov", numObs = nrow(mtcars))
)
```

Here's the one line to get CIs

``` splus
confint(m1, run = TRUE) # lots more to learn about ?confint.MxModel
```

| Path           | lbound  | estimate | ubound  | lbound | Code |
|---------------:|--------:|---------:|--------:|-------:|-----:|
| disp_to_mpg    | -0.052  | -0.041   | -0.030  | 1      | 1    |
| gear_to_mpg    | -1.816  | 0.111    | 2.038   | 1      | 1    |
| mpg_with_mpg   | 6.397   | 10.226   | 18.494  | 1      | 1    |
| disp_with_gear | -66.415 | -50.803  | -17.977 | 1      | 1    |

## More about ?confint.MxModel

### parm
the `parm` parameter defaults to "existing": Show existing confidence intervals (and create all if none exist).
The alternative is to give a vector of names, like

### level = 0.95
The default confidence interval is 95%. You can ask for others, for instance .99

``` splus
confint(m1, run = TRUE, level = .99) 
```

### run = FALSE
By default this function doesn't run the model. That's because CIs can be computationally intensive.

``` splus
confint(m1, run = FALSE) 
```

###  showErrorcodes = FALSE,

By default, we don't show the errorcodes. Turn this on to see them (if any)

``` splus
confint(m1, run = TRUE, showErrorcodes = TRUE) 
```

That's it!