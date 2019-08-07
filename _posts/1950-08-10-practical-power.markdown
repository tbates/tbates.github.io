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

Power for SEM is rather more complex as the models are arbitrary in the number of relations in the model. Many more questions can also be asked than, say, `pwr.t.test` could answer. 

`umx`'s `umxPower` tackles this by using an interface very similar to `umxModify`. You offer up a true model, and paths that you want test.

```R
umxPower(trueModel = , update = "path_to_test", sig.level = .05, power = .8, method = c("empirical", "ncp"))
```

To emulate the `pwr.r.test` example, you would run a `trueModel`: A generating model with a covariance of `X` with `Y`. 
You can then request a `umxPower` test, updating "X_with_Y" set to 0.


1. Run model with true correlation (.3)

```R

tmp = umx_make_raw_from_cov(qm(1, .3| .3, 1), n=200, varNames= c("X", "Y"), empirical= TRUE)

m1 = umxRAM("corXY", data = tmp,
	umxPath("X", with = "Y"),
	umxPath(var = c("X", "Y"))
)

```

2. Using `umxPower`, test the path you want to drop, 

```R
umxPower(m1, "X_with_Y", n= 50)
#    method = empirical
#         n = 50
# sig.level = 0.05
#     power = 0.6266667
#    probes = 300
# statistic = LRT
```

3. Now try the ncp method: instant and accurate if the model is valid.

```R
umxPower(m1, "X_with_Y", n= 50, method="ncp")
#    method = ncp
#         n = 50
# sig.level = 0.05
#     power = 0.5837944
# statistic = LRT
```

Now, let's compare the results using a cor.test doing the same thing?

```R
pwr::pwr.r.test(n = 50, r = .3)
#           n = 50
#           r = 0.3
#   sig.level = 0.05
#       power = 0.5715558
# alternative = two.sided
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

umxPower(m1, "engine_litres_to_mpg", n= 30)

   method = empirical
        n = 30
    power = 0.46
   probes = 300
sig.level = 0.05
statistic = LRT

```

Now let's solve for N to give us 80% power.

```r
umxPower(m1, update = "engine_litres_to_mpg", power = .8, method = "ncp")

####################
# Estimating n #
####################

   method = ncp
        n = 68
    power = 0.8
sig.level = 0.05
statistic = LRT

```
