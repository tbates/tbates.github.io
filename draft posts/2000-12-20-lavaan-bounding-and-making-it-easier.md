---
layout: post
title: "Lavaan bounding"

comments: true
categories: models tutorial
---

<a name="top"></a>

https://groups.google.com/forum/#!topic/lavaan/fIRj-P8Y_Dc

There are several benefits to the short Mplus/sem/lavaan Style of syntax; It's easier to type 

A -> B 

than 

```splus
mxPath("A", to = "B", arrows = 1)    
```
This syntax, however has multiple benefits, benefits which you see as soon as you start fitting moderately complex models.

Even with the simplest model, you get the benefit of knowing and controlling exactly what the model is doing: almost nothing is happening "behind the scenes" - we are not setting initial factor loadings to 1, etc.

`umxPath` significantly compacts that syntax, and, along with `umxRAM` for models, makes simple models quicker to type and read while preserving power and explicitness.

Second, you get benefits of [labeled paths](), setting values: almost always necessary, bounding variables.

As you can see in this post lavaan can handle Bounding as well

```splus
    
model1 <- '
f1 =~ x1 + x2 + x3
x1 ~~ var1*x1
x2 ~~ var2*x2
x3 ~~ var3*x3
var1 > 0
var1 < 1
var2 > 0
var2 < 0.5
var3 > 0
var3 < 1.5
'
fit <- cfa(model1, HolzingerSwineford1939)
```

The equivalent in OpenMx is

```splus
    
model1 <- umxRAM("boundedModel", data = HolzingerSwineford1939
	umxPath(c("x1", "x2", "x3"), to = "f1"),
	umxPath(var = "x1", lbound = 0, ubound = 1),
	umxPath(var = "x2", lbound = 0, ubound = 1),
	umxPath(var = "x3", lbound = 0, ubound = 1)
)

model1 mxRun(model1)
```
