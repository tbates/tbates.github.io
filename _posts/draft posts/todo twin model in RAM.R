library(OpenMx)
library(umx)
data(twinData)
Vars <- 'bmi'
nv   <- length(Vars)
ntv  <- nv * 2

selVars <- umx_paste_names(Vars, "", 1:2) 
t1ace = paste0(c("A", "C", "E"), 1, "_t1")
t2ace = paste0(c("A", "C", "E"), 1, "_t2")
aceVars <- c(t1ace, t2ace)
mzData <- subset(twinData, zyg == 1, selVars)
dzData <- subset(twinData, zyg == 3, selVars)

# Fit ACE Model with RawData and Path-Style Input
ACE <- mxModel("ACE", type = "RAM",
	umxPath(var   = aceVars, fixedAt = 1),
	umxPath(means = aceVars, fixedAt = 0 ),
	umxPath(means = selVars, values = 20, labels = "mean" ),
	umxPath(t1ace, to = "bmi1", values = .6, label = c("a","c","e")),
	umxPath(t2ace, to = "bmi2", values = .6, label = c("a","c","e")),
	umxPath("C1_t1", with = "C1_t2", fixedAt = 1)
)

m1 <- mxModel("ACEModel",	
    mxModel(ACE, name = "MZ", umxPath("A1_t1", with = "A1_t2", fixedAt =  1), mxData(mzData, type="raw" )),
    mxModel(ACE, name = "DZ", umxPath("A1_t1", with = "A1_t2", fixedAt = .5), mxData(dzData, type="raw" )),
    mxAlgebra(MZ.objective + DZ.objective, name = "minus2ll"),
    mxFitFunctionAlgebra("minus2ll")
)

m1 <- mxRun(m1)
plot(m1$MZ, showFixed = T)
plot(m1$DZ, showFixed = T)

summary(m1)
umxExpCov(m1)
# Generate ACE Output
# -----------------------------------------------------------------------
MZc <- mxEval(MZ.covariance, m1)
DZc <- mxEval(DZ.covariance, m1)
M <- mxEval(MZ.means, m1)
A <- mxEval(a*a, m1)
C <- mxEval(c*c, m1)
E <- mxEval(e*e, m1)
V <- (A+C+E)
a2 <- A/V
c2 <- C/V
e2 <- E/V
ACEest <- rbind(cbind(A,C,E),cbind(a2,c2,e2))
LL_ACE <- mxEval(objective, m1)


# Fit AE model
# -----------------------------------------------------------------------
AE <- mxModel(ACE, 
    mxPath( from=c("A1","C1","E1"), to="bmi1", arrows=1, free=c(T,F,T), values=c(.6,0,.6), label=c("a","c","e")),
    mxPath( from=c("A2","C2","E2"), to="bmi2", arrows=1, free=c(T,F,T), values=c(.6,0,.6), label=c("a","c","e"))
)
pathAEModel <- mxModel("pathAEModel",	
    mxModel(AE, name="MZ",
        mxPath( from="A1", to="A2", arrows=2, free=FALSE, values=1 ),
        mxData( observed=mzData, type="raw" )
    ),
    mxModel(AE, name="DZ", 
        mxPath( from="A1", to="A2", arrows=2, free=FALSE, values=.5 ),
        mxData( observed=dzData, type="raw" )
    ),
    mxAlgebra( expression=MZ.objective + DZ.objective, name="-2sumll" ),
    mxAlgebraObjective("-2sumll")
)

pathAEFit <- mxRun(pathAEModel)
pathAESumm <- summary(pathAEFit)

# Generate AE Output
# -----------------------------------------------------------------------
MZc <- mxEval(MZ.covariance, pathAEFit)
DZc <- mxEval(DZ.covariance, pathAEFit)
M <- mxEval(MZ.means, pathAEFit)
A <- mxEval(a*a, pathAEFit)
C <- mxEval(c*c, pathAEFit)
E <- mxEval(e*e, pathAEFit)
V <- (A+C+E)
a2 <- A/V
c2 <- C/V
e2 <- E/V
AEest <- rbind(cbind(A, C, E),cbind(a2, c2, e2))
LL_AE <- mxEval(objective, pathAEFit)

LRT_ACE_AE <- LL_AE - LL_ACE


# Print relevant output
# -----------------------------------------------------------------------
ACEest
AEest
LRT_ACE_AE