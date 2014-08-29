# Specifying things that go without saying:

In the SEM package, `specifyModel` can 

```splus    
model.DHP.1 <- specifyModel()
```

7 + 2 + 6 paths

```splus
RIQ <- > RIQ, sigma77, NA

RIQ     -> ROccAsp, gamma51, NA
RSES    -> ROccAsp, gamma52, NA
FIQ     -> FOccAsp, gamma64, NA
FSES    -> FOccAsp, gamma63, NA

FOccAsp -> ROccAsp, beta56, NA
ROccAsp -> FOccAsp, beta65, NA
ROccAsp <- > ROccAsp, sigma77, NA
FOccAsp <- > FOccAsp, sigma88, NA
ROccAsp <- > FOccAsp, sigma78, NA
```


### 9 lines: 

```splus
RIQ     -> ROccAsp, gamma51, NA
RSES    -> ROccAsp, gamma52, NA
FSES    -> FOccAsp, gamma63, NA
FIQ     -> FOccAsp, gamma64, NA
FOccAsp -> ROccAsp, beta56, NA
ROccAsp -> FOccAsp, beta65, NA
ROccAsp <- > ROccAsp, sigma77, NA
FOccAsp <- > FOccAsp, sigma88, NA
ROccAsp <- > FOccAsp, sigma78, NA
```

### 7 lines: Above, + latent variances added by default

```splus    
RIQ     -> ROccAsp, gamma51
RSES    -> ROccAsp, gamma52
FSES    -> FOccAsp, gamma63
FIQ     -> FOccAsp, gamma64
FOccAsp -> ROccAsp, beta56
ROccAsp -> FOccAsp, beta65
ROccAsp <- > FOccAsp, sigma78
uxmFixed(c("RIQ", "RSES", "FSES", "FIQ"))
umxResidual("ROccAsp", "FOccAsp") # latents have some exogenous variance (sigma)

# OR
umxVariance("ROccAsp", "FOccAsp", with data = Fixed, without = free) # latents have some exogenous variance (sigma)

```

