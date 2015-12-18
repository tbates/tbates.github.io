# Create and estimate a factor model
require(OpenMx)
manifests = c("mpg", "cyl", "disp", "hp", "wt")
df = umx_scale(mtcars[, manifests])
latents   = c("G", "big")
m2 <- umxRAM("twoF", data = mxData(df, type="raw"),
	umxPath("G", to = manifests),
	umxPath("big", to = c("hp", "wt", "cyl")),
	umxPath(v.m. = manifests),
	umxPath(v1m0 = latents),
	umxPath(means=manifests)
)

latents   = c("G")
df[1,"wt"] = NA # add missing value for subject 1 weight
m1 <- umxRAM("one", data = mxData(df, type="raw"),
	umxPath("G", to = manifests),
	umxPath(cov = c("hp", "wt")),
	umxPath(cov = c("cyl", "wt")),
	umxPath(v.m. = manifests),
	umxPath(v1m0 = latents),
	umxPath(means = manifests)
)
umxCompare(m2, m1)
plot(m2, showM = F)
plot(m1, showM = F)

# Estimate factor scores for the model
r1 <- mxFactorScores(m1, 'WeightedML')
r2 <- mxFactorScores(m2, 'WeightedML')
# output is [nrow, nfac, c("score", "se")]
# so only need r2 = r2[ , , 1] # need drop= FALSE if only 1 factor



values <- data.frame(value = c(rep("a", 5), rep("b", 4), rep("c", 3)))
aggregate(value ~ factor(value), data = values, FUN = length)
aggregate(values, by = list(unique.values = values$value), FUN = length)

# Create and estimate a factor model
require(OpenMx)
data(demoOneFactor)
manifests = names(demoOneFactor)
latents   = c("G")
m1 <- umxRAM("test", data = mxData(demoOneFactor, type="raw"),
	umxPath(latents, to = manifests),
	umxPath(v.m. = manifests),
	umxPath(v1m0 = latents),
	umxPath(means=manifests)
)
summary(m1)
plot(m1)
# Swap in raw data in place of summary data
m1 <- mxModel(m1, mxData(demoOneFactor[1:50,], type="raw"))

							   
