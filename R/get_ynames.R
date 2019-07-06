#' Obtain response variables from a chartcode
#'
#' @param chartcode The chart code, returned by \code{create_chartcode()}.
#' Can be a vector. If not specified, the function returns all
#' names.
#' @param chartgrp The chart group. If not specified, it is calculated
#' automatically.
#' @return A named vector with names of the response variables for
#' @examples
#' get_ynames("NJAA")
#' @export
get_ynames <- function(chartcode = NULL,
                       chartgrp = get_chartgrp(chartcode)) {
  tab <- chartcatalog::ynames_lookup
  idx <- tab$chartcode %in% chartcode
  ynames <- tab[idx, "yname"]
  names(ynames) <- tab[idx, "chartcode"]
  ynames
}
