require(OpenMx); data(demoOneFactor)

m2 <- mxModel("One Factor",
	mxMatrix("Full", 5, 1, values = 0.2, free = T, name = "A"), 
	mxMatrix("Symm", 1, 1, values = 1, free = F, name = "L"), 
	mxMatrix("Diag", 5, 5, values = 1, free = T, name = "U"), 
	# mxAlgebra(A %*% L %*% t(A) + U, name = "R"), 
	mxAlgebra(A %&% L + U, name = "R"), 
	mxExpectationNormal(covariance= "R", dimnames = names(demoOneFactor)),
	mxFitFunctionML(),
	# mxMLObjective("R", dimnames = names(demoOneFactor)), 
	mxData(cov(demoOneFactor), type = "cov", numObs = 500)
)
m2 = mxRun(m2); umxSummary(m2)