#' Details of installed charts
#'
#' A data set containing the kind of outcomes present on each chart
#' in \code{inst/library}
#'
#' @format A data frame with variables:
#' \describe{
#' \item{chartgrp}{Chart group}
#' \item{chartcode}{Chart code as defined by \code{create_chartcode()}. This
#' chart code can be decomposed by \code{parse_chartcode()}}
#' \item{yname}{Name of the outcome present on the chart, e.g. one of \code{hdc},
#' \code{hgt}, \code{wgt}, \code{wfh}, \code{bmi}, \code{dsc}}
#' \item{vp}{The viewport name for editing the outcome. Use this to
#' specify the \code{vp} argument.}
#' \item{vpn}{Viewport number for editing the outcome. Use it in
#' \code{g$childrenvp[[vpn]]}}.
#' \item{reference}{A string indicating the reference in \code{clopus}.
#' The \code{get_reference()} function actually pulls out the relevant
#' references from \code{clopus}}
#' \item{tx}{A string coding the transformation function for the x variable}
#' \item{inv_tx}{A string coding the inverse transformation function for
#' the x variable}
#' \item{ty}{A string coding the transformation function for the y variable}
#' \item{inv_ty}{A string coding the inverse transformation function for
#' the y variable}
#' \item{seq}{Transformation sequence: either \code{"tr"} (first transform,
#' then calculate reference) or either \code{"rt"} (first calculate reference,
#' then transform).}
#' \item{refcode}{A string coding the reference name recognised by
#' \code{centile::load_reference()}.}
#' \item{refpkg}{A string coding the package in which refcode can be found by
#' \code{centile::load_reference()}.}
#' }
"ynames_lookup"
