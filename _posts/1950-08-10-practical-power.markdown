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
2. Computing power given a certain `n`.

As of 2019-08-01, `umx` supports power calculations for the `umxACE` model.

## The basic problem

R has great support for power. For instance, testing power to detect a correlation of .3 in a sample of 36 subjects, R quickly tells us we're going to need some more subjects...

```R
pwr::pwr.r.test(n = 36, r = .3)
              n = 36
              r = 0.3
      sig.level = 0.05
          power = 0.4361314
    alternative = two.sided
```

Power for SEM is rather more complex as the models are arbitrary in the number of relations in the model. Many more questions can also be asked than, say for `pwr.t.test`. 

`umx`'s `umxPower` tackles this by using an interface very similar to `umxModify`. You offer up a true model, and paths that you want test.

```R
umxPower(trueModel = , update = , sig.level = .05, power = .8, method = c("empirical", "ncp"))
```

To emulate the `pwr.r.test` example, you would build a `trueModel` or generating model with this set of path estimates. This model doesn't need to have data. You can then request a `umxPower` test, specifying the path to set to zero as the null or `falseModel`. 


```R
m1 = umxRAM("predicted state of the world", data = c("x", "y"), autoRun = FALSE,
	umxPath(v.m. = c("x", "y")),
	umxPath("x", with = "y", , value=.3)
)
umxPower(trueModel = m1, update = "x_with_y", power = .8, method = "ncp")
```

### 1. What is the power to detect a path is different from zero given N=1000, and alpha=.05?

If someone publishes this simple model claiming that larger engines lower miles/gallon in vehicles, what power do we have to detect `engine_litres_to_mpg` is > 0 if we replicate with the same `n`, and assume that the obtained effect is the true one? 
 
First we build the claimed model:

```R
df = mtcars
df$engine_litres = .016 * df$disp

m1 = umxRAM(data = df, "#mpg_model
	mpg ~ engine_litres + wt
	wt ~~ engine_litres"
)

m2 = umxPower(m1, "engine_litres_to_mpg")

```

```r
# solve for N
umxPower(trueModel= , update = "engine_litres_to_mpg", sig.level = .05, power = .8, method = c("empirical", "ncp"))
# umxPower(trueModel=, update= , n=, sig.level=.05, power=.8, method= c("empirical", "ncp"))

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
umxPower(trueModel = m1, update = "x_with_y", power = .8, method = "ncp")
m2 = mxGenerateData(m1, nrow=35, returnModel=TRUE)
m2 = umxModify(m1, "x_with_y")
mxPower(trueModel= m1, falseModel= m2, n = 1000)
mxPowerSearch(trueModel= m1, falseModel= m2)

```
