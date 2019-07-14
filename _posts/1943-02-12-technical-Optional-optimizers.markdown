---
layout: post
title: "Set the Optimizer using umx_set_optimizer"

comments: true
categories: technical
---

`umx` can use 3 optimizers: `NPSOL`, `SLSQP`, and  `CSOLNP`(the default).

`NPSOL` doesn't ship on the CRAN version of OpenMx (it's proprietary). It is, however, highly optimized and works well with the vast majority of models. If you're having hassles with mxRun, or CIs, NPSOL might help.

`CSOLNP` can work well for ordinal models. `SLSQP` is often as good or better than `NPSOL` and has the benefit of working out of the box from CRAN.

You can see what optimizer is being used by calling `umx_set_optimizer` with no parameters.

```r
umx_set_optimizer()

```
> Current Optimizer is: 'CSOLNP'. Options are: 'CSOLNP', 'SLSQP', and 'NPSOL'

Set the optimizer by name:

```r
umx_set_optimizer("CSOLNP")

```
*top tip*: If you don't see `NPSOL` as an option, grab the NPSOL version of `OpenMx`:

```r
install.OpenMx("NPSOL")

```

On MacOS, you can also get a bleeding-edge travis build of OpenMx this way:

```r
install.OpenMx("travis")

```

That's it :-)
