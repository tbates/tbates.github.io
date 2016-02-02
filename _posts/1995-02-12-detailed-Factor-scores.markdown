---
layout: post
title: "Ordinal variables in RAM models"
date: 1995-02-12 00:00
comments: true
categories: advanced
---

#### This page is not finished. When done it will explain using umx to help with ordinal variables in RAM models

# A simple one factor ordinal model

```splus
require(OpenMx)    
```
	
### Create a dataframe of three ordinal variables

```splus
data(myFADataRaw)
df <- myFADataRaw[,c("z1", "z2", "z3")]
df$z1 <- mxFactor(df$z1, levels = c(0, 1))
df$z2 <- mxFactor(df$z2, levels = c(0, 1))
df$z3 <- mxFactor(df$z3, levels = c(0, 1, 2))    
str(df)
```

Now we have a 500 observation dataframe of 3 variables, each of which is factor:

| Var | Ordinal?              | levels      | head()                  |
|:---|:-----------------------|:------------|:------------------------|
| z1 | Ord.factor w/ 2 levels | "0"<"1"     | 2 2 2 2 2 2 2 2 2 1 ... |
| z2 | Ord.factor w/ 2 levels | "0"<"1"     | 1 1 2 1 1 1 1 1 1 2 ... |
| z3 | Ord.factor w/ 3 levels | "0"<"1"<"2" | 1 2 2 1 2 2 1 2 1 1 ... |

### Making a model with ordinal variables

```splus
m1 <- umxRAM("Common_Factor_Model", data = mxData(df, type = "raw"), 
	umxPath(var = c("z1","z2","z3"), fixedAt = 1), # latent variance
	umxPath(var = "F1", values = 1, labels = "varF1"), # factor loadings
	umxPath(from="F1", to = c("z1","z2","z3"), firstAt = 1), # means
	umxPath(means= c("z1","z2","z3","F1"), fixedAt = 0), # thresholds
	mxThreshold(vars=c("z1", "z2", "z3"), nThresh = c(1,1,2), free = T, values = c(-1, 0, -.5, 1.2))
)

m1 <- mxRun(m1)    
plot(m1)
```
