---
layout: post
title: "Choosing an Optimizer: umx_set_optimizer()"
date: 1945-02-12 00:00
comments: true
categories: technical
---

As of version 2.0, OpenMx has 3 optimizers: NPSOL, CSOLNP, and SLSQP (the default).

NPSOL doesnt' ship on the CRAN version of OpenMx (it's proprietary). It is, however, highly optimized and works well with the vast majority of models. If you're having hassles with mxRun, or CIs, NPSOL might help.

CSOLNP can work well for ordinal models. SLSQP has hte benefit of working out of the box from CRAN.

### Enabling NPSOL
Grab the NPSOL version of OpemMx with this command:

```splus
source('http://openmx.psyc.virginia.edu/getOpenMx.R')

```

You can see what optimizer  is being used with

```splus
umx_get_optimizer() # defaults to SLSQP
```

You can set this with 

```splus
umx_set_optimizer() # defaults to NPSOl when available
umx_get_optimizer()
# "NPSOL"

umx_set_optimizer("CSOLNP")
umx_get_optimizer()
# "CSOLNP"

```