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

# Define the model
m1 <- mxModel(model="exampleModel",
	# Define the matrices
	mxMatrix(type = "Full", nrow = 2, ncol = 2, values = c(1,0,0,1), free = c(TRUE, FALSE, FALSE, TRUE), labels =c ("Vx", NA, NA, "Vy"), name = "S"),
	mxMatrix(type = "Full", nrow = 2, ncol = 2, values = c(0,1,0,0), free = c(FALSE, TRUE, FALSE, FALSE), labels = c(NA, "b", NA, NA), name = "A"),
	mxMatrix(type = "Iden", nrow = 2, ncol = 2, name = "I"),
	# Define the expectation
	mxAlgebra(solve(I-A) %*% S %*% t(solve(I-A)), name = "expCov"),
	mxExpectationNormal("expCov", dimnames= names(tmpFrame)),
	mxFitFunctionWLS(),
	mxDataWLS(tmpFrame)
)
# Fit the model and print a summary
m1 <- mxRun(m1)
summary(m1)