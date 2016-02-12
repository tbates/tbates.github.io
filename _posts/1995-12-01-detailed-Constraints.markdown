---
layout: post
title: "Constraints?"
date: 1995-12-01 00:00
comments: true
categories: advanced 
---

#### Post not finished...

# Constraints

### Constrain K to take a value fixed in another matrix (no real use...)

```r
library(OpenMx)
m1 <- mxModel(model="con_test", 
    mxMatrix(name = "limit", type = "Full", nrow = 2, ncol = 2, free = FALSE, values = 1:4), 
    mxMatrix(name = "K"    , type = "Full", nrow = 2, ncol = 2, free = TRUE), 
	# Force K to take the values of limit
    mxConstraint(K == limit, name = "Klimit_equality"), 
	# Add an algebra and objective to minimise K.
	# The constraint should ensure that K is [1,2; 3,4]
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

Let's maximise A + B with the constraint that A must exceed B, A < 10 and B < 100. What do you think the answer is?

```r
m1 <- mxModel(model="max_A_plus_B",
    mxMatrix(name = "A", nrow = 1, ncol = 1, free = T),
    mxMatrix(name = "B", nrow = 1, ncol = 1, free = T),
	mxConstraint(A > B  , name = 'A_greaterthan_B'),
	mxConstraint(A < 10 , name = 'Amax'),
	mxConstraint(B < 100, name = 'Bmax'),
    mxAlgebra(A + B, name = "C"),
    mxAlgebra(   -C, name = "maxC"), 
    mxAlgebraObjective("maxC") 
)
m1 <- mxRun(m1)
mxEval(C, m1)
#      [,1]
# [1,]   20

```

Equate both free parameters of matrix D using labels (both are set to "eq")

```r    
m1 <- mxModel(model="what", 
	mxMatrix("Full", 2, 1, free=TRUE, values=1, labels="eq", name="D")
	mxAlgebra(log(start), name = "logP")
    mxAlgebra(-C, name = "maxC"), 
    mxAlgebraObjective("maxC") 
)
m1 <- mxRun(m1)
mxEval(C, m1)
#      [,1]
# [1,]   20

```

```r
require(OpenMx)
data(demoOneFactor)
df = demoOneFactor[c("x1","x2", "x3")]
manifests = names(df)
m1 <- mxModel("x1_equals_x2byx3 ", type = "RAM", 
	manifestVars = manifests,
	mxPath(from = "by", to = "x1"),
	mxPath(from = manifests, arrows = 2, free = F, values = 1.0),
	mxData(cov(demoOneFactor), type = "cov", numObs = 500)
)
#' m1 = umxRun(m1, setLabels = T, setValues = T)

```
# Constrain a matrix element in F to be equal to the result of an algebra
start <- mxMatrix("Full", 1, 1, free=TRUE,  values=1, labels="logP", name="F")

# Constrain the fixed parameter in matrix G to be the result of the algebra
end <- mxMatrix("Full", 1, 1, free=FALSE, values=1, labels="logP[1,1]", name="G")
