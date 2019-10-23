---
layout: post
title: "Definition Variables in umxRAM"

comments: true
categories: advanced
---


install_github("r-lib/roxygen2")

# Definition variables in the RAM framework

We're used to seeing measured variables as manifests in our models.

```R
m1 = umxRAM("manifest",  umxPath(v.m. = "mpg"), data = mtcars)
plot(m1)
```
![manifest](/media/definition_variables/manifest.png "Variance of a manifest")

You can also use definition variables in RAM. A definition variable is a variable that takes a row-specific value in the model.

```R
m1 = umxRAM("manifest and definition", data = mtcars,
	umxPath(v.m. = "mpg"),
	umxPath(defn = "mpg")
)
plot(m1)
```

![def](/media/definition_variables/def.png "Definition variable as a data.labeled latent")

See how this is handled: umx creates a latent variable with variance fixed at zero, and a mean fixed at zero, but sets the label of the mean to data.mpg.

```R
umxPath(defn = "mpg")
mxPath def_mpg <-> def_mpg [value=0, free=FALSE, lbound=0]

mxPath one -> def_mpg [value=0, free=FALSE, label='data.mpg']
```

That means the model will use the subject-specific value of mpg in the model.

*Note*, to avoid confusing the latent variable created by umx with the manifest variable, umx names the latent "def_"
so you can refer to the definition variable as 'def_mpg'

If you want, you can set your own name for the definition variable:

```R
m1 = umxRAM("my name my way", data = mtcars,
	umxPath(defn = "defMPG", label= "mpg")
)
plot(m1)
```

