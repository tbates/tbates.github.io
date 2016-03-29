---
layout: post
title: "Instrumental Variables"
date: 1995-02-13 00:00
comments: true
categories: advanced
---

### This is not finished: e-mail me to prioritise this page if you want it sooner.

IV [Instrumental variable](https://en.wikipedia.org/wiki/Instrumental_variable) analyses are widely used in fields as diverse as [economics], and [genetic epidemiology]. This page shows how to implement these analyses in `OpenMx` and `umx`.

IV analyses allow us to estimate causal relationships when confounding is likely but controlled experiments are not feasible [1]

### Motivation: linear regression can be misleading
Consider some explanatory equation e.g. `Y ~ 𝛽×X + ε`. As a scientific construct, this is interpreted as the causal claim that X plays a causal role in Y, revealed in these data (one could prevaricate about cause, but scientists). If, however covariates are correlated with the error terms, ordinary least squares regression produces biased and inconsistent estimates.[2]

Such correlation with error occurs when:

1. The DV (Y) causes one or more of the covariates ("reverse" causation).
2. One or more explanatory variables is unmeasured.
3. Covariates are subject to measurement error.

Of course one or more of these are almost inevitable, making regression results suspect and often misleading.

If an `instrument` is available, these problems can be overcome. An instrumental variable is a variable that does not suffer from the problems of the confounded predictor. It must:

1. Not be in the explanatory equation.
2. Controlling for ("conditional on") any other covariates, it must correlate with the endogenous explanatory variable(s).

In linear models, there are two main requirements for using an IV:

1. The instrument must be correlated with the endogenous explanatory variables, conditional on the other covariates.
2. The instrument cannot be correlated with the error term in the explanatory equation (conditional on the other covariates)


In this example, we examine the causal influence of X on Y, using an instrumental variable (Z) which affects only X, based on Professor [David Evans'](http://www.di.uq.edu.au/professor-david-evans) [presentation]() at the [2016 International twin workshop](), 

The next block of code simply sets up a simulated dataset containing X, Y, Z (a SNP affecting X), and U - a covariate which induces a correlation between X and Y and which, if not measured, would act as a confounder which might allow a mistaken researcher to assert evidence that X affects Y.

```r
library(umx)

# =================
# = Simulate Data =
# =================
	
set.seed(999)    # Set seed for random number generator
nInd <- 100000   # 100,000 Individuals
Vq   <- 0.02     # Variance of QTL Z (which affects variable X
b_zx <- sqrt(Vq) # Path coefficient between SNP and variable X
b_xy <- 0.1      # Causal effect of X on Y
b_ux <- 0.5      # Confounding effect of U on X
b_uy <- 0.5      # Confounding effect of U on Y
p <- 0.5         # Decreaser allele frequency
q <- 1-p         # Increaser allele frequency
a <- sqrt(1/(2 * p * q)) # Genotypic value for genetic variable of variance 1.0
Vex  <- (1- Vq - b_ux^2) # Residual variance in variable X (so variance adds up to one)
sdex <- sqrt(Vex)        # Residual standard error in variable X
Vey = 1 - (b_xy^2 + 2*b_xy*b_ux*b_uy + b_uy^2) # Residual variance for Y variable (so var adds up to 1.0)
sdey <- sqrt(Vey) # Residual standard error in variable Y

# Simulate individuals
Z <- sample(c(-a,0,a), nInd, replace = TRUE, prob = c(p^2, 2*p*q, q^2)) # Simulate genotypic values
U <- rnorm(nInd, 0, 1) #Confounding variables
X <- b_zx * Z + b_ux * U + rnorm(nInd, 0, sdex) # X variable
Y <- b_xy * X + b_uy * U + rnorm(nInd, 0, sdey) # Y variable

# Recode SNP Z using traditional 0, 1, 2 coding
Z <- replace(Z, Z ==  a, 2)
Z <- replace(Z, Z ==  0, 1)
Z <- replace(Z, Z == -a, 0)

df = data.frame(U =U, X=X, Y=Y, Z=Z)
```

Our first analysis one is a simple linear model (or ordinary least squares regression). This will reveal a large association of X with Y and is the kind of analysis that has been criticised in false-positive epidemiology {GDS reference}.

```splus
   
m1 = lm(Y ~ X    , data = df); coef(m1) # "appears" that Y is caused by X:  𝛽= .35
m1 = lm(Y ~ X + U, data = df); coef(m1) # Controlling U reveals the true link: 𝛽= 0.1

```

### Mendelian randomization analysis

Next, we analyse a Mendelian randomization trial.

A conventional implementation involves two-stage least squares. In R, we can do this using John Fox's `tsls` function from the from `sem` library

```splus

m1 = sem::tsls(formula = Y ~ X, instruments = ~ Z, data = df)
coef(m1)
#                 Estimate  Std. Error   t value     Pr(>|t|)
# (Intercept) 0.0009797078 0.003053891 0.3208064 7.483577e-01
# X           0.1013835358 0.021147133 4.7941976 1.635616e-06

```

Now we can see that X may indeed affect Y, but with the simulated effect size now correctly estimated at .1 (as we specified in the simulated data above) rather than the confounded .35 reported from the simple lm previously presented.


### Implementing MR in OpenMx

```splus

manifests <- c("Z", "X", "Y")
latents   <- c("e1", "e2")

IVModel <- mxModel("IV Model", type="RAM",
	manifestVars = manifests,
	latentVars = latents,
	mxPath(from = c("Z"), arrows=2, free=TRUE, values=1, labels=c("Z") ),  #Variance of SNP 
	mxPath(from = "e1", to = "X", arrows = 1, free = FALSE, values = 1, labels = "e1"), # Residual error X variable. Value set to 1.
	mxPath(from = "e2", to = "Y", arrows = 1, free = FALSE, values = 1, labels = "e2"), # Residual error Y variable. Value set to 1.
	mxPath(from = latents, arrows = 2, free = TRUE, values = 1, labels = c("var_e1", "var_e2") ), # Variance of residual errors
	mxPath(from = "e1", to = "e2", arrows = 2, free = TRUE, values = 0.2, labels = "phi" ), # Correlation between residual errors
	mxPath(from = "Z",  to = "X", arrows = 1, free = TRUE, values = 1, labels = "b_zx"), # SNP effect on X variable
	mxPath(from = "X",  to = "Y", arrows = 1, free = TRUE, values = 0, labels = "b_xy"), # Causal effect of X on Y
	# means and intercepts
	mxPath(from = "one", to = c("Z", "X", "Y"), arrows = 1, free = TRUE, values =1, labels = c("meansnp", "alpha0", "alpha1") ),
	mxData(df, type="raw")
)

IVRegFit <- mxRun(IVModel); umx_time(IVRegFit)# IV Model: 14.34 seconds for 100,000 subjects
coef(IVRegFit)
plot(IVRegFit, std = F, showFixed = T, showMeans = F, digits = 3)
# https://www.dropbox.com/s/ljqrhpuskbihda3/IV_Model.png?dl=0

```

Now an exactly equivalent model in umxRAM

```splus

m2 <- umxRAM("myMR", data = df, autoRun = F,
	umxPath(v.m. = c("Z", "X", "Y")),
	umxPath("Z", to = "X"),
	umxPath("X", to = "Y")
	# umxPath("X", with = "Y") # Due to OpenMx rules, will be deleted!
)
m3 <- umxModify(m2, "X_with_Y", free = T, value = .2)
plot(m3, std = F, digits = 3)
# https://www.dropbox.com/s/1sg32yglfuzgwoz/myMR.png?dl=0

SB <- umxRAM("SB_IV", data = mxData(df, type="raw"),
	umxPath("ex", to = "X", fixedAt = 1, labels = "ex"),
	umxPath("ey", to = "Y", fixedAt = 1, labels = "ey"),
	umxPath("Tx", to = "X", fixedAt = 1, labels = "Tx"),
	umxPath("Ty", to = "Y", fixedAt = 1, labels = "Ty"),
	umxPath("Tz", to = "Z", fixedAt = 1, labels = "Tz"),
	umxPath("ex", with = "ey", values = 0.2, labels = "phi"),
	umxPath("Tz",  to = "Tx", labels = "b_zx"),
	umxPath("Tx",  to = "Ty", labels = "b_xy"),
	umxPath(var = c("Tx", "Ty", "Tz", "ex", "ey"), values = 1),
	umxPath(means = c("Z", "X", "Y"))
)
 
plot(SB, std = F, showFixed = T, digits = 3)
umxCompare(SB, m3)

```