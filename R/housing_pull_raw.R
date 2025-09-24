#' Pull raw housing data
#'
#' @param dsn Optional data source name.
#' @param context Optional context object.
#' @return Raw housing data (tibble).
#' @export
housing_pull_raw <- function(dsn = "edify", context = "shiny") {
  utHelpR::get_data_from_sql_file("housing_fillrate.sql", dsn = dsn, context = context)
}
