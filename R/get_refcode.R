#' Obtain the name of the reference code used on a chart
#'
#' @rdname get_refcode
#' @param chartcode The chart code, returned by \code{create_chartcode()}
#' @param yname Name of the response variable
#' @param chartgrp The chart group. If not specified, it is calculated
#' automatically.
#' @return \code{get_refcode()} returns a string.
#' @examples
#' get_refcode("NJAA", "hgt")
#' @export
get_refcode <- function(chartcode,
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
  tab[idx, "refcode"]
}
