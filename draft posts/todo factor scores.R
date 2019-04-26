# CI on RMSEA is implemented in [MBESS](https://openmx.ssri.psu.edu/thread/41-summarymyfitmodel-what-should-be-printed-what-should-be-returned-list)
# require(MBESS)
# ci.rmsea(rmsea=.05, df=10, N=100, conf.level = 0.90)
# $Lower.Conf.Limit #[1] 0
# $RMSEA #[1] 0.05
# $Upper.Conf.Limit #[1] 0.1259771
#
# https://github.com/tbates/umx/edit/master/developer/factorscores.R

# =======================
# = Estabrook and Neale =
# =======================

# Estabrook, R. and Neale, M. (2013). A Comparison of Factor Score Estimation Methods in the Presence of Missing Data: Reliability and an Application to Nicotine Dependence. <i>Multivariate Behav Res</i>, <b>48</b>, 1-27, [doi](http://dx.doi.org/10.1080/00273171.2012.730072).

# Make the weighted factor score model

# Factor score estimation is a controversial topic. If you want to use a traditional 
# (i.e., Bartlett) estimator, you could use the OpenMx estimated loadings and use 
# the functions in the psych library.

# https://openmx.ssri.psu.edu/svn/trunk/demo/OneFactorModel_PathRaw.R
require(OpenMx)
data(demoOneFactor)
manifests = paste0("x", 1:5)
latents   = "g"
myData    = demoOneFactor[, manifests]
myCov     = cov(myData, use="pair")
nObs      = nrow(demoOneFactor)
nVar      = length(manifests);
nFac      = 1
n         = 10
m1 <- umxRAM("One_Fac_Raw", data = mxData(myData, type = "raw"),
	umxPath(from  = latents, to = manifests),
	umxPath(var   = manifests),
	umxPath(means = manifests),
	umxPath(v1m0  = latents)
)
m1 <- mxRun(m1)

# Fee means and fix parameters at estimated values
scores.MxModel <- function(model) {
	umx_check_model(model,type = "RAM", hasData = T, hasMeans = T)
	model@name = "fm" # for "full model", just so we can refer to it in the algebra below
	model$M@free[,] <- TRUE
	model$A@free[,] <- FALSE
	model$S@free[,] <- FALSE
	# model$F@free[,] <- FALSE # unecessary
	# Change objective function
	model@fitfunction <- mxFitFunctionML(vector = TRUE)
	model@fitfunction <- mxExpectationRAM(dimnames = names(model@data@observed))
	fullData = model@data$observed
	# Loop over each subject, changing data to just that row...
	for (i in 1:numrow(myData)) {
		model@data <- mxData(fullData[i,], "raw")
		fullModel <- mxModel("Weighted Factor Score Model", model,
			mxAlgebra(name = "weight", 1 / (sqrt( 2 * pi) * sqrt(det(fm.phi))) * exp(-.5 * (fm.mu %&% solve(fm.phi)))),
			mxAlgebra(name = "alg", -2 * log(weight %x% fm.objective)),
			mxAlgebraObjective("alg")
		)
		fsResults <- mxRun(fullModel)
	}
}

# parameter symbol\nlower case| Matrix symbol\nupper case| name
# Λ     | λ     | Lambda
# β     | B     | Beta
# δ     | Δ     | Delta
# γ     | Γ     | Gamma
# θ     | Θ     | Theta
# ζ     | Ζ     | Zeta


# ===============================
# = Can do this for LISREL ALSO =
# ===============================
# Free factor mean value
f1$mu@free[,] <- T
# Fix free parameters at estimated values
f1$alpha@free[,]  <- F
f1$lambda@free[,] <- F
f1$theta@free[,]  <- F
# Change objective function
f1@objective <- mxFIMLObjective("theta", "mean", names(expData), vector=TRUE)
# change data
for (i in 1:numrow(myData)) {
	f1@data <- mxData(myData[1,], "raw")
	fullModel <- mxModel("Weighted Factor Score Model", f1,
		mxAlgebra(name = "weight", 
		1 / (sqrt(2*pi) * sqrt(det(factorModel.phi))) * exp(-.5 * (factorModel.mu %&% solve(factorModel.phi))) ),
		mxAlgebra(name = "alg"   , -2 * log(weight %x% factorModel.objective)),
		mxAlgebraObjective("alg")
	)
	fsResults <- mxRun(fullModel)
}

# =======================
# = Estabrook and Neale =
# =======================

```splus
# matrix specification of common factor model
data(myFADataRaw, package="OpenMx")
manifests = paste0("x",1:5)
nVar = length(manifests)
nFac = 1
exampleData = myFADataRaw[, manifests]


| Symbol | Name   | Arrow type | Detail                                    |
|:-------|:-------|:-----------|:------------------------------------------|
| α      | alpha  | ->         |                                           |
| μ      | mu     |            | Means?                                    |
| Λ      | Lambda | ->         | Endogenous loadings?                      |
| Φ      | phi    | <->        | Exogenous latent variance and covariances |

CFA <- mxModel("CFA",
	mxMatrix(name = "alpha"  ,"Full", nrows = 1   , ncol = nVar, free = TRUE , values = 0),
	# need to check these 1s: must be ncol = nVar for mu. nrow = nFac???...
	# nrow = nFac and ncol = nFac for phi?...
	mxMatrix(name = "mu"     ,"Full", nrows = 1   , ncol = 1   , free = FALSE, values = 0),
	mxMatrix(name = "lambda" ,"Full", nrows = 1   , ncol = nVar, free = TRUE , values = 0.8),
	mxMatrix(name = "phi"    ,"Symm", nrows = 1   , ncol = 1   , free = FALSE, values = 1),
	mxMatrix(name = "theta"  ,"Diag", nrows = nVar, ncol = nVar, free = TRUE , values = 0.6),
	mxAlgebra(name = "cov", t(lambda) %*% phi %*% lambda + theta),
	mxAlgebra(name = "mean", alpha + mu %*% lambda),
	mxFIMLObjective("cov", "mean", manifests),
	mxData(exampleData, "raw")
)
# run the model
CFA <- mxRun(CFA)
# put initial results into new object and change the name.
scoreAperson <- mxModel(CFA, name = "scoreAperson"
	# Change objective function
	mxFIMLObjective("theta", "mean", names(exampleData), vector = TRUE)
	# Change data
	mxData(exampleData[1,], "raw")
)
# Free factor means and fix free parameters at estimated values
scoreAperson$mu@free[,]     <- TRUE
scoreAperson$alpha@free[,]  <- FALSE
scoreAperson$lambda@free[,] <- FALSE
scoreAperson$theta@free[,]  <- FALSE

# Make the weighted factor score model
fullModel <- mxModel("Weighted Factor Score Model", scoreAperson,
	mxAlgebra(name = "weight",
 		1/((2*pi)^(1/2) * sqrt(det(factorModel.phi))) * exp(-.5*(factorModel.mu %&% solve(factorModel.phi)))
	),
	mxAlgebra(name = "alg", −2 * log(weight %x% Factor Score.objective) ),
	mxAlgebraObjective("alg")
)

# Run the weighted factor score model
fullModel <- mxRun(fullModel)
```
