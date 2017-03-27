Davidai, S., & Gilovich, T. (2015). Building a more mobile America – one income quintile at a time. Perspectives on Psychological Science. 
Hackman, D., & Farah, M. (2009). Socioeconomic status and the developing brain. Trends in Cognitive Sciences.
Jones, O. (2011). Chavs: The demonization of the working class. Verso Books. 
Kraus, M., et al (2012). Social class, solipsism, and contextualism: How the rich are different from the poor. Psychological Review. 
Stephens, N., et al (2014). Social class culture cycles: How three gateway contexts shape selves and fuel inequality. Annual Review of Psychology. 
Wilkinson, R., & Pickett, K. (2009). The Spirit Level: Why more equal societies almost always do better. Allen Lane, London. 

library(umx)
# full WLS gives unbiased estimates like diagonally weighted least squares and unweighted least squares do.
# inst/models/passing/jointFactorModelsTest.R
require(OpenMx)

rms <- function(x, y = NA){
	if(is.matrix(x) && is.vector(y) && nrow(x) == length(y)){
		sqrt(colMeans((x - y)^2))
	} else if(is.matrix(x) && length(y) == 1 && is.na(y)){
		apply(x, 2, FUN = rms, x = x)
	} else{
		sqrt(mean((x - y)^2))
	}
}


# ----------------------
# Get and Structure Data
jointData <- read.table("~/bin/OpenMx/inst/models/passing/data/jointdata.txt", header = TRUE)

# specify ordinal columns as ordered factors
jointData[,c(2,4,5)] <- mxFactor(jointData[,c(2,4,5)], levels = list(c(0, 1), c(0, 1, 2, 3), c(0, 1, 2)))
str(jointData)
 # $ z1: num  6.83 8.77 8.01 9 8.52 ...
 # $ z2: Ord.factor w/ 2 levels "0"<"1": 1 1 1 2 1 1 1 1 1 1 ...
 # $ z3: num  -0.0647 2.8983 2.5471 2.9078 3.4518 ...
 # $ z4: Ord.factor w/ 4 levels "0"<"1"<"2"<"3": 3 3 2 3 2 2 1 2 1 4 ...
 # $ z5: Ord.factor w/ 3 levels "0"<"1"<"2": 3 2 3 3 1 3 1 3 3 2 ...

# Model pre-setting
# fix ordinal values at 1
satCov <- mxMatrix("Symm", 5, 5, free = TRUE, values = diag(5), name = "C")
satCov$free[2,2] <- FALSE
satCov$free[4,4] <- FALSE
satCov$free[5,5] <- FALSE

loadings <- mxMatrix("Full", 1, 5, free=TRUE, values=1, name="L", lbound=0)
loadings$ubound[1,5] <- 2

resid <- mxMatrix("Diag", 5, 5, free=c(TRUE, FALSE, TRUE, FALSE, FALSE), values=.5, name="U")
means <- mxMatrix("Full", 1, 5, free=c(TRUE, FALSE, TRUE, FALSE, FALSE), values=0, name="M")

thresh            <- mxMatrix("Full", 3, 3, FALSE, 0, name="T")
thresh$free[,1]   <- c(TRUE, FALSE, FALSE)
thresh$values[,1] <- c(0, NA, NA)
thresh$labels[,1] <- c("z2t1", NA, NA)
thresh$free[,2]   <- TRUE
thresh$values[,2] <- c(-1, 0, 1)
thresh$labels[,2] <- c("z4t1", "z4t2", "z4t3")
thresh$free[,3]   <- c(TRUE, TRUE, FALSE)
thresh$values[,3] <- c(-1, 1, NA)
thresh$labels[,3] <- c("z5t1", "z5t2", NA)


# Model definition

# ML form
jointModel1 <- mxModel("ContinuousOrdinalData",
	mxData(jointData, "raw"),
	loadings, resid, means, thresh,
	mxAlgebra(t(L) %*% L + U, name = "C"),
	mxFitFunctionML(),
	mxExpectationNormal("C", "M", dimnames = names(jointData), thresholds = "T", threshnames = c("z2", "z4", "z5"))
)

# run it
jointResults1 <- mxRun(jointModel1, suppressWarnings = TRUE)
umx_time(jointResults1)
summary(jointResults1)

# Create WLS Data
wd <- mxDataWLS(jointData, "WLS")
dd <- mxDataWLS(jointData, "DLS")
ud <- mxDataWLS(jointData, "ULS")

# WLS form(s) of model
jointWlsModel <- mxModel(jointModel1, name = 'wlsModel', wd, mxFitFunctionWLS())
jointDlsModel <- mxModel(jointModel1, name = 'dlsModel', dd, mxFitFunctionWLS())
jointUlsModel <- mxModel(jointModel1, name = 'ulsModel', ud, mxFitFunctionWLS())

# Run 'em
jointWlsResults <- mxRun(jointWlsModel)
jointDlsResults <- mxRun(jointDlsModel)
jointUlsResults <- mxRun(jointUlsModel)

umx_time(c(jointResults1, jointWlsResults, jointDlsResults, jointUlsResults))

# Compare ML and WLS estimates
round(cmp <- cbind(ML = coef(jointResults1), WLS = coef(jointWlsResults), DLS = coef(jointDlsResults), ULS = coef(jointUlsResults)), 3)

plot(cmp[1:5, 1], cmp[1:5, 2])
abline(0, 1)

rms(cmp)
omxCheckTrue(all(rms(cmp) < 0.03))

# Create and compare saturated models

jointModel2 <- mxModel("ContinuousOrdinalData",
	mxData(jointData, "raw"),
	satCov, means, thresh,
	mxFitFunctionML(),
	mxExpectationNormal("C", "M",
	dimnames = names(jointData),
	thresholds = "T",
	threshnames = c("z2", "z4", "z5"))
)

jointResults2 <- mxRun(jointModel2, suppressWarnings = TRUE)
summary(jointResults2)

ref <- mxRefModels(jointResults1, run=TRUE)

(sref <- summary(jointResults1, refModels=ref))

(shan <- summary(jointResults1, SaturatedLikelihood=-2*logLik(jointResults2), SaturatedDoF=summary(jointResults2)$degreesOfFreedom))

(swls <- summary(jointWlsResults))

# Simulate some data
x = rnorm(1000, mean = 0, sd = 1)
y= 0.5 * x + rnorm(1000, mean = 0, sd = 1)
tmpFrame <- data.frame(x, y);
cov(tmpFrame) # ~ .47
# Define and run x TO y and x WITH y model
m1 <- mxRun(mxModel(model = "xTOy",
	# Define the matrices
	mxMatrix(name = "S", type = "Full", nrow = 2, ncol = 2, values = c(1,0,0,1), free = c(T, F, F, T), labels = c("Vx", NA , NA, "Vy")),
	mxMatrix(name = "A", type = "Full", nrow = 2, ncol = 2, values = c(0,1,0,0), free = c(F, T, F, F), labels = c(NA  , "b", NA, NA)),
	mxMatrix(name = "I", type = "Iden", nrow = 2, ncol = 2),
	# Define the expectation
	mxAlgebra(name = "expCov", solve(I-A) %*% S %*% t(solve(I-A))),
	mxExpectationNormal("expCov", dimnames= names(tmpFrame)),
	mxFitFunctionWLS(),
	mxDataWLS(tmpFrame)
))

omxCheckCloseEnough(cov(tmpFrame)[2,1], coef(m1)["b"], .01)

m2 <- mxRun(mxModel(model = "xWITHy",
	# Define the matrices
	mxMatrix(name = "S", type = "Full", nrow = 2, ncol = 2, values = c(1,0,0,1), free = c(T, T, F, T), labels = c("Vx", "b" , NA, "Vy")),
	mxMatrix(name = "A", type = "Full", nrow = 2, ncol = 2, free=F, values = 0),
	mxMatrix(name = "I", type = "Iden", nrow = 2, ncol = 2),
	# Define the expectation
	mxAlgebra(name = "expCov", solve(I-A) %*% S %*% t(solve(I-A))),
	mxExpectationNormal("expCov", dimnames= names(tmpFrame)), mxFitFunctionWLS(),
	mxDataWLS(tmpFrame)
))

omxCheckCloseEnough(cov(tmpFrame)[2,1], coef(m2)["b"], .01)