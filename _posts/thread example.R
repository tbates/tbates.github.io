df <- read.table(pipe("pbpaste"), header = T, sep = "\t", as.is = c(T))

source("http://openmx.psyc.virginia.edu/getOpenMxBeta.R")
library("OpenMx")
mxVersion()
devtools::document("~/bin/umx"); devtools::install("~/bin/umx");
library(umx)
data(demoOneFactor)  

latents   <- c("G")  
manifests <- names(demoOneFactor) 
model <- umxRAM("OneFactor", mxData(demoOneFactor, type="raw"),
    umxPath(latents, to = manifests, labels = paste0("b", 1:5)),
    umxPath(var   = manifests, labels = paste0("u", 1:5)),
    umxPath(means = manifests),
    umxPath(v1m0 = latents)
)
model <- mxRun(model) 
umx_report_time(model) #.398
mxOption(model= model, key="Number of Threads")

# ======================
# = run with 2 threads =
# ======================
model = mxOption(model= model, key="Number of Threads", value= 2)
m1 = confint(model, run = T)
umx_report_time(m1) # 13.455

# =====================
# = run with 1 thread =
# =====================
model = mxOption(model= model, key="Number of Threads", value= 1)
m1 = confint(model, run = T)
umx_report_time(m1) # 12.839

summary(model)

omxDetectCores() # cores available
umx_get_cores()