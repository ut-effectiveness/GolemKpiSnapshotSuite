#' Housing detailed table
#'
#' @param dsn Optional data source name.
#' @param context Optional context object.
#' @return A tibble / data.frame for display.
#' @export
housing_detailed_table <- function(dsn = "edify", context = "shiny") {
  raw <- housing_pull_raw(dsn = dsn, context = context)
  housing_build(raw)$detailed_table_for_DT
}
