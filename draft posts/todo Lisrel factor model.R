require(OpenMx)
data(demoOneFactor)
nvar     <- ncol(demoOneFactor)
varNames <- colnames(demoOneFactor)
factorMeans <- mxMatrix("Zero", 1, 1, name="Kappa", dimnames=list("F1", NA))
xIntercepts <- mxMatrix("Zero", nvar, 1, name="TauX", dimnames=list(varNames, NA))
factorLoadings <- mxMatrix("Full", nvar, 1, TRUE, .6, name="LambdaX", 
labels = paste("lambda", 1:nvar, sep=""), dimnames=list(varNames, "F1"))

factorCov  <- mxMatrix("Diag", 1, 1, FALSE, 1, name="Phi")

xResidVar <- mxMatrix("Diag", nvar, nvar, T, .2, name="ThetaDelta", labels = paste0("theta", 1:nvar))

m <- mxModel(model="LISREL Factor Model",
	factorMeans, xIntercepts, factorLoadings, factorCov, xResidVar,
	mxExpectationLISREL(LX="LambdaX", PH="Phi", TD="ThetaDelta", TX="TauX", KA="Kappa"),
	mxFitFunctionML(),
	mxData(demoOneFactor, "raw")
)
m <- mxRun(m)
summary(m)