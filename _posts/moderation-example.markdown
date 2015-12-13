# http://offbeat.group.shef.ac.uk/FIO/model1a.htm
```splus
    

# Predictor variable - X 
# Mediator variable(s) – (not applicable) 
# Moderator variable(s) - W 
# Outcome variable - Y

require(umx)
myCov = matrix(nrow = 2, ncol = 2, byrow = T, c(
1.0, .2,
.2, 1.0));
n = 100
df = MASS::mvrnorm (n = n, mu = c(0,0), Sigma = myCov);
df = data.frame(df);  names(df) <- c("X", "W");

df$XW = df$X * df$W
df$Y = df$XW + rnorm(n)
summaryAPA(df)
# In model statement name each path and intercept using parentheses
[Y] (b0); 
  Y ON X (b1); 
  Y ON W (b2); 
  Y ON XW (b3);
	
m1 <- umxRAM("moderated", data = df,
	umxPath(v.m. = c("X", "W", "XW", "Y")),
	umxPath("X", with = "W"),
	# umxPath(c("X", "W", "XW"), to = "Y")
	umxPath(c("X", "W", "XW"), to = "Y", labels= paste0("b", 1:3))
)
plot(m1, showM=F)
umxSummary(m1, showEstimates = "std")

# Now calc simple slopes for each value of W
# Pick low, medium and high moderator values (e.g. mean and +/- 1 SD)
lowW = mean(df$W) - sd(df$W) # low
medW = mean(df$W)            # medium
 hiW = mean(df$W) + sd(df$W) # high

# Use loop plot to plot model for low, med, high values of W 
# NOTE - values of 1,5 in LOOP() statement need to be replaced by 
# logical min and max limits of predictor X used in analysis

xvalues = sort(unique(df$X))
b0 = coef(m1)["one_to_Y"]
b1 = coef(m1)["b1"]
b2 = coef(m1)["b2"]
b3 = coef(m1)["b3"]

yforLowMod = (b0 + b2 * lowW)  + (b1 + b3 * lowW) * xvalues
yforMedMod = (b0 + b2 * medW)  + (b1 + b3 * medW) * xvalues
yforHi_Mod = (b0 + b2 * hiW)   + (b1 + b3 * hiW)  * xvalues

```
