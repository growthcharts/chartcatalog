#' Obtain the growth reference behind the chart
#'
#' @rdname get_reference
#' @return \code{get_reference()} returns an object of class \code{reference}.
#' @seealso \code{\link[clopus]{reference-class}}
#' @examples
#' \dontrun{
#' ref <- get_reference("NJAA", "hgt")
#' }
#' @export
get_reference <- function(chartcode,
                          yname,
                          chartgrp = get_chartgrp(chartcode)) {
  call <- get_reference_call(chartcode, yname, chartgrp)
  eval(parse(text = call))
}
