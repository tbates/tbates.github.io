model1 <- '
f1 =~ x1 + x2 + x3
x1 ~~ var1*x1
x2 ~~ var2*x2
x3 ~~ var3*x3
var1 > 0
var1 < 1
var2 > 0
var2 < 0.5
var3 > 0
var3 < 1.5
'
fit <- cfa(model1, HolzingerSwineford1939)