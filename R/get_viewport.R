#' Obtain the viewport name of the chart
#'
#' @param chartcode The chart code, returned by \code{create_chartcode()}
#' @param yname Names of the response variable
#' @param chartgrp The chart group. If not specified, it is calculated
#' automatically.
#' @param number If \code{number == TRUE} the function return the viewport
#' number. If \code{number == FALSE} the function return the viewport name.
#' @return Number, or name, of the viewport
#' @export
get_viewport <- function(chartcode,
                         yname,
                         chartgrp = get_chartgrp(chartcode),
                         number = TRUE) {
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
  tab[idx, ifelse((number), "vpn", "vp")]
}
