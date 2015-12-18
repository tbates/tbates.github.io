# SAS Standard
# --------Path--------    Parameter      Estimate         Error       t Value
# x1      <---    G       theta1          0.89131       0.00972      91.71064
# x2      <---    G       theta2          0.93255       0.00640     145.61568
# x3      <---    G       theta3          0.94385       0.00549     171.97748
# x4      <---    G       theta4          0.96236       0.00402     239.10944
# x5      <---    G       theta5          0.97256       0.00328     296.56341

# Lavaan
library("lavaan")
fit <- cfa('f =~ x1 + x2 + x3 + x4 + x5', data = demoOneFactor)
standardizedSolution(fit)
#    lhs op rhs est.std    se      z pvalue
# 1    f =~  x1   0.891    NA     NA     NA
# 2    f =~  x2   0.933 0.027 34.537      0
# 3    f =~  x3   0.944 0.026 35.743      0
# 4    f =~  x4   0.962 0.025 37.899      0
# 5    f =~  x5   0.973 0.025 39.177      0
# 6   x1 ~~  x1   0.206 0.014 14.535      0
# 7   x2 ~~  x2   0.130 0.010 13.578      0
# 8   x3 ~~  x3   0.109 0.008 13.059      0
# 9   x4 ~~  x4   0.074 0.006 11.494      0
# 10  x5 ~~  x5   0.054 0.005  9.858      0
# 11   f ~~   f   1.000 0.078 12.784      0

# OpenMx
require(OpenMx)
data(demoOneFactor)
manifests = names(demoOneFactor)
m1 <- mxModel("One Factor", type = "RAM", 
	manifestVars = manifests, latentVars = "G", 
	mxPath(from = "G", to = manifests),
	mxPath(from = manifests, arrows = 2),
	mxPath(from = "G", arrows = 2, free = F, values = 1.0),
	mxData(cov(demoOneFactor), type = "cov", numObs = 500)
)
m1 = umxRun(m1, setLabels = T, setValues = T)
umxSummary(m1, show = "std")	   
 #          name Std.Estimate Std.SE                CI
 # 1     G_to_x1        0.891 0.0349 0.89 [0.82, 0.96]
 # 2     G_to_x2        0.933 0.0338    0.93 [0.87, 1]
 # 3     G_to_x3        0.944 0.0334 0.94 [0.88, 1.01]
 # 4     G_to_x4        0.962 0.0329  0.96 [0.9, 1.03]
 # 5     G_to_x5        0.973 0.0326 0.97 [0.91, 1.04]
 # 6  x1_with_x1        0.206 0.0142 0.21 [0.18, 0.23]
 # 7  x2_with_x2        0.130 0.0096 0.13 [0.11, 0.15]
 # 8  x3_with_x3        0.109 0.0084 0.11 [0.09, 0.13]
 # 9  x4_with_x4        0.074 0.0064 0.07 [0.06, 0.09]
 # 10 x5_with_x5        0.054 0.0055 0.05 [0.04, 0.06]
