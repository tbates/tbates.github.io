---
layout: post
title: "Power"

comments: true
categories: technical
---

<a name="top"></a>

Power is the probability of detecting an effect when it is present. Knowing the power of a study is important: Weak studies spew out 5% false positives (i.e., at the rate alpha), but without power, they fail to detect true results at rate beta. Power is 1-beta.

This post covers:

1. Computing power to detect a difference between 2 models.
2. Computing power given a certain `n`.

`umx` supports power calculations for the `umxACE` model (via `power.ACE.test`) and a generic `umxPower` function, which can handle a range of power-related questions given a trueModel, and a parameter which you wish to drop.

## Comparing two models with umxPower

`R` has great support for power. For instance, testing power to detect a correlation of .3 in a sample of 36 subjects, R quickly tells us we're going to need some more subjects...

```R
pwr::pwr.r.test(n = 36, r = .3)
              n = 36
              r = 0.3
      sig.level = 0.05
          power = 0.4361314
    alternative = two.sided
```

Computing power for SEM is rather more complex, as the models are arbitrary. Many more questions can also be asked than, say, `pwr.t.test` could answer. 

`umxPower` tackles this by using an interface very similar to `umxModify`. You offer up a true model, and paths that you want test.

```R
umxPower(trueModel = , update = "path_to_test", n= , power = , sig.level = .05, method = c("ncp", "empirical"))
```

To emulate the `pwr.r.test` example, you would build a `trueModel` of two manifests ("X", and "Y"), with a covariance between them equal to r= .3.
You can then input this to `umxPower` test, setting update to "X_with_Y" (value= 0 is the default for updated parameters).


### Demonstration: Power to detect a correlation of .3 between two variables: X and Y

**First**: Make and run a model of the true correlation (.3)

Make data for the model (this can be tricky for more complex models. the easiest solution is often to use the model with mxGenerateData to generate data corresponding to the model).

```R
tmp = umx_make_raw_from_cov(qm(1, .3| .3, 1), n=200, varNames= c("X", "Y"), empirical= TRUE)
```

Build the model: in this case a correlation

```R
m1 = umxRAM("corXY", data = tmp,
	umxPath("X", with = "Y"),
	umxPath(var = c("X", "Y"))
)

```

**Next**: Using `umxPower`, test the path you want to drop, 

```R
umxPower(m1, "X_with_Y", n= 50, method="empirical")
```

After a few moments, this yields:

    method = empirical
         n = 50
 sig.level = 0.05
     power = 0.6266667
    probes = 300
 statistic = LRT


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

tmp = umx_make_raw_from_cov(qm(1, .3| .3, 1), n= 200, varNames= c("X", "Y"), empirical= TRUE)

m1 = umxRAM("corXY", data = tmp,
	umxPath("X", with = "Y"),
	umxPath(var = c("X", "Y"))
)

umxPower(m1, update = "X_with_Y", explore = TRUE)

        N power
1   17.68  0.25
2   25.36  0.34
3   33.03  0.42
4   40.70  0.50
5   48.38  0.57
6   56.05  0.63
7   63.72  0.69
8   71.40  0.74
9   79.07  0.78
10  86.74  0.82
11  94.42  0.85
12 102.09  0.87
13 109.76  0.90
14 117.44  0.91
15 125.11  0.93
16 132.78  0.94
17 140.46  0.95
18 148.13  0.96
19 155.80  0.97
20 163.48  0.98

```
