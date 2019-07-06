#' Parses the chart code
#'
#' @aliases parse_chartcode
#' @param chartcode the chart code, usually constructed by \code{create_chartcode()}
#' @return The function returns a \code{list} with the following components:
#' \describe{
#'    \item{\code{population}}{A string identifying the population,
#'    e.g. \code{'NL'},\code{'MA'}, \code{'TU'} or \code{'PT'}.}
#'    \item{\code{sex}}{A string \code{"male"}, \code{"female"} or
#'    \code{"undifferentiated"}.}
#'    \item{\code{design}}{A letter indicating the chart design: \code{'A'} = 0-15m,
#'    \code{'B'} = 0-4y, \code{'C'} = 1-21y, \code{'D'} = 0-21y, \code{'E'} =
#'    0-4ya.}
#'    \item{\code{side}}{A string indicating the side or \code{yname}:
#'    \code{'front'}, \code{'back'}, \code{'both'}, \code{'hgt'},
#'    \code{'wgt'}, \code{'hdc'}, \code{'bmi'}, \code{'wfh'}}
#'    \item{\code{language}}{The language in which the chart is drawn. Currently only
#'    \code{"dutch"} charts are implemented, but for \code{population == "PT"} we
#'    may also have \code{"english"}.}
#'    \item{\code{week}}{A scalar indicating the gestational age at birth.
#'    Only used if \code{population == "PT"}.}
#'    }
#' @export
parse_chartcode <- function(chartcode = NULL) {

  if (is.null(chartcode)) return(NULL)
  chartcode <- chartcode[1]

  # 1: population group
  population <- switch(EXPR = substr(chartcode, 1, 1),
                       'N' = 'NL',
                       'M' = 'MA',
                       'T' = 'TU',
                       'P' = 'PT',
                       'E' = 'NL',
                       'H' = 'HS',
                       'W' = ifelse(substr(chartcode, 2, 2) == 'J', 'WHOblue', 'WHOpink'),
                       NULL
  )

  # 2: sex
  sex <- switch(EXPR = substr(chartcode, 2, 2),
                'J' = 'male',
                'M' = 'female',
                'U' = 'undifferentiated',
                NULL
  )

  # 3: design
  design <- substr(chartcode, 3, 3)  # A-E, S

  # 4: side
  side <- switch(EXPR = substr(chartcode, 4, 4),
                 'A' = "front",
                 'B' = "back",
                 'C' = "-hdc",
                 'X' = "both",
                 'H' = "hgt",
                 'W' = "wgt",
                 'O' = "hdc",
                 'Q' = "bmi",
                 'R' = "wfh",
                 NULL)

  # 5: language
  language <- 'dutch'
  if (population == "PT")
    language <- switch(EXPR = substr(chartcode, 5, 5),
                       'N' = "dutch",
                       'E' = "english",
                       NULL)

  # 6: week
  week <- ""
  if (population == "PT") week <- substr(chartcode, 6, 7)

  return(list(population = population,
              sex = sex,
              design = design,
              side = side,
              language = language,
              week = week))
}
