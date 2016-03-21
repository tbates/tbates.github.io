rotation="promax", varimax

```splus
vars = c("mpg", "disp", "hp", "wt", "qsec")

factanal(~ mpg + disp + hp + wt + qsec, factors = 2, rotation="promax"data = mtcars)
#      Factor1 Factor2
# mpg  -0.851   0.345
# disp  0.871  -0.356
# hp    0.621  -0.701
# wt    0.996
# qsec -0.123   0.906

m2 = umxEFA(name= "test", factors =   2, data = mtcars[, vars])
x = mxStandardizeRAMpaths(m2, SE=T)
x[,c(2,8,9)]

manifests <- names(data)
m1 <- umxRAM(model = name, data = data, autoRun = FALSE,
	umxPath(factors, to = manifests, connect = "unique.bivariate"),
	umxPath(v.m. = manifests),
	umxPath(v1m0 = factors, fixedAt = 1)
)

# loadings matrix is just:
load = m2$A$values[manifests, latents]

if rotation == "varimax"){
	load = varimax(load, normalize = TRUE, eps = 1e-5))
} else if (roations == "promax"){
	load = promax(load, m = 4)
}

m2$A$values[manifests, latents] = load


require(umx)
data(demoOneFactor)
latents   = c("g", "f")
manifests = names(demoOneFactor)
myData    = mxData(cov(demoOneFactor), type = "cov", numObs = 500)
m1 <- umxRAM("f", data = myData,
	umxPath(latents, to = manifests, connect="unique.bivariate"),
	umxPath(var = manifests),
	umxPath(var = latents, fixedAt = 1)
)
plot(m1)

```