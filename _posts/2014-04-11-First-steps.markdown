---
layout: post
title: "First steps: Build and run a Path model in a minute."
date: 2014-04-11 14:50
comments: true
categories: models tutorial
---

### Running a first model using data in R. Perhaps a CFA...

umx stands for "user" mx function, and is a library of helper functions for doing [Structural Equation Modeling](http://en.wikipedia.org/wiki/Structural_equation_modeling) in [OpenMx](http://openmx.psyc.virginia.edu).

```R
	# install & load newish devtools
	install.packages("devtools")
	library("devtools")    
```

{% highlight R %}
# install & load newish devtools
install.packages("devtools")
library("devtools")
# install and load umx
install_github("tbates/umx")
library("umx")
# get going :-)
?umx
{% endhighlight %}




