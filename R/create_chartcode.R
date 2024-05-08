#' Construct a single chart code from user input
#'
#'@aliases create_chartcode
#'@param chartgrp The chart group: \code{'nl2010'}, \code{'preterm'}, \code{'who'},
#'\code{'gsed1'} or \code{'gsed1pt'}.
#'@param etn Either \code{'nl'}, \code{'tu'}, \code{'ma'}, \code{'hs'} or \code{'ds'}.
#'May also be abbreviates to a single letter.
#'@param sex Either \code{'male'} or \code{'female'}
#'@param agegrp Either \code{'0-15m'}, \code{'0-4y'}, \code{'1-21y'}, \code{'0-21y'}
#' or \code{'0-4ya'}. Age group \code{'0-4ya'} provides the 0-4 chart with weight
#' for age (design E).
#'@param side Either \code{'front'}, \code{'back'}, \code{'-hdc'}, \code{'both'},
#' \code{'hgt'}, \code{'wgt'}, \code{'hdc'}, \code{'bmi'}, \code{'wfh'} or
#' \code{'dsc'}.
#'@param week A number between 25 and 36 gestational age (preterm) or 40 for
#'term (default).
#'@param language Language: \code{'dutch'} or \code{'english'}
#'@param version Version number. Default is to have no version number.
#'@export
create_chartcode <- function(chartgrp = c('nl2010', 'preterm', 'who', 'gsed1', 'gsed1pt'),
                          etn = c('nl', 'tu', 'ma', 'hs', 'ds'),
                          sex = c('male', 'female'),
                          agegrp = c('0-15m', '0-4y', '1-21y', '0-21y', '0-4ya'),
                          side = c('front', 'back', '-hdc', 'both', 'hgt',
                                   'wgt', 'hdc', 'bmi', 'wfh', 'dsc'),
                          week = 40,
                          language = c('dutch','english'),
                          version = '')
{
  chartgrp <- match.arg(chartgrp)
  etn <- match.arg(etn)
  sex <- match.arg(sex)
  agegrp <- match.arg(agegrp)
  side <- match.arg(side)
  language <- match.arg(language)

  # group terms into week 40
  week <- ifelse(week > 36, 40, week)

  # use design E if wgt is asked for 0-ya
  if (agegrp == "0-4y" & side == "wgt") agegrp <- "0-4ya"

  ## c1 chart group/etnicity: N, T, M, P, H
  c1 <- switch(chartgrp,
               'preterm' = 'P',
               'nl2010' = toupper(substring(etn, 1, 1)),
               'who' = 'W',
               'gsed1' = 'W',
               'gsed1pt' = 'W'
  )

  ## c2 sex: J, M
  c2 <- ifelse(sex == 'male', 'J', 'M')

  ## c3 agegrp1: A, B, C, D, E
  c3 <- switch(agegrp,
               '0-15m' = 'A',
               '0-4y'  = 'B',
               '0-4ya' = 'E',
               '1-21y' = 'C',
               '0-21y' = 'D')

  ## we have only designs A and E for preterms, so set
  ##  c1 to 'N' for age age group '1-21y' and '0-21y'
  if (c1 == 'P') {
    c3 <- switch(agegrp,
                 '0-15m' = 'A',
                 '0-4y'  = 'E',
                 '0-4ya' = 'E',
                 '1-21y' = 'C',
                 '0-21y' = 'D')
  }
  if (c1 == 'P' & (c3 == 'C' | c3 == 'D')) c1 <- 'N'

  ## WHO charts
  if (c1 == 'W') {
    c3 <- switch(agegrp,
                 '0-15m' = 'A',
                 '0-4y'  = 'B',
                 'B')
  }

  ## c4 side: A, B
  c4 <- switch(side,
               'front' = 'A',
               'back'  = 'B',
               '-hdc'  = 'C',
               'both'  = 'X',
               'hgt'   = 'H',
               'wgt'   = 'W',
               'hdc'   = 'O',
               'bmi'   = 'Q',
               'wfh'   = 'R',
               'dsc'   = 'D')

  ## we have no backside charts for preterms, so use
  ## Dutch charts instead
  if (c1 == 'P' & any(c4 %in% c('B', 'C', 'X'))) c1 <- 'N'

  ## WHO: front only
  if (c1 == 'W' & any(c4 %in% c('B', 'C', 'X'))) c4 <- 'A'

  ## c5 language, only two versions for preterms
  # We always use language for WHO D-score charts
  c5 <- switch(language,
               'dutch' = 'N',
               'english' = 'E')
  c5 <- ifelse(c1 == 'P' || (c1 == 'W' && c4 == 'D'), c5, '')

  ## c6: week: '' for most charts,
  ## 25-36 for preterms (P)
  # We always use week for WHO D-score charts
  c6 <- ifelse(c1 == 'P' || (c1 == 'W' && c4 == 'D'), week, '')

  ## c7: version: 3
  c7 <- version

  code <- paste(c1, c2, c3, c4, c5, c6, c7, sep="")
  return(code)
}

