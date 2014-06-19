---
layout: post
title: "Get more confidence, easily!"
date: 2020-02-15 00:00
comments: true
categories: models tutorial
---

We just looked at CIs and SE. Simplistically, these are related as CI = est ± 1.96 × SE, but we saw this is not accurate. The CIs can be asymmetric. So if you are using SE to generate confidence intervals, you are wrong, and will often give misleading results incompatible, with the outcome from mxCompare().

i.e., you will publish a 95% CI which excludes zero, but a likelihood comparison would indicate the effect is not significant, and mxCI would confirm this.

Comparison to Lavaan

Lavaan's [inspect](http://lavaan.ugent.be/tutorial/inspect.html) page shows how to access results from models.

As with OpenMx/umx, we have coef()

```splus
library(lavaan)
?HolzingerSwineford1939
HS.model <- " visual  =~ x1 + x2 + x3 
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9"
m1_Lav <- cfa(HS.model, data = HolzingerSwineford1939)
```

Now in OpenMx/umx

```splus
library("OpenMx")
library("umx")

manifests = paste0("x", 1:9) # "x1" "x2" "x3" "x4" "x5" "x6" "x7" "x8" "x9"
latents = c("visual", "textual", "speed")

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
x = mxStandardizeRAMpaths(m1_Open, SE= T)
umx_round(x[,c(2,6:8)], 3)
# ours are a lot tighter!
```

Now let's compare the results. First, Lavaan

```splus
    
# lavaan
# parameterEstimates(m1_Lav)
standardizedSolution(m1_Lav)
```


|    | lhs     | op | rhs     | est   | se    | z      | pvalue | ci.lower | ci.upper |
|:---|:--------|:---|:--------|:------|:------|:-------|:-------|:---------|:---------|
| 1  | visual  | =~ | x1      | 1.000 | 0.000 | NA     | NA     | 1.000    | 1.000    |
| 2  | visual  | =~ | x2      | 0.553 | 0.100 | 5.554  | 0      | 0.358    | 0.749    |
| 3  | visual  | =~ | x3      | 0.729 | 0.109 | 6.685  | 0      | 0.516    | 0.943    |
| 4  | textual | =~ | x4      | 1.000 | 0.000 | NA     | NA     | 1.000    | 1.000    |
| 5  | textual | =~ | x5      | 1.113 | 0.065 | 17.014 | 0      | 0.985    | 1.241    |
| 6  | textual | =~ | x6      | 0.926 | 0.055 | 16.703 | 0      | 0.817    | 1.035    |
| 7  | speed   | =~ | x7      | 1.000 | 0.000 | NA     | NA     | 1.000    | 1.000    |
| 8  | speed   | =~ | x8      | 1.180 | 0.165 | 7.152  | 0      | 0.857    | 1.503    |
| 9  | speed   | =~ | x9      | 1.082 | 0.151 | 7.155  | 0      | 0.785    | 1.378    |
| 10 | x1      | ~~ | x1      | 0.549 | 0.114 | 4.833  | 0      | 0.326    | 0.772    |
| 11 | x2      | ~~ | x2      | 1.134 | 0.102 | 11.146 | 0      | 0.934    | 1.333    |
| 12 | x3      | ~~ | x3      | 0.844 | 0.091 | 9.317  | 0      | 0.667    | 1.022    |
| 13 | x4      | ~~ | x4      | 0.371 | 0.048 | 7.779  | 0      | 0.278    | 0.465    |
| 14 | x5      | ~~ | x5      | 0.446 | 0.058 | 7.642  | 0      | 0.332    | 0.561    |
| 15 | x6      | ~~ | x6      | 0.356 | 0.043 | 8.277  | 0      | 0.272    | 0.441    |
| 16 | x7      | ~~ | x7      | 0.799 | 0.081 | 9.823  | 0      | 0.640    | 0.959    |
| 17 | x8      | ~~ | x8      | 0.488 | 0.074 | 6.573  | 0      | 0.342    | 0.633    |
| 18 | x9      | ~~ | x9      | 0.566 | 0.071 | 8.003  | 0      | 0.427    | 0.705    |
| 19 | visual  | ~~ | visual  | 0.809 | 0.145 | 5.564  | 0      | 0.524    | 1.094    |
| 20 | textual | ~~ | textual | 0.979 | 0.112 | 8.737  | 0      | 0.760    | 1.199    |
| 21 | speed   | ~~ | speed   | 0.384 | 0.086 | 4.451  | 0      | 0.215    | 0.553    |
| 22 | visual  | ~~ | textual | 0.408 | 0.074 | 5.552  | 0      | 0.264    | 0.552    |
| 23 | visual  | ~~ | speed   | 0.262 | 0.056 | 4.660  | 0      | 0.152    | 0.373    |
| 24 | textual | ~~ | speed   | 0.173 | 0.049 | 3.518  | 0      | 0.077    | 0.270    |


