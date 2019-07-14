---
layout: post
title: "Parallel Execution"

comments: true
categories: technical
---

Parallel execution allows `umx` to use multiple cores, or distribute a model across machines. Single models can be processed using parallel resources, and multiple models can be run and results combined.

Out of the box, `umx` uses all cores (actually, the result of a call to `detectCores() - 1`).

### Set cores with umx

`umx` allows you to get and set the number of cores OpenMx will use with:

```r
umx_set_cores()  # See many cores are currently requested?
umx_set_cores(3) # Request use of 3 cores

```

#### Background
Modern CPUs contain multiple cores ([processing units that share memory](https://en.wikipedia.org/wiki/Multi-core_processor)), and machines may contain more than one CPU.
Some chips also implement "[virtual](https://en.wikipedia.org/wiki/Hyper-threading)" cores which help allow the compiler to keep the hardware working while one process is data limited.

You can see total number of cores on your machine with `detectCores()` (on my 2016 iMac, the answer was 8 (4 real, with hyper-threading). In practice, only real cores advance model speed much, and 4 cores will complete a model in a little over 1/4 of the time compared to 1-core.


Under the hood, this is getting or setting an mxOption:

```r
mxOption(NULL, "Number of Threads") # get current value

mxOption(NULL, "Number of Threads", n) # set value to n
```

Setting cores to 0 will use the most available

*note*: `umx_set_cores` is equivalent to:

```r
mxOption(NULL, "Number of Threads", detectCores())
```

Now you don't need to remember or type this long option string!

*top tip*: Use R's tab-function completion (just type `umx_` and tab to see the list…):
*top tip*: [TextMate](http://macromates.com) OpenMx bundle contains snippets for many of umx's features.

### OpenMP on unix clusters

If you're trying to use multiple cores on a managed cluster, you might need to request these in the control script that schedules your jobs.

Here's an example for edinburgh's cluster. The key is `-pe OpenMP 12`

```r
#!/bin/sh
# This is a simple example of a batch script
# call me as
# qsub -P ppls_psychology -cwd  -o ~/bin/makeOpenMx.out -e ~/bin/makeOpenMx.err ~/bin/makeOpenMx.sh
# Grid Engine options 
#$ -cwd
# Set the maximum run time to 30 minutes, 0 seconds:
#$ -l h_rt=00:30:00
#$ -N parallel_example
#$ -pe OpenMP 12
 
# initiallise environment module 
. /etc/profile.d/modules.sh
 
# use Intel compilers (icc,ifort)
# Load R
module load R/3.2.2
module load gcc/4.8.3
module load intel
 
# set number of threads
 
export OMP_NUM_THREADS=$NSLOTS
echo OMP_NUM_THREADS=$OMP_NUM_THREADS

R CMD BATCH my.R my.out

```