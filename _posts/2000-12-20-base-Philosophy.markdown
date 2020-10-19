---
layout: post
title: "The umx principle (1-minute read)"

comments: true
categories: basic
---

<a name="top"></a>

<p style="text-align: center;">"Principles keep practice aligned with goals"</p>

This package has one principle: make good modeling easier.

`umx` provides a compact set of functions to support four core tasks:

1. Express theories in SEM models.
2. Test competing theories.
3. Maintain a reproducible workflow.
4. Communicate results effectively.

[OpenMx](https://openmx.ssri.psu.edu) is a fantastic base - often you'll stick with core OpenMx functions: Using `mxPath` instead of `umxPath`, or `summary` instead of `umxSummary`.

That said, we designed `umx` to provide "one way that works", making basic work easy, and complex work manageable, so you can spend more time doing better science.

That's it ☺ 
Read below on installing umx, then on to the modeling!

`umx` is easy to learn, but first you need to install it. If If you haven't already, install `umx`. Go to  `R`, and just type:

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