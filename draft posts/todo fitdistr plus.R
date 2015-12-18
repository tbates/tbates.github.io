install.packages("fitdistrplus")
library("ggplot2")
library("MASS")
library("fitdistrplus");

x <- c(0.0009507, -0.0056441, 0.0009551, -0.0068531, 0.0028059, -0.000295, -0.0007378, 0.0107188, -0.0010229, -0.000585, -0.0004389, -0.0003659, -0.0081585, -0.0046603, 0.0032571, -0.0011832, 0.0011832, 0.0042037, 0.003673, -0.0002933, 0.00022)
MASS::fitdist(x, "t")


# GENERATE DUMMY DATA 
x1 = rweibull(100, shape = 0.5, scale = 1); 
x1 = mzData$HEX_Openness_T1[!is.na(mzData$HEX_Openness_T1)]
x1 = as.numeric(as.character(mzData$ORDER_T1[!is.na(mzData$ORDER_T1)]))

# ESTIMATE WEIBULL DISTRIBUTION
f1 = fitdist(x1, 'weibull', method = 'mle');
f1 = fitdist(x1, "norm")
f1 = fitdistr(x1, "normal")

coef(fitdistr(x1, "normal"))
plot(1:19, dnorm(1:19, 1.444954, 2.307586))
qplot(1:19, x1)
# PLOT HISTOGRAM AND DENSITIES
p0 = qplot(x1[x1 > 0.1], geom = 'blank') +
  geom_line(aes(y = ..density.., colour = 'Empirical'), stat = 'density') +  
  geom_histogram(aes(y = ..density..), fill = 'gray90', colour = 'gray40') +
  geom_line(stat = 'function', fun = dweibull, args = as.list(f1$estimate), aes(colour = 'Weibull')) +
  scale_colour_manual(name = 'Density', values = c('red', 'blue'))

p0