#' Obtain the transformation sequence from a chartcode and yname
#'
#' @param chartcode The chart code, returned by
#'   \code{create_chartcode()}
#' @param yname Names of the response variable
#' @param chartgrp The chart group. If not specified, it is calculated
#'   automatically.
#' @return An string, either \code{"tr"} (transform-reference) or
#'   \code{"rt"} (reference-transform) specifying the transformation
#'   sequence.
#' @examples
#' get_ty("nl2010", "NJAA", "hgt")
#' @export
get_seq <- function(chartcode,
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
  tab[idx, "seq"]
}
