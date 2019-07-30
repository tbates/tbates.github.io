---
layout: post
title: "Statistical helper functions"

comments: true
categories: technical
---

There are dozens of useful helper functions in the `umx` library.
A great overview of these is sitting in the package help (`?umx`). It's organized into families of functions
to help you navigate.


### umxAPA

Many functions in R present data in ways designed for programming pipelines, and to be highly modular. This is great for 
programming, but not so good in helping you quickly create tables, and text-summaries of the results of a hypothesis test.


`umxAPA` is a flexible function to summarize, process, and present data in ways that are suitable for viewing or inclusion in publications. If we walk through a writeup, it's value can soon be seen.

First, you might need descriptive statistics. Given a dataframe, `umxAPA` will return a table of correlations, with the mean and SD of each variable as the last row. So, umxAPA(mtcars[,c("cyl", "wt", "mpg", )] yields a table of correlations, means and SDs thus:

| cyl     | wt    | mpg    |       |
|:--------|:------|:-------|:------|
| cyl     | 1     | 0.78   | -0.85 |
| wt      | 0.78  | 1      | -0.87 |
| mpg     | -0.85 | -0.87  | 1     |
| mean_sd | 6.19  | (1.79) | 3.22  |

Next, having run a linear model, you'll want to tell readers what the result was, with an effect, CI, and p-value formatted correctly.

Given an `lm` model, `umxAPA` will return a formatted effect, including 95% CI in square brackets, for each effect. or all of the effects (specified by name in se). e.g.:

```R
m1 = lm(mpg~wt, data = mtcars)
umxAPA(m1, "wt")
```

β = -5.34 [-6.49, -4.2], t = -9.56, p < 0.001

You can also just ask for one effect, by setting the name that appears in the anova table. You can also standardize the model. An example of this is:

```R
m1 = lm(mpg ~ wt + disp, data = mtcars)
umxAPA(m1, "wt", std = TRUE)
```

β = -0.54 [-0.93, -0.16], t = -2.88, p = 0.007


Perhaps while writing the introduction, you hit data from another paper that gave only a beta and se, and you'd like the CI. `umxAPA` returns a CI based on 1.96 times the se. e.g. `umxAPA(.3, se=.1)` yields: β = 0.3 [0.1, 0.5].

While the `digits=` parameter of umx functions often gives you numbers to the precision you need, often you'll need to format a p-value. Just give `umxAPA` a single value, it will be treated as a p-value as returned in APA format. e.g., `umxAPA(.000034)` gives "< 0.001"

You will often want to report a correlation. Pass in a cor.test object to `umxAPA`.

```R
m1 = cor.test(~mpg + wt, data = mtcars)
umxAPA(m1)
```
yields:  r = -0.87 [-0.93, -0.74], t(30) = -9.56, p = < 0.001

`umxAPA` works the same way for several other objects, including `t.test`:

```R
m1 = t.test(extra ~ group, data = sleep)
umxAPA(m1)
```

Means were '0.75' and '2.33'. CI[-3.37, 0.21]. t(17.78) = -1.86, p = 0.08

On my **TODO** list are tutorial blogs about:

* umx_aggregate
* umx_names
* umx_print
* umx_time
* FishersMethod
* umxWeightedAIC
* tmx_is.identified
* tmx_show