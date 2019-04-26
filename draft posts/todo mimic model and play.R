# library for the code
require(OpenMx) 
load(url("https://openmx.ssri.psu.edu/sites/default/files/df.dat")) # rda file
manifests      = c("cont1", "ord1", "ord2")
ordinalVars    = manifests[2:3]
continuousVars = manifests[1]
 
m1 <- mxModel("joint CFA", type="RAM",
	manifestVars = manifests,
	latentVars = "F1",
	# Factor loadings
	mxPath(from = "F1", to = manifests, arrows = 1, free = T, values = 1, labels = paste("l", 1:3, sep = "")), 
 
	# Manifest continuous mean & residual variance (both free)
	mxPath(from="one", to = continuousVars, arrows=1, free=T, values=0, labels="meancont1"),
	mxPath(from=continuousVars            , arrows=2, free=T, values=1, labels="e1" ),
 
	# Ordinal manifests mean and variance fixed at 0 (the threshold matrix will esimate these)
	mxPath(from="one", to = ordinalVars, arrows=1, free=F, values=0, labels=c("meanord1","meanord2")),
	mxPath(from=ordinalVars            , arrows=2, free=F, values=1, labels=c("e2","e3")),
 
	# fix latent variable variance @1 & mean @0 
	mxPath(from="F1"          , arrows=2, free=F, values=1, labels ="varF1"),
	mxPath(from="one", to="F1", arrows=1, free=F, values=0, labels="meanF1"),
 
	# just making some thresholds in columns for each ordinal var: Should be automated.
	mxMatrix("Full", nrow=6, ncol=2, name="thresh",
		dimnames = list(c(), ordinalVars),
		free  = c(T, T, T, T, T, T,
				  T, T, T, F, F, F),
		values= c(-3,-2,-1, 0, 1, 2,
		  		  -2, 0, 2,NA,NA,NA),
	),
	# Tell the mxRAMObjective that we have not only A,S,F and M matrices, but also some ordinal vars with thresholds
	 mxRAMObjective(A="A", S="S", F="F", M="M", thresholds = "thresh"),
 	# And last but not least, the data
 	mxData(df, type="raw")
)
 
# run!
m1 = mxRun(m1);

require(sem)
require(OpenMx)

mxStart <- function(x=1, sd=.07, n=1) {
	return(rnorm(n=n, mean=x, sd=sd))
}

# =================================
# = MIMIC Model =
# =================================

# Often you will see data presented as a lower diagonal.
# the readMoments() function in the sem package is a nice helper to read this from the screen:

data = sem::readMoments(file = "", diag = T)
1
.304 1
.305 .344   1
.100 .156 .158   1
.284 .192 .324 .360   1
.176 .136 .226 .210 .265  1

# Terminates with an empty line: see ?readMoments for more help

# now letsfill in the upper triangle with a flipped version of the lower
data[upper.tri(data, diag=F)] = t(data)[upper.tri(data, diag=F)]

# Set up manifest variables
manifests = c("income", "occup", "educ", "church", "member", "friends")

# Use these to create names for our dataframe
dimnames(data) = list(manifests, manifests)

# And latents
latents   = "social" # 1 latent, with three formative inputs, and three reflective outputs (each with residuals)

# Just to be helpful to myself, I've made lists of the formative sources, and the reflective receiver variables in this MIMIC model
receivers = manifests[4:6]
sources   = manifests[1:3]

MIMIC = mxModel("MIMIC", type="RAM",
	manifestVars = manifests,
	latentVars   = latents,
	# Factor loadings
    mxPath(from = sources , to = "social"),
    mxPath(from = "social", to = receivers),
	# Correlated formative sources for F1, each with variance 1
	mxPath(from = sources, connect = "unique.bivariate", arrows = 2),
	mxPath(from = sources, arrows = 2, values = 1, free=F ),
	# Residual variance on receivers
    mxPath(from = receivers, arrows = 2),
	mxData(data, type = "cov", numObs = 530)
)
MIMIC = mxRun(MIMIC); summary(MIMIC)
graphViz_RAM(MIMIC, std=T, precision=3, dotFilename="name")


MIMIC <- mxModel("MIMIC", type="RAM",
	manifestVars = manifests,
	latentVars   = latents,
	# Factor loadings
    mxPath(from = sources , to = "social" , values=mxStart(.3, n=sources)),
    mxPath(from = "social", to = receivers, values=mxStart(.3, n=receivers)),
	# Correlated formative sources for F1, each with variance 1
	mxPath(from = sources, connect = "unique.bivariate", arrows = 2, values=mxStart(sources,.3)),
	mxPath(from = sources, arrows = 2, values = 1, free=F ),
	# Residual variance on receivers
    mxPath(from = receivers, arrows = 2, mxStart(.3, n=receivers)),
	mxData(data, type = "cov", numObs = 530)
)
MIMIC= mxRun(MIMIC); summary(MIMIC)

MIMIC <- mxModel("MIMIC", type="RAM",
	manifestVars = manifests,
	latentVars   = latents,
	# Factor loadings
    mxPath(from = sources , to = "social"),
    mxPath(from = "social", to = receivers),
	# Correlated formative sources for F1, each with variance 1
	# Residual variance on manifests
    mxPath(from = manifests, arrows = 2),
	mxData(data, type = "cov", numObs = 530)
)
MIMIC = mxRun(MIMIC); summary(MIMIC)

# plot.MxModel <- umxPlot

graphViz_RAM(MIMIC, std = T, precision = 3, dotFilename = "name")

install.packages('devtools')
library('devtools')
dev_mode()
install_github("ggplot2", "kohske", "feature/pguide")
dev_mode()

library("maps")
library("ggplot2")
reg <- as.data.frame(map("world", plot = FALSE)[c("x", "y")])
qplot(x, y, data = reg, type = "path")
p <- ggplot(reg, aes(x, y))
p + geom_path()

qplot(x, y, data = reg, geom = "path")    # or whatever 'size' you want; see ?geom_path

http://had.co.nz/ggplot/examples/maps.html


library(ggplot2)
info <- read.csv("info.csv",header=TRUE)
categories <- unique(info$category)
for (i in categories){
  plot_data <- subset(info, category == i)
  qplot(x=x,y=y,data=plot_data, main=paste("Category of ",i,sep=""))
  ggsave(paste(i,"pdf",sep="."))   # or jpg or whatever
}

choropleth.st (value, name="Avg Chamber Polarization", main = "State Legislative Polarization 2006", filename = "geography_avg_polarization", diverge=T)

choropleth.st <- function (value, name, main, filename, place, diverge=F) {
	require(ggplot2)
	require(maps)
	require(mapproj)  
	ak.hi = which(names(value)%in%c("AK","HI"))
	if (length(ak.hi)>0) { value = value[-ak.hi] }
  
		states.df    = map_data("state")
	states.df    = subset(states.df,group!=8) # get rid of DC
	states.df$st = state.abb[match(states.df$region,tolower(state.name))] # attach state abbreviations  
	states.df$value = value[states.df$st]
  
	if (!diverge) {
		p = qplot(long, lat, data = states.df, group = group, fill = value, geom = "polygon", xlab="", ylab="", main=main) +
		opts(
			axis.text.y=theme_blank(), 
			axis.text.x=theme_blank(), 
			axis.ticks = theme_blank(), 
			panel.grid.major = theme_blank(), 
			panel.grid.minor = theme_blank(), 
			panel.background = theme_blank(), 
			panel.border = theme_blank()
		) + scale_fill_continuous(name,low = "#B71B1A", high =  "#3B4FB8", )
		p2 = p + geom_path(data=states.df, color = "white", alpha = 0.4, fill = NA) + coord_map(project="albers", at0 = 45.5, lat1 = 29.5)    
	} else {
		fill_gradn <- function(pal) {
			scale_fill_gradientn(name, colours = pal(7))
		}
    	p = qplot(long, lat, data = states.df, group = group, fill = value, geom = "polygon", xlab="", ylab="", main=main) +
		opts(axis.text.y=theme_blank(), axis.text.x=theme_blank(), axis.ticks = theme_blank(), 
		panel.grid.major = theme_blank(), panel.grid.minor = theme_blank(), panel.background = theme_blank(), panel.border = theme_blank())+ 
		fill_gradn(diverge_hcl)
		p2 = p + geom_path(data=states.df, color = "white", alpha = 0.4, fill = NA) + coord_map(project="albers", at0 = 45.5, lat1 = 29.5)     
	}
	for (filetype in c(".pdf",".png")) {
		ggsave(file=paste("Plots/maps/",filename,filetype,sep=""), width=8, height=5) 
	}
}


varList = c("x1","x2","x3","x4","x5","x6")
myFADataRaw <- myFADataRaw[,varList]

m1 <- mxModel("Common Factor Model Path Specification", type="RAM", 
	manifestVars=varList, latentVars="F1",
	mxPath(from=varList, arrows=2, free=T, values=rnorm(6), labels=c("e1","e2","e3","e4","e5","e6")), # residual variances
	mxPath(from="F1" , arrows=2, free=T, values=1, labels ="varF1"), # latent variance
	mxPath(from="F1" , to=varList, arrows=1, free=c(F,T,T,T,T,T), values=c(1,1,1,1,1,1), labels = c("l1","l2","l3","l4","l5","l6")), # factor loadings
	mxPath(from="one", to=c(varList,"F1"), arrows=1, free=c(T,T,T,T,T,T,F), values=c(1,1,1,1,1,1,0), labels =c("m1","m2","m3","m4","m5","m6",NA)), 
	mxData(observed=myFADataRaw, type="raw")
) # close model

m1 <- mxRun(m1)
summary(m1)
names(m1@output)
m1@output$algebras
m1@output$calculatedHessian
m1@output$confidenceIntervalCodes
m1@output$confidenceIntervals
m1@output$cpuTime
m1@output$estimate
m1@output$estimatedHessian
m1@output$evaluations
m1@output$frontendTime
m1@output$gradient
m1@output$hessianCholesky
m1@output$independentTime
m1@output$matrices
m1@output$minimum
m1@output$estimate


# Set up function for analysis
nonNormTest <- function (data,nQuadPoints=10,nFactors=1) {                                                   
    # Number of: items; quadrature points; maximum # of thresholds; and factors (1 only at present)
    nItems <- dim(data)[[2]]
    nthresh <- vector(mode="integer",nItems)
}

dispatch_apply(10, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^(size_t index) {
    void * my_thing =  my_tings[index];
    // ...
});

Microsoft is ethical
http://www.techrepublic.com/blog/window-on-windows/microsoft-is-one-of-the-worlds-most-ethical-companies/5870?tag=nl.e101
http://blogs.technet.com/b/microsoftupblog/archive/2012/03/15/who-are-the-world-s-most-ethical-companies.aspx
http://www.kickstarter.com/projects/1834879952/goats-book-iv-inhuman-resources?ref=history

# Bootstrapping
http://eranraviv.com/blog/bootstrap-example/?utm_source=rss&utm_medium=rss&utm_campaign=bootstrap-example

install.packages("knitr")
library("knitr")
# knit('knitr-minimal.Rnw')
knit("knitr-minimal_knit.html")
# simple scatterplots of correlated data

mu     <- c(0,0)
sigma  <- 1
rho    <- 0.5
Sigma  <- array (c(sigma^2, rho*sigma^2, rho*sigma^2, sigma^2), c(2,2))
n.sims <- 1000
x      <- mvrnorm (n.sims, mu, Sigma, empirical=TRUE)

par(pty="s", mar=c(4,4,3,2))
plot(x[,1], x[,2], xlim=range(x), ylim=range(x), xaxt="n", yaxt="n", xlab="x", ylab="y", mgp=c(1,0,0), main="principal component line", pch=20, cex.lab=1.4, cex.main=1.4, cex=.7)
abline (0,1,lwd=2)

par(pty="s", mar=c(4,4,3,2))
plot(x[,1], x[,2], xlim=range(x), ylim=range(x), xaxt="n", yaxt="n", xlab="x", ylab="y", mgp=c(1,0,0), main="regression line of y on x", pch=20, cex.lab=1.4, cex.main=1.4, cex=.7)
abline (0, rho,lwd=2)

fib <- function(n){
	if (n < 2) {
		return(n)
	} else {
		return(fib(n - 1) + fib(n - 2))
	}
}
 
start <- Sys.time()
fib(25)
end <- Sys.time()
end - start

fib <- function(n){
	if (n < 2) {
		return(n)
	} else {
		return( fib(n - 1) + fib(n - 2) )
	}
}

fib2a <- function(n) {
	if (n < 3) {
		1
	} else {
		y <- rep(1, n)
		for(i in 3:n) 
			y[i] <- y[i-1] + y[i-2]
			y[n]
		}
}

library(compiler)
library(rbenchmark)
fib2c <- compile(fib2a)

benchmark(fib(20), fib2a(20))