#' Convenience wrapper to produce housing value box data
#'
#' @inheritParams housing_value_box_data
#' @return Tibble of value box metrics.
#' @export
get_housing_value_box_data <- function(){
  raw <- housing_pull_raw()
  housing_build(raw)$final_housing_for_valueboxs
}
