---
layout: post
title: "Simulation & power"

comments: true
categories: technical
---

<a name="top"></a>

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


### Demonstration

**First**: Make and run a model of the true correlation (.3)

```R

tmp = umx_make_raw_from_cov(qm(1, .3| .3, 1), n=200, varNames= c("X", "Y"), empirical= TRUE)

m1 = umxRAM("corXY", data = tmp,
	umxPath("X", with = "Y"),
	umxPath(var = c("X", "Y"))
)

```

**Next**: Using `umxPower`, test the path you want to drop, 

```R
umxPower(m1, "X_with_Y", n= 50, method="empirical")
    method = empirical
         n = 50
 sig.level = 0.05
     power = 0.6266667
    probes = 300
 statistic = LRT
```

We can also take advantage of the noncentrality parameter, to run power. This is near-instant and accurate if the model is valid.

```R
umxPower(m1, "X_with_Y", n= 50, method="ncp")
    method = ncp
         n = 50
 sig.level = 0.05
     power = 0.5837944
 statistic = LRT
```

Now, let's compare the results using a `cor.test` doing the same thing?

```R
pwr::pwr.r.test(n = 50, r = .3)
           n = 50
           r = 0.3
   sig.level = 0.05
       power = 0.5715558
 alternative = two.sided
```

### Another example

If someone publishes this simple model claiming that larger engines lower miles/gallon in vehicles, what power do we have to detect `engine_litres_to_mpg` is > 0 if we replicate with the same `n`, and assume that the obtained effect is the true one? 
 
First we build the claimed model:

```R
df = mtcars
df$engine_litres = .016 * df$disp

m1 = umxRAM(data = df, "#mpg_model
	mpg ~ engine_litres + wt
	wt ~~ engine_litres"
)
```

And test power:

```R
umxPower(m1, "engine_litres_to_mpg", n= 30, method = "empirical")

   method = empirical
        n = 30
    power = 0.46
   probes = 300
sig.level = 0.05
statistic = LRT
```

Now let's solve for N to give us 80% power.

```r
# solve for N
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

Finally, we can make a table showing how power changes across n:

```r
tmp = umx_make_raw_from_cov(qm(1, .3| .3, 1), n=200, varNames= c("X", "Y"), empirical= TRUE)

m1 = umxRAM("corXY", data = tmp,
	umxPath("X", with = "Y"),
	umxPath(var = c("X", "Y"))
)

umxPower(m1, update = "X_with_Y", tabulatePower = TRUE)

           N     power lower upper
1   17.68281 0.2524566    NA    NA
2   25.35621 0.3398249    NA    NA
3   33.02962 0.4227884    NA    NA
4   40.70303 0.4997667    NA    NA
5   48.37644 0.5698807    NA    NA
6   56.04984 0.6327761    NA    NA
7   63.72325 0.6884764    NA    NA
8   71.39666 0.7372651    NA    NA
9   79.07006 0.7795929    NA    NA
10  86.74347 0.8160076    NA    NA
11  94.41688 0.8471017    NA    NA
12 102.09028 0.8734748    NA    NA
13 109.76369 0.8957086    NA    NA
14 117.43710 0.9143494    NA    NA
15 125.11050 0.9298992    NA    NA
16 132.78391 0.9428105    NA    NA
17 140.45732 0.9534851    NA    NA
18 148.13072 0.9622754    NA    NA
19 155.80413 0.9694872    NA    NA
20 163.47754 0.9753837    NA    NA

```
