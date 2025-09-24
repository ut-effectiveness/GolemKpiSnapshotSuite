#' Pull raw housing data
#'
#' @param dsn Optional data source name.
#' @param context Optional context object.
#' @return Raw housing data (tibble).
#' @export
housing_pull_raw <- function() {
  exec_pkg_sql("housing_fillrate.sql")
}

