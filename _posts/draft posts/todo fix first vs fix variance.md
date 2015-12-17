```splus
library("OpenMx")
library("umx")
data(HolzingerSwineford1939, package="lavaan")
manifests = paste0("x", 1:9) # "x1" "x2" "x3" "x4" "x5" "x6" "x7" "x8" "x9"
latents = c("visual", "textual", "speed")
```
First, fixing first loadings to 1

```splus
m1_Open <- umxRAM("HS_model", data = HolzingerSwineford1939,
	umxPath(latents[1], to = manifests[1:3], firstAt = 1),
	umxPath(latents[2], to = manifests[4:6], firstAt = 1),
	umxPath(latents[3], to = manifests[7:9], firstAt = 1),
	umxPath(unique.bivariate = latents),
	umxPath(var = c(latents, manifests)),
	umxPath(means = manifests),
	umxPath(means = latents, fixedAt = 0)
)
m1_Open = mxRun(m1_Open)
mxStandardizeRAMpaths(m1_Open)
save("m1_Open", file="m1_Open.rda")
system(paste("open ",shQuote(getwd(), type = "csh")))

```
Next, fixing the latent variance at 1 (and mean at 0)

```splus
m1_Open <- umxRAM("HS_model", data = HolzingerSwineford1939,
	umxPath(latents[1], to = manifests[1:3]),
	umxPath(latents[2], to = manifests[4:6]),
	umxPath(latents[3], to = manifests[7:9]),
	umxPath(unique.bivariate = latents),
	# Plus the means and variances for the manifests and latents that lavaan does black box for you in cfa
	umxPath(var   = manifests),
	umxPath(means = manifests),
	# umxPath(varsAndMeans = manifests),
	umxPath(v1m0  = latents)
)
m1_Open = mxRun(m1_Open)
mxStandardizeRAMpaths(m1_Open)

```

A simple multiple regression

```splus
names(mtcars)
y  = "mpg";
xs = c("cyl", "disp")                
manifests  = c(y,xs)
m1 <- umxRAM("y_tilde_sx", data = mtcars,
	umxPath(xs, to = y),
	umxPath(cov = xs),
	umxPath(var   = manifests),
	umxPath(means = manifests)
)
m1 = mxRun(m1)
mxStandardizeRAMpaths(m1)
plot(m1)

```
