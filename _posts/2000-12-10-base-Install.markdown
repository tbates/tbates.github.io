---
layout: post
title: "Installing umx (60 seconds)"

comments: true
categories: basic
---

<a name="top"></a>

`umx` is easy to learn, but first you need to install it ☺

1. If If you haven't already, install `umx`. Go to  `R`, and just type:

```r
install.packages("umx")

library("umx")

```
                                                               
That's it: There is no step 2: You're ready for [your first umx model](/basic/2000/11/30/base-First-steps.html)!


### Beta testers

Want the bleeding edge version of `umx`?

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
