---
layout: post
title: "Parallel Execution"
date: 1945-02-10 00:00
comments: true
categories: models
---

#### This page is not finished. When done it will explain choosing optimizers in OpenMx

As of version 2.0, OpenMx has 3 optimizers: NPSOL, CSOLNP, and SLSQP (the default).
NPSOL doesnt' ship on the CRAN version of OpenMx (it's proprietary).

### Enabling NPSOL
Grab OpemMx from the OpenMx website

```splus
source('http://openmx.psyc.virginia.edu/getOpenMx.R')

```

You can see what optimizer  is being used with

```splus
umx_get_optimizer() # defaults to max-1
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