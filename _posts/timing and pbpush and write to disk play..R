# curl -s http://r.research.att.com/libs/gfortran-4.8.2-darwin13.tar.bz2 | sudo tar fxj - -C /
# [pushbullet code](lBCuYBWKwAt6m3aAXF6S3Htw32X0L9hD)
# http://www.r-bloggers.com/notifications-from-r/
# http://www.sumsar.net/blog/2014/05/jeffreys-substitution-posterior/
# [16 cores = 70c/hr](https://console.developers.google.com/project/51598099211/settings)
# [responsive-web-design](http://learn.shayhowe.com/advanced-html-css/responsive-web-design)
# http://stateofobesity.org/
# http://www.statslife.org.uk/significance/world-affairs/1756-the-scottish-referendum-maybe-yes-maybe-no
# https://www.wiki.ed.ac.uk/display/ecdfwiki/Quickstart
# https://feedly.com/index.html#subscription%2Ffeed%2Fhttp%3A%2F%2Fwww.culturalcognition.net%2Fblog%2Fatom.xml
# BLUP stuff
# http://www.extension.org/pages/61006/estimating-heritability-and-blups-for-traits-using-tomato-phenotypic-data#.Ui4zjWRgYXc
# http://www.extension.org/pages/68019/genomic-relationships-and-gblup
# http://www.extension.org/pages/66590/rrblup-package-in-r-for-genomewide-selection
# [Roberts still a dick?](http://www.proexam.org/index.php/center-for-innovative-assessments)
# [cmd line R wihtout using up your console..](http://dirk.eddelbuettel.com/code/littler.examples.html)



#  OpenMx Ordinal Data Example
#  Revision history:
#  	Michael Neale 14 Aug 2010
#  	Bates 19 Aug 2014 (mucking around)

# ==========================
# = Step 1: load libraries =
# ==========================
require(OpenMx)
require(MASS)
isIdentified <- function(nVariables,nFactors) {
	as.logical(1+sign((nVariables*(nVariables-1)/2) -  nVariables*nFactors + nFactors*(nFactors-1)/2))
}

# devtools::document("~/bin/umx.twin"); devtools::install("~/bin/umx.twin");
devtools::document("~/bin/umx"); devtools::install("~/bin/umx"); 

# Set up cores, checkpoint, and wd
setwd("~/Dropbox/shared folders/OpenMx_binaries/Agenda/2014.08.22 attachments")
umx_set_cores(omxDetectCores())
umx_set_checkpoint(count = 1, units = "evaluations", directory = getwd(), model = NULL)

# Here is an example, based on one in models/nightly, 
# NPSOL takes X evaluations, whereas CSOLNP takes X
# Answers are approximately the same, with NPSOL finding a slightly X minimum.
# Wall clock time is only about double with CSOLNP, which looks like a different ratio.  Any thoughts on algorithm?

# =========================================
# = Step 2: set up simulation parameters  =
# =========================================
# Note: nVariables>=3, nThresholds>=1, nSubjects>=nVariables*nThresholds (maybe more)
# and model should be identified

nVariables  <- 8
nFactors    <- 1
nThresholds <- 3
nSubjects   <- 500

# if this function returns FALSE then model is not identified, otherwise it is.
isIdentified(nVariables,nFactors)

loadings  <- matrix(.7, nrow = nVariables, ncol = nFactors)
residuals <- 1 - (loadings * loadings)
sigma     <- loadings %*% t(loadings) + vec2diag(residuals)
mu        <- matrix(0, nrow = nVariables, ncol = 1)

# ===================================================
# = Step 3: load simulated multivariate normal data =
# ===================================================
# created using
# set.seed(1234)
# continuousData <- mvrnorm(n = nSubjects, mu, sigma)
# save("continuousData", file="continuousData.rda")
load("continuousData.rda") 

# ========================================================
# = Step 4: chop continuous variables into ordinal data  =
# ========================================================
# (nThresholds + 1) approximately-equal categories, based on 1st variable
quants <- quantile(continuousData[,1],  probs = c((1:nThresholds)/(nThresholds+1)))
ordinalData <- matrix(0,nrow=nSubjects,ncol=nVariables)
for(i in 1:nVariables) {
	ordinalData[,i] <- cut(as.vector(continuousData[,i]),c(-Inf,quants,Inf))
}

# =====================================================
# = Step 5: make the ordinal variables into R factors =
# =====================================================
ordinalData <- mxFactor(as.data.frame(ordinalData),levels=c(1,2,3,4))

# Step 6: name the variables
varNames <- paste0("banana", 1:nVariables) # "banana1" "banana2" "banana3"
names(ordinalData) <- varNames


# ===================
# = Make the mmodel =
# ===================

baseModel <- mxModel("NPSOL",
    mxMatrix(name="L", "Full", nVariables, nFactors, values=0.2, free=TRUE, lbound=c(0,rep(-.99,nVariables-1)), ubound=.99),
    mxMatrix(name="vectorofOnes", "Unit", nVariables, 1),
    mxMatrix(name="Means", "Zero", 1, nVariables, dimnames = list(c(), varNames) ),
    mxAlgebra(name="E", vectorofOnes - (diag2vec(L %*% t(L)))),
    mxAlgebra(name="impliedCovs", L %*% t(L) + vec2diag(E)),
    mxMatrix(name = "thresholdDeviations", "Full", 
            nrow    = nThresholds, ncol = nVariables,
            values  = .2, free = TRUE, 
            lbound  = rep( c(-Inf,rep(.01,(nThresholds-1))) , nVariables),
            dimnames = list(c(), varNames)
	),
    mxMatrix(name = "unitLower", "Lower", nThresholds, nThresholds, values = 1, free = F), 
    mxAlgebra(name="thresholdMatrix", unitLower %*% thresholdDeviations),
	mxExpectationNormal("impliedCovs", means = "Means", dimnames = varNames, thresholds = "thresholdMatrix"),
	mxFitFunctionML(),
	mxData(ordinalData, type='raw')
)

# ============================================
# = Iterate over available engines and cores =
# ============================================

optimizerList = c("CSOLNP", "NPSOL")
threads = 1:4
# optimizerList = "NPSOL"; threads = 4
for (opt in optimizerList) {	
	mxOption(NULL, "Default optimizer", opt)
	for (i in threads) {
		mxOption(NULL, "Number of Threads", i)
		afterRun <- mxRun(mxModel(baseModel, name = opt))
		x = summary(afterRun)
		if(opt == "CSOLNP"){
			est = dim(estsCSOLNP)
		} else {
			est = dim(estsNPSOL)
		}
		print(paste0(i, " cores took ", round(x$wallTime, 2), "secs (", est[1], " estimates) using ", opt))
	}
}

# [1] "4 cores took 252.75secs (1648 estimates) using CSOLNP"
# [1] "4 cores took 280.01secs (2107 estimates) using NPSOL"