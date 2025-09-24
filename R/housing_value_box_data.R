#' Build housing value box data
#'
#' @param dsn Optional data source name / connection (if used).
#' @param context Optional context/environment object.
#' @return Tibble ready for value box creation.
#' @export
housing_value_box_data <- function() {
  raw <- housing_pull_raw(dsn = dsn, context = context)
  housing_build(raw)$final_housing_for_valueboxs
}
