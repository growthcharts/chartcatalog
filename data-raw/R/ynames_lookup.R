# ynames_lookup.R
#
# NOTE: First run chartbox/data-raw/R/make_charts_xxx.R to fill the library
#
# Creates entry /data/ynames_lookup containing basic information
# about the set of installed charts

library(tidyr)
library(chartbox)

project <- path.expand("~/package/chartbox/chartbox")
chartbox <- file.path(project, "inst/library")

# read chart table
chart_table <- chartbox::list_charts()

# derive lookup table for viewport and reference
get_viewport_vector_name <- function(chartcode) {
  p <- chartcatalog::parse_chartcode(chartcode)
  if (p$design == "A" & p$side == "front") return(c("A", "B", "C", NA, NA))
  if (p$design == "A" & p$side == "back")  return(rep(NA, 5))
  if (p$design == "B" & p$side == "front") return(c(NA, "B", NA, NA, "A"))
  if (p$design == "B" & p$side == "back")  return(c("A", NA, NA, NA, NA))
  if (p$design == "B" & p$side == "-hdc")  return(rep(NA, 5))
  if (p$design == "C" & p$side == "front") return(c(NA, "B", NA, NA, "A"))
  if (p$design == "C" & p$side == "back")  return(c("B", NA, NA, "A", NA))
  if (p$design == "C" & p$side == "-hdc")  return(c(NA, NA, NA, "A", NA))
  if (p$design == "E" & p$side == "front") return(c(NA, "B", "A", NA, NA))
  if (p$design == "E" & p$side == "back")  return(c("A", NA, NA, NA, NA))
  if (p$side == "hgt") return(c(NA, "A", NA, NA, NA))
  if (p$side == "wgt") return(c(NA, NA, "A", NA, NA))
  if (p$side == "hdc") return(c("A", NA, NA, NA, NA))
  if (p$side == "bmi") return(c(NA, NA, NA, "A", NA))
  if (p$side == "wfh") return(c(NA, NA, NA, NA, "A"))
  return(rep(NA, 5))
}

# derive lookup table for viewport and reference
get_viewport_vector_number <- function(chartcode) {
  p <- chartcatalog::parse_chartcode(chartcode)
  if (p$design == "A" & p$side == "front") return(c(3, 4, 5, NA, NA))
  if (p$design == "A" & p$side == "back")  return(rep(NA, 5))
  if (p$design == "B" & p$side == "front") return(c(NA, 4, NA, NA, 3))
  if (p$design == "B" & p$side == "back")  return(c(1, NA, NA, NA, NA))
  if (p$design == "B" & p$side == "-hdc")  return(rep(NA, 5))
  if (p$design == "C" & p$side == "front") return(c(NA, 4, NA, NA, 3))
  if (p$design == "C" & p$side == "back")  return(c(3, NA, NA, 2, NA))
  if (p$design == "C" & p$side == "-hdc")  return(c(NA, NA, NA, 2, NA))
  if (p$design == "E" & p$side == "front") return(c(NA, 4, 3, NA, NA))
  if (p$design == "E" & p$side == "back")  return(c(1, NA, NA, NA, NA))
  if (p$side == "hgt") return(c(NA, 1, NA, NA, NA))
  if (p$side == "wgt") return(c(NA, NA, 1, NA, NA))
  if (p$side == "hdc") return(c(1, NA, NA, NA, NA))
  if (p$side == "bmi") return(c(NA, NA, NA, 1, NA))
  if (p$side == "wfh") return(c(NA, NA, NA, NA, 1))
  return(rep(NA, 5))
}


# lookup for vp
ynames <- c("hdc", "hgt", "wgt", "bmi", "wfh")
ynames_lookup <- data.frame(
  chartgrp = chart_table$chartgrp,
  chartcode = chart_table$chartcode,
  hdc = NA,
  hgt = NA,
  wgt = NA,
  bmi = NA,
  wfh = NA,
  stringsAsFactors = FALSE)
for (i in seq_along(chart_table$chartcode)) {
  chart <- chart_table$chartcode[i]
  g <- chartbox::load_chart(chart)
  ynames_lookup[i, ynames] <- get_viewport_vector_name(chart)
}
ynames_lookup <- ynames_lookup %>%
  tidyr::gather(key = "yname", value = "vp", -chartgrp, -chartcode, na.rm = TRUE) %>%
  dplyr::arrange(chartgrp, chartcode, yname)
vp <- ynames_lookup$vp

# lookup for vpn
ynames <- c("hdc", "hgt", "wgt", "bmi", "wfh")
ynames_lookup <- data.frame(
  chartgrp = chart_table$chartgrp,
  chartcode = chart_table$chartcode,
  hdc = NA,
  hgt = NA,
  wgt = NA,
  bmi = NA,
  wfh = NA,
  stringsAsFactors = FALSE)
for (i in seq_along(chart_table$chartcode)) {
  chart <- chart_table$chartcode[i]
  g <- chartbox::load_chart(chart)
  ynames_lookup[i, ynames] <- get_viewport_vector_number(chart)
}
ynames_lookup <- ynames_lookup %>%
  tidyr::gather(key = "yname", value = "vpn", -chartgrp, -chartcode, na.rm = TRUE) %>%
  dplyr::arrange(chartgrp, chartcode, yname)
ynames_lookup$vp <- vp


## lookup for reference
get_reference_calltext <- function(chartgrp, chartcode, yname) {
  p <- chartcatalog::parse_chartcode(chartcode)

  if (chartgrp == "nl2010") {
    if (p$population == "NL" && p$sex == "male" && yname == "hdc")
      return(paste0('clopus::', 'nl1997', '[["', 'nl1997.mhdcNL', '"]]'))
    if (p$population == "NL" && p$sex == "male" && yname == "hgt")
      return(paste0('clopus::', 'nl2009', '[["', 'nl2009.mhgtNL', '"]]'))
    if (p$population != "HS" && p$sex == "male" && yname == "wgt")
      return(paste0('clopus::', 'nl1980', '[["', 'nl1980.mwgt', '"]]'))
    if (p$population != "HS" && p$sex == "male" && yname == "bmi")
      return(paste0('clopus::', 'nl1980', '[["', 'nl1980.mbmi', '"]]'))
    if (p$population != "HS" && p$sex == "male" && yname == "wfh")
      return(paste0('clopus::', 'nl1980', '[["', 'nl1980.mwfhNLA', '"]]'))
    if (p$population == "NL" && p$sex == "female" && yname == "hdc")
      return(paste0('clopus::', 'nl1997', '[["', 'nl1997.fhdcNL', '"]]'))
    if (p$population == "NL" && p$sex == "female" && yname == "hgt")
      return(paste0('clopus::', 'nl2009', '[["', 'nl2009.fhgtNL', '"]]'))
    if (p$population != "HS" && p$sex == "female" && yname == "wgt")
      return(paste0('clopus::', 'nl1980', '[["', 'nl1980.fwgt', '"]]'))
    if (p$population != "HS" && p$sex == "female" && yname == "bmi")
      return(paste0('clopus::', 'nl1980', '[["', 'nl1980.fbmi', '"]]'))
    if (p$population != "HS" && p$sex == "female" && yname == "wfh")
      return(paste0('clopus::', 'nl1980', '[["', 'nl1980.fwfhNLA', '"]]'))

    if (p$population == "TU" && p$sex == "male" && yname == "hdc")
      return(paste0('clopus::', 'nl1997', '[["', 'nl1997.mhdcTU', '"]]'))
    if (p$population == "TU" && p$sex == "male" && yname == "hgt")
      return(paste0('clopus::', 'nl2009', '[["', 'nl2009.mhgtTU', '"]]'))
    if (p$population == "TU" && p$sex == "female" && yname == "hdc")
      return(paste0('clopus::', 'nl1997', '[["', 'nl1997.fhdcTU', '"]]'))
    if (p$population == "TU" && p$sex == "female" && yname == "hgt")
      return(paste0('clopus::', 'nl2009', '[["', 'nl2009.fhgtTU', '"]]'))

    if (p$population == "MA" && p$sex == "male" && yname == "hdc")
      return(paste0('clopus::', 'nl1997', '[["', 'nl1997.mhdcMA', '"]]'))
    if (p$population == "MA" && p$sex == "male" && yname == "hgt")
      return(paste0('clopus::', 'nl2009', '[["', 'nl2009.mhgtMA', '"]]'))
    if (p$population == "MA" && p$sex == "female" && yname == "hdc")
      return(paste0('clopus::', 'nl1997', '[["', 'nl1997.fhdcMA', '"]]'))
    if (p$population == "MA" && p$sex == "female" && yname == "hgt")
      return(paste0('clopus::', 'nl2009', '[["', 'nl2009.fhgtMA', '"]]'))

    if (p$population == "HS" && p$sex == "male" && yname == "hdc")
      return(paste0('clopus::', 'nl1997', '[["', 'nl1997.mhdcNL', '"]]'))
    if (p$population == "HS" && p$sex == "male" && yname == "hgt")
      return(paste0('clopus::', 'nlhs', '[["', 'nl2010hgt.mhgtHS', '"]]'))
    if (p$population == "HS" && p$sex == "male" && yname == "wgt")
      return(paste0('clopus::', 'nlhs', '[["', 'nl1976wgt.mwgtHS', '"]]'))
    if (p$population == "HS" && p$sex == "male" && yname == "bmi")
      return(paste0('clopus::', 'nlhs', '[["', 'nl1976bmi.mbmiHS', '"]]'))
    if (p$population == "HS" && p$sex == "male" && yname == "wfh")
      return(paste0('clopus::', 'nlhs', '[["', 'nl1976wfh.mwfhHS', '"]]'))
    if (p$population == "HS" && p$sex == "female" && yname == "hdc")
      return(paste0('clopus::', 'nl1997', '[["', 'nl1997.fhdcNL', '"]]'))
    if (p$population == "HS" && p$sex == "female" && yname == "hgt")
      return(paste0('clopus::', 'nlhs', '[["', 'nl2010hgt.fhgtHS', '"]]'))
    if (p$population == "HS" && p$sex == "female" && yname == "wgt")
      return(paste0('clopus::', 'nlhs', '[["', 'nl1976wgt.fwgtHS', '"]]'))
    if (p$population == "HS" && p$sex == "female" && yname == "bmi")
      return(paste0('clopus::', 'nlhs', '[["', 'nl1976bmi.fbmiHS', '"]]'))
    if (p$population == "HS" && p$sex == "female" && yname == "wfh")
      return(paste0('clopus::', 'nlhs', '[["', 'nl1976wfh.fwfhHS', '"]]'))

    return(NA_character_)
  }

  if (chartgrp == "preterm") {
    if (p$sex == "male" && yname == "hdc")
      return(paste0('clopus::', 'preterm', '[["', 'pt2012b.mhdc', p$week, '"]]'))
    if (p$sex == "male" && yname == "hgt")
      return(paste0('clopus::', 'preterm', '[["', 'pt2012a.mhgt', p$week, '"]]'))
    if (p$sex == "male" && yname == "wgt")
      return(paste0('clopus::', 'preterm', '[["', 'pt2012a.mwgt', p$week, '"]]'))
    if (p$sex == "female" && yname == "hdc")
      return(paste0('clopus::', 'preterm', '[["', 'pt2012b.fhdc', p$week, '"]]'))
    if (p$sex == "female" && yname == "hgt")
      return(paste0('clopus::', 'preterm', '[["', 'pt2012a.fhgt', p$week, '"]]'))
    if (p$sex == "female" && yname == "wgt")
      return(paste0('clopus::', 'preterm', '[["', 'pt2012a.fwgt', p$week, '"]]'))
    return(NA_character_)
  }

  if (chartgrp == "who") {
    if (p$sex == "male" && yname == "hdc")
      return(paste0('clopus::', 'who', '[["who2011.mhdc"]]'))
    if (p$sex == "male" && yname == "hgt")
      return(paste0('clopus::', 'who', '[["who2011.mhgt"]]'))
    if (p$sex == "male" && yname == "wgt")
      return(paste0('clopus::', 'who', '[["who2011.mwgt"]]'))
    if (p$sex == "male" && yname == "bmi")
      return(paste0('clopus::', 'who', '[["who2011.mbmi"]]'))
    if (p$sex == "male" && yname == "wfh")
      return(paste0('clopus::', 'who', '[["who2011.mwfh"]]'))
    if (p$sex == "female" && yname == "hdc")
      return(paste0('clopus::', 'who', '[["who2011.fhdc"]]'))
    if (p$sex == "female" && yname == "hgt")
      return(paste0('clopus::', 'who', '[["who2011.fhgt"]]'))
    if (p$sex == "female" && yname == "wgt")
      return(paste0('clopus::', 'who', '[["who2011.fwgt"]]'))
    if (p$sex == "female" && yname == "bmi")
      return(paste0('clopus::', 'who', '[["who2011.fbmi"]]'))
    if (p$sex == "female" && yname == "wfh")
      return(paste0('clopus::', 'who', '[["who2011.fwfh"]]'))
    return(NA_character_)
  }
}

ynames_lookup$reference <- NA_character_
for (i in 1:nrow(ynames_lookup)) {
  text <- get_reference_calltext(ynames_lookup[i, "chartgrp"],
                                 ynames_lookup[i, "chartcode"],
                                 ynames_lookup[i, "yname"])
  ynames_lookup[i, "reference"] <- text
}

## check if all references can be found
refs <- lapply(ynames_lookup$reference, function(x) eval(parse(text = x)))
idx <- sapply(refs, is.null)
ynames_lookup$reference[idx]

# add lookup for transformation functions: tx() and ty()
get_tx_calltext <- function(chartgrp, chartcode, yname) {
  p <- chartcatalog::parse_chartcode(chartcode)

  if (p$design == "A") return("function(x) x * 12")
  "function(x) x"
}

get_ty_calltext <- function(chartgrp, chartcode, yname) {
  p <- chartcatalog::parse_chartcode(chartcode)

  if (yname == "wfh") return("function(y) log10(y)")
  if (yname == "wgt" && p$design  == "E") return("function(y) log10(y)")
  "function(y) y"
}

ynames_lookup$tx <- NA_character_
for (i in 1:nrow(ynames_lookup)) {
  text <- get_tx_calltext(ynames_lookup[i, "chartgrp"],
                          ynames_lookup[i, "chartcode"],
                          ynames_lookup[i, "yname"])
  ynames_lookup[i, "tx"] <- text
}

ynames_lookup$ty <- NA_character_
for (i in 1:nrow(ynames_lookup)) {
  text <- get_ty_calltext(ynames_lookup[i, "chartgrp"],
                          ynames_lookup[i, "chartcode"],
                          ynames_lookup[i, "yname"])
  ynames_lookup[i, "ty"] <- text
}

# transformation sequence
# trp transform-reference
# rtp reference-transform

ynames_lookup$seq <- "tr"
ynames_lookup$seq[ynames_lookup$chartgrp == "preterm"] <- "rt"
ynames_lookup$seq[ynames_lookup$chartcode == "NMEA" &
                    ynames_lookup$yname == "wgt"] <- "rt"
ynames_lookup$seq[ynames_lookup$chartcode == "NJEA" &
                    ynames_lookup$yname == "wgt"] <- "rt"

ynames_lookup$seq[ynames_lookup$chartcode == "NMEW" &
                    ynames_lookup$yname == "wgt"] <- "rt"
ynames_lookup$seq[ynames_lookup$chartcode == "NJEW" &
                    ynames_lookup$yname == "wgt"] <- "rt"

# save
usethis::use_data(ynames_lookup, overwrite = TRUE)

