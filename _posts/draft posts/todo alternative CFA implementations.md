require(OpenMx)
data(demoOneFactor)
manifests = paste0("x", 1:5)
latents   = "g"
myData    = demoOneFactor[, manifests]
myCov     = cov(myData, use="pair")
nObs      = nrow(demoOneFactor)
nVar      = length(manifests);
nFac      = 1
n = 10
m1 <- mxModel("One_Fac_Cov", type = "RAM",
	latentVars = latents, manifestVars = manifests,
	mxPath(from = latents, to = manifests),
	mxPath(from = manifests, arrows = 2),
	mxPath(from = latents  , arrows = 2, free = F, values = 1.0),
	mxData(myCov, type = "cov", numObs = nObs)
)
system.time(for (i in 1:n) {mxRun(m1)})[1]/n

m2 <- mxModel(m1, name = "One_Fac_raw",
	mxPath(from = "one", to = manifests),
	mxPath(from = "one", to = latents, free = F, values= 0),
	mxData(myData, type = "raw")
)
system.time(for (i in 1:n) {mxRun(m2)})[1]/n; m2 = mxRun(m2); umxSummary(m2)

m3 <- mxModel("One_Factor_ALT",
	mxMatrix(name  = "alpha" , type = "Full", nrow = nVar, ncol = nFac, values = 0.2, free = T),
	mxMatrix(name  = "lambda", type = "Symm", nrow = nFac, ncol = nFac, values = 1.0, free = F),
	mxMatrix(name  = "theta" , type = "Diag", nrow = nVar, ncol = nVar, values = 1.0, free = T),
	mxAlgebra(name = "cov"   , exp  = alpha %*% lambda %*% t(alpha) + theta),
	mxMLObjective(covariance = "cov", dimnames = manifests),
	mxData(myCov, type = "cov", numObs = nObs)
)
m3 = mxRun(m3)
system.time(for (i in 1:n) {mxRun(m3)})[1]/n; m3 = mxRun(m3); umxSummary(m3)

m4 <- mxModel("LISREL_raw",
  mxMatrix(name = "alpha" , type = "Full", nrow = nFac, ncol = nVar, free = T, values =  0),
  mxMatrix(name = "lambda", type = "Full", nrow = nFac, ncol = nVar, free = T, values = .8),
  mxMatrix(name = "theta" , type = "Diag", nrow = nVar, ncol = nVar, free = T, values = .6),
  mxMatrix(name = "mu"    , type = "Full", nrow = 1   , ncol = nFac, free = F, values =  0),
  mxMatrix(name = "phi"   , type = "Symm", nrow = nFac, ncol = nFac, free = F, values =  1),

  mxAlgebra(name = "cov"  , exp = t(lambda) %*% phi %*% lambda + theta),
  mxAlgebra(name = "mean" , exp = alpha + mu %*% lambda),
  mxFIMLObjective("cov", "mean", names(myData)),
  mxData(myData, "raw")
)
system.time(for (i in 1:n) {mxRun(m4)})[1]/n; m4 = mxRun(m4); summary(m4)$parameters

m1 <- mxModel("Initial Model",
  mxMatrix(name = "alpha" , type = "Full", nrow = 1, ncol = 5, free = T, values = 0),
  mxMatrix(name = "mu"    , type = "Full", 1, 1, F, 0.0),
  mxMatrix(name = "lambda", type = "Full", 1, 5, T, 0.8),
  mxMatrix(name = "phi"   , type = "Symm", 1, 1, F, 1.0),
  mxMatrix(name = "theta" , type = "Diag", 5, 5, T, 0.6),
  mxAlgebra( t(lambda) %*% phi %*% lambda + theta, name = "cov"),
  mxAlgebra(alpha + mu %*% lambda, name = "mean"),
  mxFIMLObjective("cov", "mean", names(myData)),
  mxData(myData, "raw")
)

# Run the model and put results into object with new name.
system.time(mxRun(m1))
m1 <- mxRun(m1)
umxSummary(m1)
