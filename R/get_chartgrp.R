#' Obtain the chart group from the chartcode
#'
#' @details Warning: This function uses the property that the
#'   \code{chartgrp} can be uniquely be identified from the
#'   \code{chartcode}. When the same chartcode's are used in different
#'   chart groups, this function will give unpredictable results.
#' @param chartcode Chart codes, usually constructed by
#'   \code{create_chartcode()}. If not specified, the function uses
#'   all chart codes.
#' @return The function returns a named vector with
#'   \code{length(chartcode)} elements with the chart group names.
#' @seealso \code{\link{create_chartcode}}
#' @examples
#' get_chartgrp(c("NJAA", "NJBA"))
#' @export
get_chartgrp <- function(chartcode = NULL) {
  if (is.null(chartcode))
    chartcode <- chartcatalog::ynames_lookup$chartcode
  findit <- Vectorize(function(a) {
    switch(EXPR = substr(as.character(a), 1L, 1L),
           'N' = 'nl2010',
           'M' = 'nl2010',
           'T' = 'nl2010',
           'P' = 'preterm',
           'E' = 'nl2010',
           'H' = 'nl2010',
           'W' = 'who',
           'D' = 'nl2010',
           NULL)}, "a")
  findit(chartcode)
}
