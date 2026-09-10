<!-- 1. **TODO**: A tutorial on data simulation with `umx_make_TwinData`, `umx_make_fake_data`, and `umx_make_MR_data` -->

### Set the Optimizer using umx_set_optimizer

`umx` can use several optimizers: `SLSQP` (the default), `CSOLNP`, or `NPSOL`.

`SLSQP` is often a good choice. `CSOLNP` can works well for ordinal models. `NPSOL` doesn't ship on the CRAN version of OpenMx. However if you're having hassles with optimization or CIs, NPSOL might help. OpenMx should support an NPSOL install via their website.

You can see the current optimizer using `umx_set_optimizer`

```r
umx_set_optimizer()
```
> Current Optimizer is: 'SLSQP'. Options are: 'CSOLNP', 'SLSQP', and 'NPSOL'

Set the optimizer by name:

```r
umx_set_optimizer("CSOLNP")

```

### Installing the GenomicSEM build of OpenMx

```r
install.OpenMx("GenomicMx")
```
### Parallel Execution

`umx` can use multiple cores to process models (and perform genomicSEM operations).

The CRAN version default`umx` uses all cores (actually, the result of a call to `detectCores() - 1`).

Get and set the number of cores used with:

```r
umx_set_cores()  # Show many cores are currently requested
umx_set_cores(3) # Request use of 3 cores

```

This function is smart: it will default to all performance cores (low power cores are typically so slow its not worth forcing the power cores to wait for them


