Davidai, S., & Gilovich, T. (2015). Building a more mobile America – one income quintile at a time. Perspectives on Psychological Science. 
Hackman, D., & Farah, M. (2009). Socioeconomic status and the developing brain. Trends in Cognitive Sciences.
Jones, O. (2011). Chavs: The demonization of the working class. Verso Books. 
Kraus, M., et al (2012). Social class, solipsism, and contextualism: How the rich are different from the poor. Psychological Review. 
Stephens, N., et al (2014). Social class culture cycles: How three gateway contexts shape selves and fuel inequality. Annual Review of Psychology. 
Wilkinson, R., & Pickett, K. (2009). The Spirit Level: Why more equal societies almost always do better. Allen Lane, London. 

library(umx)
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