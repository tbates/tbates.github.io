# list of variable names in the Duncan data
dimnames = c("RespOccAsp", "RespEduAsp", "RespParAsp", "RespIQ", "RespSES",
             "FrndOccAsp", "FrndEduAsp", "FrndParAsp", "FrndIQ", "FrndSES")
# lower-triangle of correlations among these variables
tmp = c(
	0.6247,
	0.2137, 0.2742,
	0.4105, 0.4043, 0.1839,
	0.3240, 0.4047, 0.0489, 0.2220,
	0.3269, 0.3669, 0.1124, 0.2903, 0.3054,
	0.4216, 0.3275, 0.0839, 0.2598, 0.2786, 0.6404,
	0.0760, 0.0702, 0.1147, 0.1021, 0.0931, 0.2784, 0.1988, 
	0.2995, 0.2863, 0.0782, 0.3355, 0.2302, 0.5191, 0.5007,  0.2087,
	0.2930, 0.2407, 0.0186, 0.1861, 0.2707, 0.4105, 0.3607, -0.0438, 0.2950
)

# Use the umx_lower2full function to create a full correlation matrix
duncanCov = umx_lower2full(tmp, diag = FALSE, dimnames = dimnames)

# Turn the duncan data into an mxData object for the model
duncanCov = mxData(duncanCov, type = "cov", numObs = 300)

# Make some useful lists of variables to use when creating paths.
respondentFormants   = c("RespSES", "FrndSES", "RespIQ", "RespParAsp")
friendFormants       = c("FrndSES", "RespSES", "FrndIQ", "FrndParAsp")
latentAspiration     = c("RespLatentAsp", "FrndLatentAsp")
respondentOutcomeAsp = c("RespOccAsp", "RespEduAsp")
friendOutcomeAsp     = c("FrndOccAsp", "FrndEduAsp")

m1 = umxRAM("Duncan", data = duncanCov,
	# Working from the left of the model to right...

	# Add all distinct paths between variables to allow the 
	# exogenous manifests to covary with each other
	umxPath(unique.bivariate = c(friendFormants, respondentFormants)),

	# Variance for the (assumed error free) exogenous manifests,
	# so fixed at unity)
	umxPath(var = c(friendFormants, respondentFormants), fixedAt = 1),

	# Paths from IQ, SES, and parental aspiration to latent aspiration, for Respondents
	umxPath(respondentFormants, to = "RespLatentAsp"),
	# And same for friends
	umxPath(friendFormants,     to = "FrndLatentAsp"),

	# The two aspiration latent traits have residual variance.
	umxPath(var = latentAspiration),

	# And the latent traits each influence the other (equally)
	umxPath(fromEach = latentAspiration, lbound = 0, ubound = 1), # Using one-label would equate these 2 influences

	# Latent aspiration affects occupational and educational aspiration in respondents
	umxPath("RespLatentAsp", to = respondentOutcomeAsp, firstAt = 1),
	# umxPath("RespLatentAsp", to = respondentOutcomeAsp, labels = c("Asp_to_OccAsp", "Asp_to_EduAsp")),
	# # And their friends
	umxPath("FrndLatentAsp", to = friendOutcomeAsp, firstAt = 1),
	# nb: The firstAt 1 provides scale to the latent variables
	# (we could constrain the total variance of the latents to 1, but this is easy )
	
	# Finally, on the right hand side of our envelope sketch, we've got
	# residual variance for the endogenous manifests
	umxPath(var = c(respondentOutcomeAsp, friendOutcomeAsp)),
	autoRun = TRUE
)