#' Access files in the current app
#' @export
#' @noRd
app_sys <- function(...) {
  file.exists(system.file("golem-config.yml", package = "GolemKpiSnapshotSuite"))
}

#' Read App Config
#' @export
#' @noRd
get_golem_config <- function(
    value,
    config = Sys.getenv("GOLEM_CONFIG_ACTIVE", Sys.getenv("R_CONFIG_ACTIVE", "default")),
    use_parent = TRUE,
    file = app_sys("golem-config.yml")
) {
  config::get(
    value = value,
    config = config,
    file = file,
    use_parent = use_parent
  )
}
