---
layout: post
title: "Set the Optimizer using umx_set_optimizer"
date: 1945-02-12 00:00
comments: true
categories: technical
---

As of version 2.0, OpenMx has 3 optimizers: `NPSOL`, `CSOLNP`, and `SLSQP` (the default).

`NPSOL` doesn't ship on the CRAN version of OpenMx (it's proprietary). It is, however, highly optimized and works well with the vast majority of models. If you're having hassles with mxRun, or CIs, NPSOL might help.

CSOLNP can work well for ordinal models. SLSQP has the benefit of working out of the box from CRAN, and is often as good or better than `NPSOL`.

You can see what optimizer is being used by calling `umx_set_optimizer` with no parameters:

```r
umx_set_optimizer()
# SLSQP
```

Set the optimizer by name:

```r
umx_set_optimizer("CSOLNP")
umx_set_optimizer()
# "CSOLNP"

```
See all options by asking for something that doesn't exist:

```r
umx_set_optimizer("tinkerbell")
# The Optimizer 'tinkerbell' is not legal. Legal values (from mxAvailableOptimizers() ) are:'CSOLNP' and 'SLSQP'

```
If, like above, you don't see NPSOL as an option, you're running a CRAN build. If you want NPSOL, grab the custom UVA version of `OpenMx`

### How to enable NPSOL

1. Grab the NPSOL version of OpemMx with this command:

```r
source('http://openmx.psyc.virginia.edu/getOpenMx.R')

```

That's it :-)
