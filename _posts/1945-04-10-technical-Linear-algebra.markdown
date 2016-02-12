---
layout: post
title: "Linear Algebra"
date: 1945-04-10 00:00
comments: true
categories: technical
---

<a name="top"></a>

# Matrices

To understand your models you should understand matrices and linear algebra. In some ways, OpenMx's USP or unique selling point is that it is a matrix algebra processor. Most of the blog posts on this site cover RAM-style modeling, but all of this sits on top of matrices: `mxPath("A", "B")` simply inserts values into a matrix cell: Try it and see!

```r
require(OpenMx)
data(demoOneFactor)
latents  = c("G")
manifests = names(demoOneFactor)
m1 <- umxRAM("One Factor", data = mxData(cov(demoOneFactor), type = "cov", numObs = 500),
	umxPath(latents, to = manifests),
	umxPath(var = manifests),
	umxPath(var = latents, fixedAt = 1)
)
umx_show(m1)

```

Showing	values for the S matrix:

|    | x1  | x2   | x3   | x4   | x5   | G |
|:---|:----|:-----|:-----|:-----|:-----|:--|
| x1 | 0.1 | .    | .    | .    | .    | . |
| x2 | .   | 0.15 | .    | .    | .    | . |
| x3 | .   | .    | 0.19 | .    | .    | . |
| x4 | .   | .    | .    | 0.27 | .    | . |
| x5 | .   | .    | .    | .    | 0.34 | . |
| G  | .   | .    | .    | .    | .    | 1 |


So you should know about matrix algebra. 

### What's a matrix?

To quote [Wolfram](http://mathworld.wolfram.com/Matrix.html) "*A matrix is a concise and useful way of uniquely representing and working with linear transformations… first formulated by Sylvester (1851) and Cayley."

For our purposes, the benefit of matrices is their ability to represent linear transformations and, in an optimiser, to allow us to solve questions posed as linear algebra. 

A matrix is a container or place from which something (else) originates. Examples include the [extracellular matrix](https://en.wikipedia.org/wiki/Extracellular_matrix). In math, matrices consist of cells organized as rows and columns, each cell of which can contain a number. The "order" of a matrix is the number of rows followed by the number of columns. This a matrix of order 3,2 looks like this:

    |c1| c2 
----|---|---
 r1 | . | .  
 r2 | . | .  
 r3 | . | .  

To begin to see the value of this representation, let's consider the following 3 equations:

Y1 = a<sub>11</sub> × b<sub>1</sub> + a<sub>12</sub> × b<sub>2</sub>

Y2 = a<sub>21</sub> × b<sub>1</sub> + a<sub>22</sub> × b<sub>2</sub>

Y3 = a<sub>31</sub> × b<sub>1</sub> + a<sub>33</sub> × b<sub>2</sub>

These can be re-expressed in 1-line of matrix algebra as:

**Y** = **a** × **b**

Where **Y** is a 3*1 column matrix of the Y solutions, **a** is a 3*2 matrix of values of `a`, and **b** is a 2*1 column matrix of `b` values.

Try it in R:

```r
a = matrix(c(1, 1, 2, 2, 3, 3), 3 , 2, byrow = TRUE)
b = matrix(c(.1, .2), 2, 1, byrow = TRUE)
Y = a %*% b; 
list(a = a,b = b, Y = Y)

```

http://stattrek.com/matrix-algebra/deviation-score.aspx?tutorial=matrix

Matrix algebra is a tool for solving problems. Like all tools, it represents or acts on things in a way that makes tasks easier to specify or accomplish.

Matrix algebra makes the three core elements of SEM easier. These are

1. Means
2. Covariances
3. Simultaneous equations

Let's start trying to compute a mean.

To compute a mean, we want to sum all the elements of a column, and divide them by nrows. Equivalently, we might multiply by 1/nrow

Let's compute the mean of each of three columns of a matrix of order 5,3.

```r
n = 5
myData <- matrix(nrow = n, byrow = TRUE, data = c(
90, 60, 90, 
90, 90, 28, 
60, 60, 60, 
60, 60, 90, 
30, 30, 20))
myData
```

To form the means, we’ll need the help of an n * 1 Identify matrix (matrix of ones), let's call it `I`.

```r
I = matrix(data = 1, nrow= n, ncol = 1)
```

Now if we pre-multiply the data by t(I), and then take the Kronecker product of t(I) %*% I):

```r
# means
t(I) %*% myData %x% solve(t(I) %*% I)
```
We get the means

| col 1 | col 2 | col 3 |
|:------|:------|:------|
| 66    | 60    | 57.6  |

### Computing a Covariance matrix

Covariances are simply the (sum of squared deviations from the mean) divided by n or n-1.

Now we have the means, we can subtract these from each column to create a column of leftovers: deviations from the mean.

And then devise a matrix formulation which sums the squares of these deviations, returning a matrix of variances and covariances.

If we have n variables, we will want an n * n output matrix, containing variances on the diagonal, and covariances on the off diagonal.

We first want not a row of means (like above) but a matrix with the column mean in each cell. To get that, we do I times our row of means:

```r
meanMyData = (I %*% (t(I) %*% myData))/n

```
Now we can subtract that from our data, to get a deviatio matrix:

```r
devMatrix = myData - meanMyData
```

The sum of squares of the deviations is t(dev) %*% dev

```r

t(devMatrix) %*% devMatrix

```

The covariance matrix is the sum-of-squares of the deviations divided by n-1. We can check this by comparing it to R's built-in `cov()` function:

```r

ourCov = (t(devMatrix) %*% devMatrix) / (n-1)

cov(myData) - ourCov

```

This is a nice chance too to mention that umx has a nifty quick-matrix helper built in for rapidly building matrices:

```r

A = qm(0,1,2|
3,4,5)

B = qm(
6,7|
8,9|
10,11)

B %*% A
    
```

# What's that "pre- and post-multiply" stuff?
Often in [SEM](https://en.wikipedia.org/wiki/Structural_equation_modeling) scripts you will see matrices being pre- and post-multiplied by some other matrix. For instance, this figures in scripts computing the [genetic correlation](https://en.wikipedia.org/wiki/Genetic_correlation) between variables. How does pre- and post-multiplying a variance/covariance matrix give us a correlation matrix? And what is it that we are multiplying this matrix by?

In general, a covariance matrix can be converted to a correlation matrix by pre- and post-multiplying by a diagonal matrix with 1/SD for each variable on the diagonal.

In R, [matrix inversion](https://en.wikipedia.org/wiki/Invertible_matrix) (usually signified by **A** <sup>-1</sup>) is done using the [solve](http://openmx.psyc.virginia.edu/wiki/matrix-operators-and-functions)() function.

For the diagonal case, the inverse of a matrix is simply 1/x in each cell.

## Example with variance matrix A

```
	A = matrix(nrow = 3, byrow = T,c(
	 	1,0,0,
	 	0,2,0,
		0,0,3)
	); 

	     [,1] [,2] [,3]
	[1,]    1    0    0
	[2,]    0    2    0
	[3,]    0    0    3

	invA = solve(A)

	     [,1] [,2]  [,3]
	[1,]    1  0.0  0.00
	[2,]    0  0.5  0.00
	[3,]    0  0.0  0.33

```

Any number times its inverse = 1. For Matrices `solve(A) %*% A = I`.


```
invA %*% A #  = I = standardized diagonal
     [,1] [,2] [,3]
[1,]    1    0    0
[2,]    0    1    0
[3,]    0    0    1

```

### An example with values (covariances) in the off-diagonals

```r
    
A = matrix(nrow = 3, byrow = T, c(
  	 1, .5, .9,
 	.5,  2, .4,
	.9, .4,  4)
);

I = matrix(nrow = 3, byrow = T, c(
 	1,  0, 0,
 	0,  1, 0,
	0,  0, 1)
); 

varianceA = I * A # zero the off-diagonal (using regular multiplication, NOT matrix multiplication)
sdMatrix  = sqrt(varianceA) # element sqrt to get SDs on diagonal (SD = sqrt(var) )
invSD     = solve(sdMatrix) # 1/SD = inverse of sdMatrix

invSD
     [,1] [,2] [,3]
[1,]    1 0.00  0.0
[2,]    0 0.71  0.0
[3,]    0 0.00  0.5

```

Any number times its inverse = 1, so this code sweeps covariances into correlations

```r
corr = invSD %*% A %*% invSD # pre- and post- multiply by 1/SD
round(cor,2)
     [,1] [,2] [,3]
[1,] 1.00 0.35 0.45
[2,] 0.35 1.00 0.14
[3,] 0.45 0.14 1.00

```

## Easy way of doing this in R

Using diag to grab the diagonal and make a new one, and capitalising on the fact that inv(X) = 1/x for a diagonal matrix

```r
diag(1/sqrt(diag(A))) %&% A # note: The %&%  operator is short for pre- and post-mul
     [,1] [,2] [,3]
[1,] 1.00 0.35 0.45
[2,] 0.35 1.00 0.14
[3,] 0.45 0.14 1.00

```

## Even-easier built-in way

```r
cov2cor(A)

     [,1] [,2] [,3]
[1,] 1.00 0.35 0.45
[2,] 0.35 1.00 0.14
[3,] 0.45 0.14 1.00

```