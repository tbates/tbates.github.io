---
layout: post
title: "Constraints"

comments: true
categories: advanced 
---

There a many times in modeling that we need to set paths equal to values determined from other aspects of the model. Commonly this can be done using labels - simply giving the same labels to objects we wish to equate. This is computationally efficient. Another way to limit the values a path can take is via upper and lower bounds. There are times, however, when these two methods are insufficient. For instance equating a free path to a fixed path, or, constraining a value using an algebra. That's when constraints are essential.

Constraints are implemented by providing an algebra to `mxConstraint`. e.g. , like `mxConstraint(A < B[1,1] %*% 2`) 

### Constrain K to take a value fixed in another matrix (no real use...)

Here's an example in which we force the cells of matrix `K`	to take the values of a second matrix `limit`. To do this we write an `mxConstraint` with the algebra `K == limit`. The constraint should ensure that K is [1,2; 3,4] - the values of `limit`.

```r
m1 <- mxModel("constraint_test", 
    umxMatrix("limit", type = "Full", nrow = 2, ncol = 2, free = FALSE, values = 1:4), 
    umxMatrix("K"    , type = "Full", nrow = 2, ncol = 2, free = TRUE), 
    mxConstraint(K == limit, name = "Klimit_equality"), 
    mxAlgebra(min(K), name = "minK"), 
    mxFitFunctionAlgebra("minK") 
)
mxEval(K, m1)
```

You might try and do this using labels: but labels can only equate free parameters, not free and fixed parameters. So...

```r
m1 = mxModel(model="con_test", 
    umxMatrix("limit", nrow = 2, ncol = 2, free = FALSE, labels = paste0("eq", 1:4), values = 1:4),
    umxMatrix("K"    , nrow = 2, ncol = 2, free = TRUE, labels = paste0("eq", 1:4)),
    mxAlgebra(min(K), name = "minK"), 
    mxAlgebraObjective("minK") 
)
m1 = mxRun(m1)
# Error: In model 'con_test' the name 'eq1' is used as a free parameter in 'con_test.K' and as a fixed parameter in 'con_test.limit'
```

Here's another example. In this model, we will maximise the sum `A + B`, with the `mxConstraint` that `A` must exceed `B`, but also remain under the value 10. What do you think the answer will be?

```r
m1 = mxModel("max_A_plus_B",
    umxMatrix("A", nrow = 1, ncol = 1, free = TRUE),
    umxMatrix("B", nrow = 1, ncol = 1, free = TRUE),
	mxConstraint(name = 'A_greaterthan_B', A > B),
	mxConstraint(name = 'Amax', A < 10),
    mxAlgebra(name = "C", A + B),
    mxAlgebra(name = "maxC", -C),
    mxFitFunctionAlgebra("maxC") 
)
m1 = mxRun(m1)

mxEval(c(A=A, B=B, C=C), m1)

#   [,1]
# A   10
# B   10
# C   20

```

Equate both free parameters of matrix D using labels (both are set to "eq") but constrain one to take the value log(10)

```r    
m1 = mxModel("what",
	umxMatrix("D", "Full", nrow= 2, ncol= 1, free = TRUE, values = 1, labels = "eq"),
	mxConstraint(D[1,1] == log(10) , name = 'fix_cell_D_one'),	
    mxAlgebra(name = "maxD", -D[2,1]), 
    mxFitFunctionAlgebra("maxD")
)
m1 = mxRun(m1)
mxEval(D, m1)
#          [,1]
# [1,] 2.302585
# [2,] 2.302585

```