---
layout: post
title: "Simulation & power"

comments: true
categories: technical
---

<a name="top"></a>

ignore this post: not finished as we consider the final interface for `umxPower`

# Power analysis

Power is the probability of detecting an effect when it is present. Knowing the power of a study is important: Weak studies spew out 5% false positives (i.e., at the rate alpha), but without power, they fail to detect true results at rate beta. Power is 1-beta.

This post covers:

1. Computing power to detect a difference between 2 models.
2. Computing power given a certain n.

As of 2019-08-01, `umx` supports power calculations for the `umxACE` model.

### 1. What is the power to detect One Factor.A[1,6] is different from zero given N=1000, and alpha=.05?

```R
df = mtcars
df$engine_litres = .016 * df$disp

m1 = umxRAM(data = df, "#mpg_model
	mpg ~ engine_litres + wt
	wt ~~ engine_litres"
)

m2 = umxModify(m1, "engine_litres_to_mpg")
mxPowerSearch(trueModel= m1, falseModel= m2)

```

```r
# solve for N
umxPower(trueModel=,update= "engine_litres_to_mpg",sig.level=.05,power=.8, method= c("empirical", "ncp"))
# umxPower(trueModel=,update= ,n=,sig.level=.05,power=.8, method= c("empirical", "ncp"))

```

### 2. What is the power to detect One Factor.A[1,6] is different from zero given N=1000, and alpha=.05?

This next snippet, however, is asking:
    “At n= 1000, what is the smallest difference (in either direction?) from the value it is fixed at, which I would have power = 0.8 to detect a difference in fit between falseModel (in which a certain parameter is fixed at a value we consider null or wrong) and trueModel (in which the parameter is free)”?

It works just like umxModify

```r
umxPower(model = m1, update = "One Factor.A[1,6]", values = .3, n = 1000)
```

*note*: In OpenMx, you can say:

```r
 mxPower(trueModel= m1, falseModel= m2, n = 1000)
```
