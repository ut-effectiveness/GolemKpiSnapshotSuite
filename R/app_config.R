#' Universal golem config getter (shared)
#'
#' @param value Config key
#' @param package Target package (NULL = auto-detect a child package first, then fallback)
#' @param config Active config name
#' @param use_parent Forwarded to config::get
#' @export
get_golem_config <- function(
  value,
  pkg = "GolemKpiSnapshotSuite",
  config = Sys.getenv("GOLEM_CONFIG_ACTIVE", Sys.getenv("R_CONFIG_ACTIVE", "default")),
  use_parent = TRUE
){
  f <- app_sys("golem-config.yml", package = pkg)
  if (f == "") stop("golem-config.yml not found in package: ", pkg)
  config::get(
    value = value,
    config = config,
    file = f,
    use_parent = use_parent
  )
}

# Single canonical system.file usage (required by golem name check)
app_sys <- function(..., package = "GolemKpiSnapshotSuite"){
  system.file(..., package = package)
}
