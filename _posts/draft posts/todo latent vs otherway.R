# There’d be no apotheosis around here.
#
# Rage over the unequal distribution of talent.
# Desiring a thing cannot make you have it.
# Mark Wahlgberg, The Gambler, 2015
#
# These guys showed that pairs of people looking at something can jointly offer a better decision (just a perceptual task), than can either individually.
#
# Bahrami, Olsen, Latham, Roepstorff, Rees & Frith (2010) “Optimally Interacting Minds”
#
# http://www.nytimes.com/2015/01/18/opinion/sunday/why-some-teams-are-smarter-than-others.html?smid=go-share&_r=0

n = 1000; iqX = 100; iqSD = 15
g  = rnorm(n,100,15)
g1 = g/2 + rnorm(n,iqX, iqSD)/2
g2 = g/2 + rnorm(n,iqX, iqSD)/2
g3 = g/2 + rnorm(n,iqX, iqSD)/2
create = rnorm(n,iqX,iqSD)
# create = rnorm(n,iqX,iqSD*.8)+g*.2
df     = data.frame(g1 = g1, g2 = g2, g3= g3, create = create)
cor(df) # two correlated variables, one independent
dat = mxData(cov(df, use = "complete"), type = "cov", numObs = nrow(df))

# 3-indicators of g
mc <- umxRAM("umx", data = dat,
	umxPath(var = c("g1", "g2", "g3")),
	umxPath(var = "g", fixedAt = 1),
	umxPath("g", to = c("g1", "g2", "g3"))
)
mc = mxRun(mc); plot(mc, std = T, showFixed = T)

# 2-indicators of g
mc <- umxRAM("umx", data = dat,
	umxPath(var = c("g2", "g1")),
	umxPath(var = "g", fixedAt = 1),
	umxPath("g", to = c("g1", "g2"))
)
mc = mxRun(mc); plot(mc, std = T, showFixed = T); # umxSummary(mc, show = "std")

# 3-indicators of g + (unrelated) creativity
m1 <- umxRAM("g3plusc", data = dat,
	umxPath(var = c("g1", "g2", "g3", "create")),
	umxPath(var = "g", fixedAt = 1),
	umxPath("g", to = c("g1", "g2", "g3", "create"))
)
m1 = mxRun(m1); plot(m1, std = T, showFixed = T); # umxSummary(mc, show = "std")

m2 = umxReRun(m1, "g_to_create", name = "drop_create")
plot(m2, std = T, showF = T, showM = T)
mxCompare(m1, m2)

# 2-indicators of g + (unrelated) creativity
m1 <- umxRAM("umx", data = dat,
	umxPath(var = c("g1", "g2", "create")),
	umxPath(var = "g", fixedAt = 1),
	umxPath("g", to = c("g1", "g2", "create"))
)

# mx model
m3 <- mxModel("mx", type = "RAM", dat,
	manifestVars = names(df),
	latentVars   = "g",
	mxPath(c("g1", "g2", "create"), arrows = 2),
	mxPath("g", arrows = 2, values = 1, free = FALSE),
	mxPath("g", to = c("g1", "g2", "create"))
)
m3 = mxRun(m3)
plot(m3, std = T, showFixed = T)
umxSummary(m3, show = "std")
