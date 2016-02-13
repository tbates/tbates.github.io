---
layout: post
title: "Constraints?"
date: 1995-12-01 00:00
comments: true
categories: advanced 
---

#### Post not finished...

# Constraints

There a many times in modeling that we need to set paths equal to values determined from other paths in the model. Commonly, this can be done using labels - simply giving the same label to the objects we wish to equate. This is easy, and computationally efficient. Another way to limit the values a path can take is via upper and lower limits. There are times, however, when these two go-to tool won't work. For instance equating a free path to a fixed path, or, constraining a value using an algebra. That's when constraints are essential.

Constraints are implemented, as you might expect, via `mxConstraint`. This takes an algebra, like ` A < B[1,1] %*% `

### Constrain K to take a value fixed in another matrix (no real use...)

Here's an example in which we force the cells of matrix `K`	to take the values of a second matrix `limit`. To do this we write an mxConstraint with the algebra `K == limit`. The constraint should ensure that K is [1,2; 3,4] - the values of `limit`.

```r
library(OpenMx)
m1 <- mxModel(model="con_test", 
    mxMatrix(name = "limit", type = "Full", nrow = 2, ncol = 2, free = FALSE, values = 1:4), 
    mxMatrix(name = "K"    , type = "Full", nrow = 2, ncol = 2, free = TRUE), 
    mxConstraint(K == limit, name = "Klimit_equality"), 
    mxAlgebra(min(K), name = "minK"), 
    mxAlgebraObjective("minK") 
)
m1 <- mxRun(m1)
mxEval(K, m1)
```

You might try and to this using labels: but labels can only equate free parameters, not free and fixed parameters. SO...

```r
m1 <- mxModel(model="con_test", 
    mxMatrix(name = "limit", nrow = 2, ncol = 2, free = F, labels = paste0("eq", 1:4), values = 1:4),
    mxMatrix(name = "K"    , nrow = 2, ncol = 2, free = T, labels = paste0("eq", 1:4)),
    mxAlgebra(min(K), name = "minK"), 
    mxAlgebraObjective("minK") 
)
m1 <- mxRun(m1)
# Error: In model 'con_test' the name 'eq1' is used as a free parameter in 'con_test.K' and as a fixed parameter in 'con_test.limit'
```

Here's another example. In this model, we will maximise the sum `A + B`, with the `mxConstraint`s that `A` must exceed `B`, and `A < 10`. What do you think the answer will be?

```r
m1 <- mxModel(model="max_A_plus_B",
    mxMatrix(name = "A", nrow = 1, ncol = 1, free = T),
    mxMatrix(name = "B", nrow = 1, ncol = 1, free = T),
	mxConstraint(A > B  , name = 'A_greaterthan_B'),
	mxConstraint(A < 10 , name = 'Amax'),
    mxAlgebra(A + B, name = "C"),
    mxAlgebra(   -C, name = "maxC"), 
    mxAlgebraObjective("maxC") 
)
m1 <- mxRun(m1)
mxEval(c(A, B, C), m1)
#      [,1]
# [1,]   20
```

Equate both free parameters of matrix D using labels (both are set to "eq")

```r    
m1 <- mxModel(model="what", 
	mxMatrix("Full", 2, 1, free = TRUE, values = 1, labels = "eq", name = "D")
	mxAlgebra(log(start), name = "logP")
    mxAlgebra(-C, name = "maxC"), 
    mxAlgebraObjective("maxC") 
)
m1 <- mxRun(m1)
mxEval(C, m1)
#      [,1]
# [1,]   20

```