# Specifying things that go without saying:

In the SEM package, `specifyModel` can 

```splus    
model.DHP.1 <- specifyModel()
```

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

### 7 lines: Above, + latent variances added by default

```splus    
m1 = umxRAM("test", data = xxx,
	umxPath(c("RIQ", "RSES"), to = "ROccAsp"),
	umxPath(c("FIQ", "FSES"), to = "FOccAsp"),
	umxPath("FOccAsp", to = "ROccAsp"),
	umxPath("ROccAsp", to = "FOccAsp"),
	umxPath("ROccAsp" with = c("FOccAsp", "sigma78")
)

```
