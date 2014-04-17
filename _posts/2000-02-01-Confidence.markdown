---
layout: post
title: "Get some Confidence!"
date: 2000-02-01 00:00
comments: true
categories: models tutorial
---

# Get some Confidence!

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

confint(m1, run = TRUE) # lots more to learn about ?confint.MxModel
```

| Path           | lbound  | estimate | ubound  | lbound | Code |
|---------------:|--------:|---------:|--------:|-------:|-----:|
| disp_to_mpg    | -0.052  | -0.041   | -0.030  | 1      | 1    |
| gear_to_mpg    | -1.816  | 0.111    | 2.038   | 1      | 1    |
| mpg_with_mpg   | 6.397   | 10.226   | 18.494  | 1      | 1    |
| disp_with_gear | -66.415 | -50.803  | -17.977 | 1      | 1    |



**Footnotes**
[^1]: 