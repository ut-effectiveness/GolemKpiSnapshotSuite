#' Build housing value box data
#'
#' @return Tibble ready for value box creation.
#' @export
housing_value_box_data <- function() {
  raw <- housing_pull_raw()
  housing_build(raw)$final_housing_for_valueboxs
}
