---
layout: post
title: "Linear Algebra"

comments: true
categories: technical
---

<a name="top"></a>

# Matrices

To understand your models, you should understand matrices and linear algebra. In some ways, umx's unique selling point is that it sits on the OpenMx matrix algebra processor. Several of the blog posts on this site cover RAM-style modeling, but many are built in matrix algebra, and `umxRAM` is simply an interface to underlying matrices: `mxPath("A", "B", ...)` simply inserts values into cells in each the layer of matrix (the A - for Asymmetric) matrix: Try it and see!

```r
require(umx)

manifests = names(demoOneFactor)
m1 <- umxRAM("One Factor", data = demoOneFactor, type = "cov",
	umxPath("G", to = manifests),
	umxPath(var = manifests),
	umxPath(var = "G", fixedAt = 1)
)
tmx_show(m1)

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

For our purposes, the benefit of matrices is their ability to represent linear transformations and, together with an [optimiser](https://tbates.github.io/technical/1943/02/12/technical-Optional-optimizers.html), to allow us to solve questions posed as simultaneous linear algebra equations. 

*etymology*: "matrix" means a container or place from which something (else) originates. Examples include the [extracellular matrix](https://en.wikipedia.org/wiki/Extracellular_matrix).

In math, matrices consist of cells organized in rows and columns. Each cell can contain a value. Matrix algebra is a set of rules for manipulating matrices, designed to make representing and solving problems easier to specify or accomplish.

Here, we will just scratch the surface of matrices and algebra, just enough to make sense of RAM models, and alert you to the uses of basic operations on matrices, as well as the special multi-layer format of matrices in `umx` and how this aids modeling (allowing you to specify not just values in the row-column addressing system of matrices, but bounds on those values, labels by which to refer to them, and whether they are free or fixed).

*note*: There are several online tutorials in matrix algebra, like [this one](https://stattrek.com/matrix-algebra/deviation-score.aspx?tutorial=matrix)

#### Making two matrices a and c, and computing the matrix product a %*% b

The "order" of a matrix is the number of rows followed by the number of columns. This a matrix of order 3,2:

    |c1| c2 
----|---|---
 r1 | . | .  
 r2 | . | .  
 r3 | . | .  

To begin to see the value of this representation, let's consider the following 3 equations:

Y1 = a<sub>11</sub> × b<sub>1</sub> + a<sub>12</sub> × b<sub>2</sub>

Y2 = a<sub>21</sub> × b<sub>1</sub> + a<sub>22</sub> × b<sub>2</sub>

Y3 = a<sub>31</sub> × b<sub>1</sub> + a<sub>33</sub> × b<sub>2</sub>

These potentially quite large matrices of relations can be expressed in just 1-line of matrix algebra, which doesn't grow in complexity as the matrix rows and columns grow:

**Y** = **a** × **b**

Here, **Y** is a 3*1 column matrix of the Y solutions, **a** is a 3*2 matrix of values of `a`, and **b** is a 2*1 column matrix of `b` values.

Try it in R. First set up two matrices **a** and **b**:
```r
a = matrix(nrow= 3 , ncol = 2, byrow = TRUE, c(
	1, 1,
	2, 2,
	3, 3)
)
b = matrix(c(.1, .2), nrow = 2, ncol = 1, byrow = TRUE)
```

To see what you have created, type `a`, or `b` into the R console.

Now, set **Y** to the matrix multiply product (`%*%` in R) of **a** and **b**:

```R
Y = a %*% b;
```

Matrix multiplication differs from regular multiplication. In R, the regular `*` sign does a conventional multiply operation on the corresponding cells of two matrices, outputting a matrix of the same size with these individual products.

Matrix multiplication requires matrices to be "conformable": The number of columns of matrix a must equal the rows of matrix b.

The result of a matrix multiplication will have the number of rows of matrix a, and the number of columns of matrix b.

Let’s use the example of computing the mean for each of a set of columns of data using matrix algebra.

To compute a mean, we want to sum all the elements of a column, and divide them by `nrow`. Equivalently, we might multiply by 1/nrow.

If we set up 3 columns of data in a matrix myData to compute the mean on:

```r
n = 5
myData <- matrix(nrow = n, byrow = TRUE, data = c(
	90, 60, 90, 
	90, 90, 28, 
	60, 60, 60, 
	60, 60, 90, 
	30, 30, 20)
)
myData
```

The full algebra to return the means is: `t(I) %*% myData %x% solve(t(I) %*% I)`

We can take this step by step.

First **I** is an `nrow * 1` "Identify" matrix (a matrix of ones), which we will call `I`.

```r
I = matrix(data = 1, nrow= n, ncol = 1)
```

Next, we have `t(I)`, the transpose of **I**. This flips the rows and columns of **I**, so our 5 by 1 matrix become a 1 by 5 matrix. Do this in R yourself to see:

```r
t(I)
```

Next we can turn to `t(I) %*% I)`: the matrix product of our 1 by 5 transposed **I** matrix and **I**: a 5 by 1 matrix of 1s.

The rules for conformability let us know this is legal (columns of matrix 1 = rows of matrix 2), and the rules of matrix algebra tell us to expect a 1 by 1 matrix as output. In this trivial example, you can visualize the first column matrix **I** rotating over to come alongside the 1st (and only) row of `t(I)`. Then multiply the corresponding items of each (i.e., the 1st item of the first row of `t(I)` * the first item of the first column of **I**, second times the second and so on.) And now add these products together (this whole process is called an Einstein product) and store the result in row 1 column 1 of the result matrix.

And in this simple example, that's it! t(I) %*% I) = 5`

Next we take the inverse of this result. In R, the inverse if taken with a function called `solve`. For this trivial example, `solve(t(I) %*% I)` works the same as simply `1/5 = 0.2`.

What's left to do of our original equation `t(I) %*% myData %x% solve(t(I) %*% I)`? 

Next is the part saying `myData %x% .2`. `%x%` is called Kronecker product.

The Kronecker product `myData %x% .2` is:

```R
     [,1] [,2] [,3]
[1,]   18   12 18.0
[2,]   18   18  5.6
[3,]   12   12 12.0
[4,]   12   12 18.0
[5,]    6    6  4.0
```

Lets store that as `K` to keep the mental load down. 

```r
K = myData %x% .2
```

Finally if we pre-multiply this Kronecker product of the data by `t(I)`, i.e., `t(I) %*% K` we get the means!


| col 1 | col 2 | col 3 |
|:------|:------|:------|
| 66    | 60    | 57.6  |

### Computing a Covariance matrix

Covariances are simply the sum of squared deviations from the mean, divided by n or n-1.

Now we have the means, we can subtract these from each column to create a column of "leftovers": deviations from the mean.

We'd next want to devise a matrix formulation which square sums the squares of these deviations, returning a matrix of variances and covariances.

If we have n variables, we will want an n by n output matrix. This will contain the variances of each variable on the diagonal, and covariances among the variables in the off diagonal cells.

We first want an n-row matrix with cells in each column set to the mean of the variable represented in that column. To get this, we take **I** times our row of means:

```r
meanMyData = (I %*% (t(I) %*% myData))/n
```

Now, if we subtract this from our data, we are left with a matrix of deviations from the mean:

```r
devMatrix = myData - meanMyData
#      [,1] [,2]  [,3]
# [1,]   24    0  32.4
# [2,]   24   30 -29.6
# [3,]   -6    0   2.4
# [4,]   -6    0  32.4
# [5,]  -36  -30 -37.6
```


Consider for a moment: how to compute the sum of squares of the deviations? 

This is a widely reused pattern in statistics and matrix algebra, so you might want to commit it to memory: We pre-multiply the matrix of deviations by its transpose: t(dev) %*% dev

```r

t(devMatrix) %*% devMatrix

```

The covariance matrix is the sum-of-squares of the deviations divided by n-1. 

|      | var1 | var2 | var3   |
|:-----|:-----|:-----|:-------|
| var1 | 2520 | 1800 | 1212   |
| var2 | 1800 | 1800 | 240    |
| var3 | 1212 | 240  | 4395.2 |



We can check this by comparing it to R's built-in `cov()` function:

```r

ourCov = (t(devMatrix) %*% devMatrix) / (n-1)

cov(myData) - ourCov

```

That's a lot of ground: but covers most of what you will need to build models using matrices if you choose to.

Finally is a nice chance too to mention that `umx` has a nifty quick-matrix helper built in for rapidly building matrices. This saves some typing when you are playing around with matrices, by using `,` to separate numbers in different columns and `|` to signify the end of a row.

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

In R, [matrix inversion](https://en.wikipedia.org/wiki/Invertible_matrix) (usually signified by **A** <sup>-1</sup>) is done using the [solve](https://openmx.ssri.psu.edu/wiki/matrix-operators-and-functions)() function.

For the diagonal case, the inverse of a matrix is simply 1/x in each cell.

## Example with variance matrix A

```
	A = matrix(nrow = 3, byrow = T, c(
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
diag(1/sqrt(diag(A))) %&% A # note: The %&%  operator is short for "pre- and post-multiply A by B"
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