#' Housing detailed table
#'
#' @return A tibble / data.frame for display.
#' @export
housing_detailed_table <- function() {
  raw <- housing_pull_raw()
  housing_build(raw)$detailed_table_for_DT
}
