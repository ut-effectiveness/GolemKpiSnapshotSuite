#' Universal golem config getter for parent and child apps
#'
#' @param value Config value to retrieve
#' @param package Name of the package to read config from. Defaults to parent package ("GolemKpiSnapshotSuite").
#' @param config Active config to use
#' @param use_parent Whether to use parent config logic
#' @return The config value
#' @export
#'
get_golem_config <- function(
    value,
    package = "GolemKpiSnapshotSuite",
    config = Sys.getenv("GOLEM_CONFIG_ACTIVE", Sys.getenv("R_CONFIG_ACTIVE", "default")),
    use_parent = TRUE
) {
  system.file(..., package = "GolemKpiSnapshotSuite")
  if (file == "") stop("Config file not found in package: ", package)
  config::get(
    value = value,
    config = config,
    file = file,
    use_parent = use_parent
  )
}
