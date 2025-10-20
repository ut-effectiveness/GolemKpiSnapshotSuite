# Internal package globals & imports

#' @keywords internal
#' @importFrom glue glue
NULL

# Silence R CMD check for NSE/dplyr columns & space-containing names
utils::globalVariables(c(
  "Current Year",
  "Previous Year",
  "building_name",
  "difference",
  "term_id"
))
