---
layout: post
title: "umxRAM with Ordinal Data"

comments: true
categories: advanced
---

This post covers using `umxRAM` with ordinal data. It's all pretty transparent: The key is that `uxmRAM` knows variables are ordinal based on their type in the data.frame type.

So: let's first of all make a dataframe with three ordinal variable:

	
### Create a dataframe of three ordinal variables

```r
require(umx)

data(myFADataRaw)
df = myFADataRaw[,c("z1", "z2", "z3")]
df$z1 = mxFactor(df$z1, levels = c(0, 1))
df$z2 = mxFactor(df$z2, levels = c(0, 1))
df$z3 = mxFactor(df$z3, levels = c(0, 1, 2))    
str(df)
```

Now we have a 500 observation dataframe of 3 variables, each of which is an ordinal factor:

| Var | Ordinal?              | levels      | head()                  |
|:---|:-----------------------|:------------|:------------------------|
| z1 | Ord.factor w/ 2 levels | "0"<"1"     | 2 2 2 2 2 2 2 2 2 1 ... |
| z2 | Ord.factor w/ 2 levels | "0"<"1"     | 1 1 2 1 1 1 1 1 1 2 ... |
| z3 | Ord.factor w/ 3 levels | "0"<"1"<"2" | 1 2 2 1 2 2 1 2 1 1 ... |

### Making a model with ordinal variables

Once the variables are typed correctly, umxRAM can figure out which ones to model (using the threshold liability model) as ordinal:

So the model is exactly as you would use for continuous data:

```r
m1 = umxRAM("Common_Factor_Model", data = df,
	umxPath(var = c("z1","z2","z3"), fixedAt = 1), # latent variance
	umxPath(var = "F1", values = 1, labels = "varF1"), # factor loadings
	umxPath(from="F1", to = c("z1","z2","z3"), firstAt = 1), # means
	umxPath(means= c("z1","z2","z3","F1"), fixedAt = 0) # thresholds
)

plot(m1)
```

|name       | Estimate|    SE|
|:----------|--------:|-----:|
|F1_to_z1   |    1.000| 0.000|
|F1_to_z2   |    1.350| 0.877|
|F1_to_z3   |    0.556| 0.168|
|z1_with_z1 |    1.000| 0.000|
|z2_with_z2 |    1.000| 0.000|
|z3_with_z3 |    1.000| 0.000|
|varF1      |    1.759| 1.068|

χ²(2) = 50.2, p < 0.001; CFI = 0.797; TLI = 0.695; RMSEA = 0.22
