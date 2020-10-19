---
layout: post
title: "The umx principle (1-minute read)"

comments: true
categories: basic
---

<a name="top"></a>

<p style="text-align: center;">"Principles keep practice aligned with goals"</p>

This package has one principle: make good modeling easier. We designed `umx` to be transparent and reproducible, to make basic work easy, and to make complex work manageable, so you can spend more time doing better science.

`umx` provides a compact set of functions to support four core tasks:

1. Express theories in SEM models.
2. Test competing theories.
3. Maintain a reproducible workflow.
4. Communicate results effectively.

`umx` also provides a suite of complete twin models - a complex multi-group task – to aid users.

You can learn more about umx and twin modeling in Bates, Maes, & Neale, (2019). umx: Twin and Path-Based Structural Equation Modeling in R. *Twin Res Hum Genet*, **22**, 27-41. [doi:10.1017/thg.2019.2](https://www.cambridge.org/core/journals/twin-research-and-human-genetics/article/umx-twin-and-pathbased-structural-equation-modeling-in-r/B9658AC0CDA139E540BFAC0C9D989623) open access.


Read below on installing umx, then on to the modeling!

`umx` is easy to learn, but first you need to install it. If If you haven't already, install `umx`. Go to  `R`, and type:

```r
install.packages("umx")

library("umx")

```
                                                               
That's it: There is no step 2: You're ready for [your first umx model](/basic/2000/11/30/base-First-steps.html)!


### Optional: For bleeding-edge beta testers

The development version of *umx* lives on [github](https://github.com/tbates/umx).

Loading libraries from github differs slightly from the procedure you may be used to.

Instead of `install.packages()`, we're going to use `devtools::install_github()`

If you haven't already, install devtools now

```r
install.packages("devtools")
```

Or just load it:
```r
library("devtools")
```

Installing `umx` is easy:

```r
install_github("tbates/umx")
library("umx")
```

On windows you *might* need

```r
install_github("tbates/umx", args = "--no-multiarch")
```