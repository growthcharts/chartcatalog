
<!-- README.md is generated from README.Rmd. Please edit that file -->

# chartcatalog

<!-- badges: start -->

<!-- badges: end -->

The `chartcatalog` package contains tools to

  - Lookup available charts in JAMES;
  - Create and parse chart codes;
  - Find outcomes, chart group and growth reference;
  - Obtain viewport number and transformation functions;
  - Lookup breakpoints from the brokenstick model.

## Installation

You can install the development version `chartcatalog` by

``` r
install.packages("remotes")
remotes::install_github("stefvanbuuren/chartcatalog")
```

There is no release on CRAN.

## Example 1: Available charts in JAMES

The current version holds 306 Dutch charts.

``` r
library(chartcatalog)
head(ynames_lookup)
#>   chartgrp chartcode yname vpn vp                          reference
#> 1   nl2010      HJAA   hdc   3  A  clopus::nl1997[["nl1997.mhdcNL"]]
#> 2   nl2010      HJAA   hgt   4  B clopus::nlhs[["nl2010hgt.mhgtHS"]]
#> 3   nl2010      HJAA   wgt   5  C clopus::nlhs[["nl1976wgt.mwgtHS"]]
#> 4   nl2010      HJAH   hgt   1  A clopus::nlhs[["nl2010hgt.mhgtHS"]]
#> 5   nl2010      HJAO   hdc   1  A  clopus::nl1997[["nl1997.mhdcNL"]]
#> 6   nl2010      HJAW   wgt   1  A clopus::nlhs[["nl1976wgt.mwgtHS"]]
#>                   tx            ty seq
#> 1 function(x) x * 12 function(y) y  tr
#> 2 function(x) x * 12 function(y) y  tr
#> 3 function(x) x * 12 function(y) y  tr
#> 4 function(x) x * 12 function(y) y  tr
#> 5 function(x) x * 12 function(y) y  tr
#> 6 function(x) x * 12 function(y) y  tr
length(unique(ynames_lookup$chartcode))
#> [1] 306
```

The charts are subdivided into three groups:

``` r
unique(ynames_lookup$chartgrp)
#> [1] "nl2010"  "preterm" "who"
```

There are five outcomes, but not every outcome (`yname`) appears in all
chart groups:

``` r
with(ynames_lookup, table(chartgrp, yname))
#>          yname
#> chartgrp  bmi hdc hgt wfh wgt
#>   nl2010   16  44  52  32  20
#>   preterm   0  48  96   0  96
#>   who       0   4   8   4   4
```

## Example 2: Chartcode creating and parsing

A `chartcode` identifies the type of growth chart. The code is a
combination of 4–7 alphanumeric characters. The `create_chartcode()` and
`parse_chartcode()` functions can be used to obtain information from the
codes. For example,

``` r
parse_chartcode(c("HJAA"))
#> $population
#> [1] "HS"
#> 
#> $sex
#> [1] "male"
#> 
#> $design
#> [1] "A"
#> 
#> $side
#> [1] "front"
#> 
#> $language
#> [1] "dutch"
#> 
#> $week
#> [1] ""
```

shows that chart with code `"HJAA"` identifies the front of the chart
for Hindostani boys living in the Netherlands, design A (A4 size, 0-15
months).

## Example 3: Find outcomes, chart group and growth reference

If we have a chart code, we may find its chart group and outcomes as

``` r
get_chartgrp("PJEAN26")
#>   PJEAN26 
#> "preterm"
get_ynames("PJEAN26")
#> PJEAN26 PJEAN26 
#>   "hgt"   "wgt"
```

We obtain the post-natal growth reference of weight of preterms born at
a gestational age of 26 week by

``` r
tb <- get_reference("PJEAN26", yname = "wgt")
tb
#> reference -- country: NL   year: 2012   sex: male   yvar: wgt   dist: LMS 
#>         x       L      M     S
#> 1  0.0000  1.0885  0.985 0.206
#> 2  0.0027  1.0836  0.971 0.206
#> 3  0.0055  1.0785  0.960 0.207
#> 4  0.0082  1.0737  0.950 0.207
#> 5  0.0110  1.0688  0.943 0.208
#> 6  0.0137  1.0642  0.937 0.208
#> 7  0.0164  1.0596  0.933 0.208
#> 8  0.0192  1.0549  0.930 0.209
#> 9  0.0219  1.0504  0.929 0.209
#> 10 0.0246  1.0460  0.930 0.209
#> 11 0.0274  1.0416  0.932 0.210
#> 12 0.0301  1.0373  0.936 0.210
#> 13 0.0329  1.0329  0.941 0.210
#> 14 0.0356  1.0288  0.947 0.210
#> 15 0.0383  1.0247  0.954 0.211
#> 16 0.0575  0.9970  1.036 0.212
#> 17 0.0767  0.9717  1.160 0.212
#> 18 0.0958  0.9485  1.313 0.213
#> 19 0.1150  0.9269  1.489 0.212
#> 20 0.1342  0.9068  1.679 0.212
#> 21 0.1533  0.8881  1.877 0.211
#> 22 0.1725  0.8705  2.082 0.210
#> 23 0.1916  0.8540  2.289 0.209
#> 24 0.2108  0.8384  2.498 0.208
#> 25 0.2300  0.8236  2.706 0.207
#> 26 0.2491  0.8097  2.913 0.206
#> 27 0.2500  0.8090  2.922 0.206
#> 28 0.2917  0.7809  3.363 0.203
#> 29 0.3333  0.7554  3.785 0.200
#> 30 0.3750  0.7320  4.188 0.198
#> 31 0.4167  0.7103  4.569 0.195
#> 32 0.4583  0.6902  4.928 0.193
#> 33 0.5000  0.6712  5.267 0.190
#> 34 0.5417  0.6532  5.587 0.188
#> 35 0.5833  0.6361  5.887 0.186
#> 36 0.6250  0.6197  6.170 0.185
#> 37 0.6667  0.6039  6.438 0.183
#> 38 0.7083  0.5887  6.690 0.181
#> 39 0.7500  0.5740  6.931 0.180
#> 40 0.7917  0.5597  7.159 0.179
#> 41 0.8333  0.5457  7.375 0.178
#> 42 0.8750  0.5321  7.583 0.176
#> 43 0.9167  0.5188  7.781 0.175
#> 44 0.9583  0.5057  7.971 0.175
#> 45 1.0000  0.4929  8.153 0.174
#> 46 1.0833  0.4679  8.498 0.172
#> 47 1.1667  0.4436  8.821 0.171
#> 48 1.2500  0.4201  9.125 0.170
#> 49 1.3333  0.3971  9.413 0.168
#> 50 1.4167  0.3746  9.688 0.168
#> 51 1.5000  0.3527  9.950 0.167
#> 52 1.5833  0.3312 10.204 0.166
#> 53 1.6667  0.3101 10.448 0.165
#> 54 1.7500  0.2894 10.685 0.165
#> 55 1.8333  0.2691 10.916 0.164
#> 56 1.9167  0.2492 11.140 0.164
#> 57 2.0000  0.2296 11.360 0.163
#> 58 2.5000  0.1183 12.588 0.161
#> 59 3.0000  0.0164 13.703 0.160
#> 60 3.5000 -0.0776 14.732 0.160
#> 61 4.0000 -0.1650 15.689 0.160
```

More details can be found in the `info` slot:

``` r
slot(tb, "info")
#> An object of class "referenceInfo"
#> Slot "n":
#> [1] 4
#> 
#> Slot "i":
#> [1] 2
#> 
#> Slot "j":
#> [1] 2
#> 
#> Slot "code":
#> [1] "mpt2012a"
#> 
#> Slot "country":
#> [1] "NL"
#> 
#> Slot "year":
#> [1] 2012
#> 
#> Slot "sex":
#> [1] "male"
#> 
#> Slot "sub":
#> character(0)
#> 
#> Slot "yname":
#> [1] "wgt"
#> 
#> Slot "dist":
#> [1] "LMS"
#> 
#> Slot "mnx":
#> [1] 0
#> 
#> Slot "mxx":
#> [1] 4
#> 
#> Slot "source":
#> [1] "Bocca-Tjeertes 2012"
#> 
#> Slot "public":
#> character(0)
#> 
#> Slot "remark":
#> [1] "Bemerkung =\t\t\t\t\t\t\t\t\t\t\t\t\t"
#> 
#> Slot "date":
#> [1] "2020-01-13 18:13:59 CET"
```
