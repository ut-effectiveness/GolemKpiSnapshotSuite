#' Pull raw housing data
#'
#' @return Raw housing data (tibble).
#' @export
housing_pull_raw <- function() {
  exec_pkg_sql("housing_fillrate.sql")
}

#' Housing detailed table
#'
#' @return A tibble / data.frame for display.
#' @export
housing_detailed_table <- function() {
  raw <- housing_pull_raw()
  housing_build(raw)$detailed_table_for_DT
}

#' Convenience wrapper to produce housing value box data
#'
#' @return Tibble of value box metrics.
#' @export
get_housing_value_box_data <- function(){
  raw <- housing_pull_raw()
  housing_build(raw)$final_housing_for_valueboxs
}

