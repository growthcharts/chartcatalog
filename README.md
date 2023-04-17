
<!-- README.md is generated from README.Rmd. Please edit that file -->

# chartcatalog

<!-- badges: start -->

[![R-CMD-check](https://github.com/growthcharts/chartcatalog/workflows/R-CMD-check/badge.svg)](https://github.com/growthcharts/chartcatalog/actions)
[![R-CMD-check](https://github.com/growthcharts/chartcatalog/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/growthcharts/chartcatalog/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The `chartcatalog` package contains tools to

- Lookup available charts in JAMES;
- Create and parse chart codes;
- Find outcomes, chart group and growth reference;
- Obtain viewport number and transformation functions;
- Lookup break points from the brokenstick model.

## Installation

You can install the development version `chartcatalog` by

``` r
install.packages("remotes")
remotes::install_github("growthcharts/chartcatalog")
```

There is no release on CRAN.

## Example 1: Available charts in JAMES

The current catalogs holds 440 Dutch charts.

``` r
library(chartcatalog)
head(ynames_lookup)
#>   chartgrp chartcode yname vpn vp                         reference
#> 1   nl2010      DJAA   hdc   3  A clopus::nl2009[["nl2009.mhdcDS"]]
#> 2   nl2010      DJAA   hgt   4  B clopus::nl2009[["nl2009.mhgtDS"]]
#> 3   nl2010      DJAA   wgt   5  C   clopus::nl1980[["nl1980.mwgt"]]
#> 4   nl2010      DJAH   hgt   1  A clopus::nl2009[["nl2009.mhgtDS"]]
#> 5   nl2010      DJAO   hdc   1  A clopus::nl2009[["nl2009.mhdcDS"]]
#> 6   nl2010      DJAW   wgt   1  A   clopus::nl1980[["nl1980.mwgt"]]
#>                   tx            ty seq             refcode
#> 1 function(x) x * 12 function(y) y  tr nl_2009_hdc_male_ds
#> 2 function(x) x * 12 function(y) y  tr nl_2009_hgt_male_ds
#> 3 function(x) x * 12 function(y) y  tr   nl_1980_wgt_male_
#> 4 function(x) x * 12 function(y) y  tr nl_2009_hgt_male_ds
#> 5 function(x) x * 12 function(y) y  tr nl_2009_hdc_male_ds
#> 6 function(x) x * 12 function(y) y  tr   nl_1980_wgt_male_
length(unique(ynames_lookup$chartcode))
#> [1] 440
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
#> chartgrp  bmi dsc hdc hgt wfh wgt
#>   nl2010   20   4  56  64  40  24
#>   preterm   0  48  48  96   0  96
#>   who       0  52   4   8   4   4
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
for Hindustan boys living in the Netherlands, design A (A4 size, 0-15
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

We obtain the call to the `clopus` package to the post-natal growth
reference of weight of preterms born at a gestational age of 26 week by

``` r
call <- get_reference_call("PJEAN26", yname = "wgt")
call
#> [1] "clopus::preterm[[\"pt2012a.mwgt26\"]]"
```

This call can be stored as a shortcut to the reference. Use
`eval(parse(text = call))` to execute the call. Alternatively, if you
have `clopus` installed, we may obtain the reference directly by

``` r
tb <- get_reference("PJEAN26", yname = "wgt")
slotNames(tb)
#> [1] "table" "info"
head(data.frame(tb@table@table))
#>        x    L     M     S
#> 1 0.0000 1.09 0.985 0.206
#> 2 0.0027 1.08 0.971 0.206
#> 3 0.0055 1.08 0.960 0.207
#> 4 0.0082 1.07 0.950 0.207
#> 5 0.0110 1.07 0.943 0.208
#> 6 0.0137 1.06 0.937 0.208
```

More details can be found in the `info` slot:

``` r
tb@info
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
#> [1] "2021-01-27 16:33:21 CET"
```

## Added support for `nlreferences` package

``` r
library(centile)
library(nlreferences)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
refcode <- ynames_lookup %>% 
  filter(chartcode == "PJEAN26" & yname == "wgt") %>% 
  pull(refcode)
ref <- load_reference(refcode, pkg = "nlreferences", verbose = TRUE)
head(ref)
#> # A tibble: 6 × 4
#>        x     L     M     S
#>    <dbl> <dbl> <dbl> <dbl>
#> 1 0       1.09 0.985 0.206
#> 2 0.0027  1.08 0.971 0.206
#> 3 0.0055  1.08 0.96  0.207
#> 4 0.0082  1.07 0.95  0.207
#> 5 0.011   1.07 0.943 0.208
#> 6 0.0137  1.06 0.937 0.208
attr(ref, "study")
#>                                                                                                                                                                                                                                                           name 
#>                                                                                                                                                                                                                                                           "nl" 
#>                                                                                                                                                                                                                                                           year 
#>                                                                                                                                                                                                                                                         "2012" 
#>                                                                                                                                                                                                                                                          yname 
#>                                                                                                                                                                                                                                                          "wgt" 
#>                                                                                                                                                                                                                                                            sex 
#>                                                                                                                                                                                                                                                         "male" 
#>                                                                                                                                                                                                                                                            sub 
#>                                                                                                                                                                                                                                                           "26" 
#>                                                                                                                                                                                                                                                   distribution 
#>                                                                                                                                                                                                                                                          "LMS" 
#>                                                                                                                                                                                                                                                       citation 
#>                                                                                                                                                                                                                                          "Bocca-Tjeertes 2012" 
#>                                                                                                                                                                                                                                                    publication 
#> "Bocca-Tjeertes IFA, van Buuren S, Bos AF, Kerstens JM, ten Vergert EM & Reijneveld SA (2012) Growth of Preterm and Full-term Children Aged 0-4 years: Integrating Median Growth and Variability in Growth Charts. Journal of Pediatrics, 161(3), 460-465.e1."
```
