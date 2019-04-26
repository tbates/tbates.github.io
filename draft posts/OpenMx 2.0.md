# Intro to OpenMx 2.0

## Recent features (In the 2.𝛽 version)

```splus
source("https://openmx.ssri.psu.edu/getOpenMx.R")
source("https://openmx.ssri.psu.edu/getOpenMxBeta.R")
```
### Directions for 2014

* Availability: On CRAN!
* Fully Open Source (CSOLNP).
* More fit functions.
* Increased ease of use.
* Most powerful application, bar none.
* Future proof around these improvements.

# Commit to Leading-edge Availability
1. Latest OS
	* OS 10.9, inc. Mavericks build
	* Windows 64
2. Latest R
	* R 3.0, R 3.1
3. Availability: On CRAN in 2014.
4. Fully Open Source: CSOLNP optimiser with API !

### Minor changes (from the user perspective) supporting these directions 

1. CSOLNP  (aiming for release in 2014)
2. Fit & Expectation
	* We’ve changed from 1 to 2 function calls to support future opportunities: read more [here](link)
3. Multigroup Fit (probably intro also)
	```splus
		# replace
		mxMultiGroup()
		# with
		mxMultiGroup()
	```
4. `@` vs `$`
	* You can now access slots (@) using $. This will allow some neat features in future - like adding variables to a RAM model just by saying:

```splus
	m1$manifestVars <-  c(m1$manifestVars, “new1”, “new2”)
```

### Bigger (from the user perspective) changes
1. LISREL Expectation
	* If you would like your `mxPath` models implemented as "LISREL" instead of "RAM", now you can
	* Is that all? enumerate any benefits to the user...
2. State Space (multilevel)
	* Show a state space figure...
	```splus
	# What will one of these look like in code?
	```
3. What can I do now?

### Easing learning and usage.

1. Easier to implement threshold models
	* mxThreshold for mxPath() models
	```splus
		# example using mtcars with mxFactor for auto vs manual?
	```
### Easier to implement leading edge features
1. `mxCompute`
	* why this will help someone with something practical they couldn't do before?
2. `mxComputeNewtonRaphson`
	* why this will help someone with something practical they couldn't do before?
3. `mxAlgebraDerivative`
	* why this will help someone with something practical they couldn't do before?

### Future prospects 2015 and beyond
1. IFA
	* What is this? Why is it new?
3. WLS
	* When
	* Why not now?
	* What will it let me do?
4. Mixture fit function
	* What is this?
	* What will it let me do?
5. Row weights
	* Don't we have this?
6. Bootstrapping
	* Don't we have this?

```splus
source("getOpenMx.R")
source("getOpenMxBeta.R")
```

This function is simpler than it may look. First off, you don't use the "ordered" parameter, and you are unlikely to need the exclude parameter. Ordered *has* to be TRUE, and exclude would mean excluding levels that are set to be observable in principle.

So, practical calls to mxFactor for a factor column will simply inherit the levels of the factor, while a numeric column will typically assume all integer levels between min and max. 

Like this:

```splus
mxFactor(mtcars[,"carb"], levels = 1:8, labels = levels)
```

You make a little analysis plan: What are the minimum and maximum observable levels in your data?
***gotcha***: It's important to get the number of levels at least as large as what occurs in your data. 

```splus
mxFactor(mtcars[,"carb"], levels=min(mtcars[,"carb"], na.rm=T):max(mtcars[,"carb"], na.rm = T))
```    
To allow comparison across groups levels must be the same. So make your levels either theoretically, or based on the whole data set. It's fine to have unfilled levels in a group.

Why don't we make `levels = NULL` by default, and use the observed levels if is.null(levels)?

```splus
levels_of_carb = sort(unique(mtcars[,"carb"]))
mxFactor(mtcars[,"carb"], levels = levels_of_carb, exclude = NA, ordered = TRUE)

mxFactor <- function (x = character(), levels, labels = levels, exclude = NA, ordered = TRUE) {
    if (missing(levels)) {
        stop("the 'levels' argument is not optional")
    }
    if (!identical(ordered, TRUE)) {
        stop("the 'ordered' argument must be TRUE")
    }
    if (is.data.frame(x)) {
        if (is.list(levels)) {
            return(data.frame(mapply(factor, x, levels, labels, 
                MoreArgs = list(exclude = exclude, ordered = ordered), 
                SIMPLIFY = FALSE), check.names = FALSE))
        }
        else {
            return(data.frame(lapply(x, factor, levels, labels, 
                exclude, ordered), check.names = FALSE))
        }
    }
    else if (is.matrix(x)) {
        stop(paste("argument 'x' to mxFactor()", "is of illegal type matrix,", 
            "legal types are vectors or data.frames"))
    }
    else {
        return(factor(x, levels, labels, exclude, ordered))
    }
}
```

FYI: It would probably be helpful also if we checked that people are not calling this using the function definition

 i.e., this throws errors because "levels" is a function

```splus
mxFactor(mtcars[,"carb"], levels, labels = levels)
mxFactor(mtcars[,"carb"], levels=1:3, labels = levels)
    
```
