#' Obtain the growth reference behind the chart
#'
#' @param chartcode The chart code, returned by \code{create_chartcode()}
#' @param yname Names of the response variable
#' @param chartgrp The chart group. If not specified, it is calculated
#' automatically.
#' @return An object of class \code{reference}
#' @seealso \code{\link[clopus]{reference-class}}
#' @examples
#' \dontrun{
#' get_reference("nl2010", "NJAA", "hgt")
#' }
#' @export
get_reference <- function(chartcode,
                          yname,
                          chartgrp = get_chartgrp(chartcode)) {
  tab <- chartcatalog::ynames_lookup
  idx <- tab$chartgrp %in% chartgrp[1L] &
    tab$chartcode %in% chartcode[1L] &
    tab$yname %in% yname[1L]
  if (sum(idx) > 1L) {
    warning("Search combination not unique")
    return(NULL)
  }
  if (sum(idx) < 1L) {
    warning("Search combination not found")
    return(NULL)
  }
  eval(parse(text = tab[idx, "reference"]))
}
