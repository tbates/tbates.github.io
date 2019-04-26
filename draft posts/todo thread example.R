# source("https://openmx.ssri.psu.edu/getOpenMxBeta.R")

devtools::document("~/bin/umx"); devtools::install("~/bin/umx");
library(umx)
mxVersion()
data(demoOneFactor)  

latents <- c("G")  
manifests <- names(demoOneFactor) # x1-5
model <- umxRAM("OneFactor", data = mxData(demoOneFactor, type = "raw"),
    umxPath(latents, to = manifests, labels = paste0("b", 1:5)),
    umxPath(means = manifests),
    umxPath(var   = manifests, labels = paste0("u", 1:5)),
    umxPath(v1m0 = latents)
)
umx_set_cores(1)
m1 <- mxRun(model) 
umx_time(m1) # 1.49 secs

# ======================
# = Run with 4 threads =
# ======================
umx_set_cores(4)
m1 <- mxRun(model) 
umx_time(m1) # same as with 1...

# ======================
# = CIs are threadable =
# ======================
m1 = confint(model, run = TRUE)
umx_time(m1) # 

# =====================
# = Run with 1 thread =
# =====================
umx_set_cores(1)
m1 = confint(model, run = T)
umx_time(m1) # 

summary(model)

omxDetectCores() # cores available
umx_get_cores()