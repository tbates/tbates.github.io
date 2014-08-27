Any side-effects of joint ordinal fix?
build r3752
build r3717 
make test

require(OpenMx)
data(demoOneFactor)
latents   = c("G")
manifests = names(demoOneFactor)
 
# =============================
# = 1. Make two simple models =
# =============================
m1 <- mxRAM("model1", data = mxData(cov(demoOneFactor), type = "cov", numObs = 500),
	mxPath(from = latents, to = manifests),
	umxPath(var = manifests),
	umxPath(var = latents, fixedAt = 1.0)
)
 
m2 <- m1
m2 <- mxRename(m2, "model2")
 
# ===================================================
# = 2. Nest them in a multigroup supermodel and run =
# ===================================================
 
m3 = mxModel("bob", m1, m2, mxFitFunctionMultigroup(c("model1", "model2")) )
m3 = mxRun(m3)
x = omxSaturatedModel(m3)

# =====================================
# = Ordinal with definition variables =
# =====================================

library(OpenMx)
N <- 2000
set.seed(4321)
u <- rbinom(N, 1, .5)
x <- .5 * u + rnorm(N)
y <- mxFactor( rbinom(N, 1, pnorm(-2 + u)) , levels = c(0, 1) )
myData = data.frame(x, y, u)

model <- mxModel('BinCont',     
  mxMatrix(name = 'Betas' , 'Full', nrow = 1, ncol = 2, free = T), 
  mxMatrix(name = 'U'     , 'Full', nrow = 1, ncol = 1, free = F, label = 'data.u'), 
  mxMatrix(name = 'Means' , 'Full', nrow = 1, ncol = 2, free = c(T, F)), 
  mxAlgebra(name = 'eMean', Means + Betas %x% U, dimnames = list(NULL, c('x','y'))),
  mxMatrix(name = 'Cov'   , 'Symm', nrow = 2, ncol = 2, free = c(T, T, F), values = c(1, 0, 1), dimnames = list(c('x','y'), c('x','y'))), 
  mxMatrix(name = 'Thresh', 'Full', nrow = 1, ncol = 1, free = T, dimnames = list(NULL, 'y')), 
  mxExpectationNormal(covariance = 'Cov', means = 'eMean', thresholds = 'Thresh'), 
  mxFitFunctionML(),
  mxData(myData, type = 'raw')
)

umx_set_cores(1)
n = mxRun(m); m@output$estimate[1:2]; umx_get_time(n)
umx_set_cores(2)
n = mxRun(m); m@output$estimate[1:2]; umx_get_time(n)
umx_set_cores(3)
n = mxRun(m); m@output$estimate[1:2]; umx_get_time(n)
umx_set_cores(4)
n = mxRun(m); m@output$estimate[1:2]; umx_get_time(n)
summary(n)