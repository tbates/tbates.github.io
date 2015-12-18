---
layout: post
title: "Get and Set the Optimizer using umx_set_optimizer"
date: 1945-02-12 00:00
comments: true
categories: technical
---

As of version 2.0, OpenMx has 3 optimizers: `NPSOL`, `CSOLNP`, and `SLSQP` (the default).

`NPSOL` doesn't ship on the CRAN version of OpenMx (it's proprietary). It is, however, highly optimized and works well with the vast majority of models. If you're having hassles with mxRun, or CIs, NPSOL might help.

CSOLNP can work well for ordinal models. SLSQP has the benefit of working out of the box from CRAN, and is often as good or better than `NPSOL`.

You can see what optimizer  is being used with

```splus
umx_get_optimizer()
# SLSQP
```

You can set the optimizer with 

```splus
umx_set_optimizer("CSOLNP")
umx_get_optimizer()
# "CSOLNP"

```

Called with no input, umx_set_optimizer will try and set the optimizer to `NPSOL`

```splus
umx_set_optimizer() 
umx_get_optimizer()
# "NPSOL"
```


### How to enable NPSOL

1. Grab the NPSOL version of OpemMx with this command:

```splus
source('http://openmx.psyc.virginia.edu/getOpenMx.R')

```

That's it :-)
