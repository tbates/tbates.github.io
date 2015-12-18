---
layout: post
title: "Trouble shooting"
date: 1965-02-15 00:00
comments: true
categories: models
---

# Model diagnostics, Model identification check, saturated model
# Get Expected Covariance, means, thresholds
# Model Identification, diagnostics, and refModels

```splus
require(OpenMx)

data(demoOneFactor)
manifests <- names(demoOneFactor)
latents <- "G1"
model2 <- mxModel(model="One Factor", type="RAM",
      manifestVars = manifests,
      latentVars = latents,
      mxPath(from = latents[1], to=manifests, labels=paste0('load', manifests)),
      mxPath(from = manifests, arrows = 2, lbound=1e-6, labels=paste0('resid', manifests)),
      mxPath(from = latents, arrows = 2, values = 1.0, labels='varG1'),
      mxPath(from = 'one', to = manifests),
      mxData(demoOneFactor, type = "raw")
)
fit2 <- mxRun(model2)



#--------------------------------------
# Step 0
# Look at your model
summary(fit2)

# Does anything look wrong?
# Take this opportunity to re-read your
#  script, add comments, remove things
#  you don't need.

#--------------------------------------
# Step 1
# Re-run the model from its end point

fit3 <- mxRun(fit2)
summary(fit3)

# Still badness?

#--------------------------------------
# Step 2
# Use mxTryHard to try a bunch of 
#  starting values

fit4 <- mxTryHard(model2)


#--------------------------------------
# Step 2.5
# Try switching optimizers

mxOption(NULL, 'Default optimizer', 'NPSOL')
#mxOption(NULL, 'Default optimizer', 'SLSQP')

fit4n <- mxTryHard(model2)


#--------------------------------------
# Step 3
# Check that the model is identified
#  at its end point


# Model identification check
id2 <- mxCheckIdentification(fit2)
id2$status
# The model is not locally identified
id2$non_identified_parameters


# Oops, it looks like I forgot to 
#  set the scale of the latent variable
#  by either fixing a factor loading or
#  fixing the factor variance.


#--------------------------------------
# Step 4
# Generate data from your model

simData <- mxGenerateData(model2, 500)
cor(simData)
head(simData)

summary(simData)

# Maybe I have silly starting values.


simData <- mxGenerateData(fit2, 500)
cor(simData)
head(simData)

summary(simData)


#--------------------------------------
# Step 5
# Post on the OpenMx forums
#   Describing the problem
#   Attaching your cleaned script
#   Attaching your simulated fake data
#   Including the output from mxVersion()
mxVersion()

#--------------------------------------
# Step 6
# Fix the problem


#--------------------------------------
# Build a model from the same starting values as the previous one
#  but now the factor variance is also free
model2n <- mxModel(model2, name="Correctly Identified One Factor",
      mxPath(from=latents[1], arrows=2, free=FALSE, values=1, labels='varG1')
)

mid <- mxCheckIdentification(model2n)
mid$non_identified_parameters
coef(model2n)


fit2n <- mxRun(model2n)

mid2 <- mxCheckIdentification(fit2n)
mid2$status

# saturated model
sat <- mxRefModels(fit2n, run=TRUE)

summary(fit2n, refModels=sat)