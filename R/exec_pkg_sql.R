#' Execute a packaged SQL file (lives in inst/sql of this package) using utHelpR
#'
#' @param name SQL filename (with or without .sql)
#' @param dsn  DSN passed through to utHelpR::get_data_from_sql_file
#' @return Tibble/data.frame
#' @examples
#' # exec_pkg_sql("kpi_rollup")
#' @export
exec_pkg_sql <- function(name, dsn = "edify") {
  if (!grepl("\\.sql$", name, ignore.case = TRUE)) {
    name <- paste0(name, ".sql")
  }
  path <- system.file("sql", name, package = "GolemKpiSnapshotSuite")
  if (identical(path, "")) {
    stop("SQL not found in GolemKpiSnapshotSuite inst/sql: ", name, call. = FALSE)
  }
  utHelpR::get_data_from_sql_file(
    file_name = path,
    dsn = dsn,
    context = "raw"  # triggers fallback branch (no here::here usage)
  )
}
