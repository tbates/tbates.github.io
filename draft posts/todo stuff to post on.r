# require(MASS)
# data(birthwt)
# # compute CIs for correlation between mother's weight and birth weight
# cor.boot <- function(data, k) cor(data[k,])[1,2]
# cor.res <- boot(data = with(birthwt, cbind(lwt, bwt)), statistic=cor.boot, R=500)
# cor.res
# boot.ci(cor.res, type="bca")
# 
# # compute CI for a particular regression coefficient, e.g. bwt ~ smoke + ht
# fm <- bwt ~ smoke + ht
# reg.boot <- function(formula, data, k) coef(lm(formula, data[k,]))
# reg.res <- boot(data=birthwt, statistic=reg.boot, 
#                 R=500, formula=fm)
# boot.ci(reg.res, type="bca", index=2) # smoke

# renameFile(findStr="_", replaceStr=" ", listPattern = "", test=T)

# psych::r.test will test for the difference between independent or dependent correlations
# psych::r.test(n = 100, r12 = .5, r34 = .4, ) 
# z value 0.82    with probability  0.41 

# Inference on second-order quantities, such as correlation coefficients and variances, is not robust to the assumption of a normally-distributed population.
# a good alternative is the bootstrap, implemented in R in the boot package."

# GbyEwrapper <- function(DVs, Defs, twinData, nSib=nSib) {
# 	# GbyEwrapper(DVs="IQ_ResidAGE", Defs="ChildhoodSEI", twinData, nSib=nSib)
# 	selDVs = c(paste(DVs,"_T1", sep=""), paste(DVs,"_T2", sep=""))
# 	selDefs = c(paste(Defs,"_T1", sep=""), paste(Defs,"_T2", sep=""))
# 	selVars = c(selDVs, selDefs)
# 	mzData  = subset(twinData, zyg=="MONOZYGOTIC", selVars) # MZs
# 	dzData  = subset(twinData, zyg=="DIZYGOTIC - DIFFERENT SEX" | zyg=="DIZYGOTIC - SAME SEX", selVars) # same and OS Sex DZs
# 	# Exclude cases with missing Def
# 	# Average for the two twins?
# 	mzData <- mzData[!is.na(mzData[selDefs[1]]) & !is.na(mzData[selDefs[2]]),]
# 	dzData <- dzData[!is.na(dzData[selDefs[1]]) & !is.na(dzData[selDefs[2]]),]
# 	return(two_group_G_by_E(selDVs=selDVs, selDefs=selDefs, dzData=dzData, mzData=mzData, nSib=nSib))
# }

# ACEwrapper <- function(DVs, twinData, nSib=nSib) {
# 	# ACEwrapper(DVs="IQ_ResidAGE", twinData, nSib=nSib)
# 	selDVs = c(paste(DVs,"_T1", sep=""), paste(DVs,"_T2", sep=""))
# 	selVars = c(selDVs)
# 	mzData  = subset(twinData, zyg=="MONOZYGOTIC", selVars) # MZs
# 	dzData  = subset(twinData, zyg=="DIZYGOTIC - DIFFERENT SEX" | zyg=="DIZYGOTIC - SAME SEX", selVars) # same and OS Sex DZs
# 	return(twoGroupCholesky("ACE", selDVs, dzData, mzData, nSib))
# }
