#' Pull raw housing data
#'
#' @return Raw housing data (tibble).
#' @export
housing_pull_raw <- function() {
  exec_pkg_sql("housing_fillrate.sql")
}

