}```splus
library("umx")
m1 <- mxModel("big", type= "RAM",
    latentVars = NULL,
    manifestVars = c("disp", "wt", "mpg"),
    mxPath(from = c("disp", "wt"), to = "mpg"),
    mxPath(from = "disp", to = "wt", arrows= 2),
    mxPath(from = c("disp", "wt", "mpg"), arrows = 2),
    mxPath(from = "one", to = c("disp", "wt", "mpg")),
    mxData(mtcars, type = "raw")
)
m1 = mxRun(m1)
summary(m1)

umxPath(v.m. = c("disp", "wt", "mpg")) # freely estimated
umxPath(v1m0 = "g") # fixed at variance of 1, mean = 0


library("umx")
m1 <- umxRAM("big", data = mxData(mtcars, type = "raw"),
    	umxPath(c("disp", "wt"), to = "mpg"),
    	umxPath("disp", with = "wt"),
    	umxPath(v.m. = c("disp", "wt", "mpg"))
)
umxSummary(m1, show = "std")

m2 = umxReRun(m1, update="disp_to_mpg", name="no_disp", comp=TRUE)

umxReRun(m1, update = "^disp_to.*", regex = TRUE)
```

ACE examples


```splus
require(umx)
data(twinData)
tmpTwin <- twinData
labList = c("MZFF", "MZMM", "DZFF", "DZMM", "DZOS")
tmpTwin$zyg = factor(tmpTwin$zyg, levels = 1:5, labels = labList)
selDVs = c("wt1", "wt2")
dz = tmpTwin[tmpTwin$zyg == "DZFF", selDVs]
mz = tmpTwin[tmpTwin$zyg == "MZFF", selDVs]


m1 = umxACE(selDVs = selDVs, dzData = dz, mzData = mz)
This model can be run:
m1 = mxRun(m1) # Run the model
and then plotted:
plot(m1) # output shown in

umxSummary(m1) # Create a tabular summary of the model
-2 × log(Likelihood) = 12186.28 (df=4)
Standardized solution
|    |    a1|c1 |    e1|
|:---|-----:|:--|-----:|
|wt1 | -0.92|.  | -0.39|


```
CP examples


```splus
require(umx)
data(twinData)
selDVs = c("ht", "wt")
varNames = umx_paste_names(selDVs, "", 1:2)
zygList = c("MZFF", "MZMM", "DZFF", "DZMM", "DZOS")
twinData$ZYG = factor(twinData$zyg, levels = 1:5, labels = zygList)
mzData = subset(twinData, ZYG == "MZFF", varNames)
dzData = subset(twinData, ZYG == "DZFF", varNames)

m1 = umxCP(selDVs = selDVs, dzData =dzData, mzData=mzData, suffix = "")
m1 = umxRun(m1)
umxSummary(m1)

```