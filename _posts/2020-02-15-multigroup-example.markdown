require(OpenMx)
data(demoOneFactor)
manifests <- names(demoOneFactor)
# manifests <- manifests[-1]
latents <- c("G")
factorModel <- mxModel("One Factor", type="RAM",
	manifestVars = manifests,
	latentVars = latents,
	mxPath(from=latents, to=manifests),
	mxPath(from=manifests, arrows=2),
	mxPath(from=latents, arrows=2, free=FALSE, values=1.0),
	mxData(cov(demoOneFactor), type="cov", numObs=500)
)
mxStandardizeRAMpaths(factorModel,T)
summary(mxRun(factorModel))
require(umx)
data(demoOneFactor)
latents  = c("G")
manifests = names(demoOneFactor)
# 1. Make two models, and nest them in a multigroup
m1 <- umxRAM("model1", data = mxData(cov(demoOneFactor), type = "cov", numObs = 500),
      umxPath(latents, to = manifests),
      umxPath(var = manifests),
      umxPath(var = latents, fixedAt = 1.0)
)
m2 <- mxModel(m1, name="model2")
m2 = mxRun(m2)
# 2. Nest them in a multigroup supermodel and run
m3 = mxModel("bob", m1, m2, mxFitFunctionMultigroup(c("model1", "model2")) )
m3 = mxRun(m3);
# 3 request saturated model
x = omxSaturatedModel(m3)

# RepairBowl Returns
# 2741 Satsuma Dr
# STE 104
# Dallas TX 75229-3580
