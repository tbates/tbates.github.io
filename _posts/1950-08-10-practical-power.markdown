---
layout: post
title: "Simulation & power"

comments: true
categories: technical
---

<a name="top"></a>

# Power analysis

Knowing the power of an study is critical to interpreting its results, and to deciding if it is worth doing at all.

This post covers:

1. Getting the power to detect a difference between 2 models.
2. Power given a certain n.

# NOTE THIS POST IS NOT COMPLETE !!!

umx supports power calculations in the following ways:

1. What's the power to detect dropping 1 or more parameters from our model?
2. What's the power of a umxACE model?

### 1. What is the power to detect One Factor.A[1,6] is different from zero given N=1000, and alpha=.05?

```r
m1 = 
```

```r
mxPowerSearch(trueModel= m1, falseModel= m2)
```

### 2. What is the power to detect One Factor.A[1,6] is different from zero given N=1000, and alpha=.05?

This next snippet, however, is asking:
    “At n= 1000, what is the smallest difference (in either direction?) from the value it is fixed at, which I would have power = 0.8 to detect for the parameter which is fixed in falseModel but free in true model (disregarding the value it takes in true model)”?

```r
 mxPower(trueModel= m1, falseModel= m2, n = 1000)
```

Am I getting that right?

Second. Seems like a quick way to say that would be:
mxPower(nullModel= m2, parameter= "One Factor.A[1,6]", n = 1000)

From what I've seen, the purpose of “truemodel” is just to allow the  function to detect which (only one?) parameter has been fixed by comparing  “false model”  to true model? Why not just offer up mxPower(model= myModel, parameterUnderTest =  "One Factor.A[1,6]”)

i.e., if  “truemodel” is solely used to identify the parameter the user wants to test, why not just let them specify its label (and even value, which would be easier still to play with). So: 

mxPower(nullModel= m2, parameter= "One Factor.A[1,6]", nullValue = .3, n = 1000)
