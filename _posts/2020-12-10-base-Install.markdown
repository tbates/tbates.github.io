---
layout: post
title: "Installing umx"
date: 2020-12-10 00:01
comments: true
categories: basic
---

<a name="top"></a>
### Installing umx (and OpenMx)

`umx` is easy to learn use to get print-ready results. But first you need to install the `OpenMx` and `umx` libraries.

1 If you haven't already, install `OpenMx` and `umx` now. In `R`, just type:

``` splus
install.packages("OpenMx")
install.packages("umx")
```

2 Load `umx`. Easy :-)

``` splus
library("umx")
```
                                                               
3 There is no step 3: You're ready for [your first umx model](/basic/2020/11/30/base-First-steps.html)!

### Advanced/beta users

The development version of `umx` lives on [github](https://github.com/tbates/umx) – a great place for package development. Loading libraries from github differs slightly from the procedure you may be used to. instead of `install.packages()`, we're going to use `devtools::install_github()`

``` splus
# if you haven't already, install & load devtools now
install.packages("devtools")
library("devtools")
```

With `devtools` installed, installing umx is easy:

``` splus
install_github("tbates/umx")
library("umx")
```

On windows you *might* need

``` splus
install_github("tbates/umx", args = "--no-multiarch")
```
