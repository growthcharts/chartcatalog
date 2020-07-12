#' Obtain the call to a reference used on a chart
#'
#' @rdname get_reference
#' @param chartcode The chart code, returned by \code{create_chartcode()}
#' @param yname Name of the response variable
#' @param chartgrp The chart group. If not specified, it is calculated
#' automatically.
#' @return \code{get_reference_call()} returns a string with the call. Your
#' library must contain the \code{clopus} package to execute the call by
#' \code{eval(parse(text = call))}.
#' @examples
#' get_reference_call("NJAA", "hgt")
#' @export
get_reference_call <- function(chartcode,
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
  tab[idx, "reference"]
}
