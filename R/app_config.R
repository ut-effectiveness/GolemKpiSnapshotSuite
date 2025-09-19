#' Universal golem config getter (shared)
#'
#' @param value Config key
#' @param pkg Package that holds the golem-config.yml (default = this package)
#' @param config Active config name
#' @param use_parent Forwarded to config::get
#' @export
#'

get_golem_config <- function(
  value,
  pkg = "GolemKpiSnapshotSuite",
  config = Sys.getenv("GOLEM_CONFIG_ACTIVE", Sys.getenv("R_CONFIG_ACTIVE", "default")),
  use_parent = TRUE
){
  path <- if (identical(pkg, "GolemKpiSnapshotSuite")) {
    app_sys("golem-config.yml")
  } else {
    .pkg_file(pkg, "golem-config.yml")
  }
  if (!nzchar(path) || !file.exists(path)) {
    stop("golem-config.yml not found in package: ", pkg, call. = FALSE)
  }
  config::get(
    value = value,
    config = config,
    file = path,
    use_parent = use_parent
  )
}

app_sys <- function(...){
  system.file(..., package = "GolemKpiSnapshotSuite")
}

.pkg_file <- function(pkg, ...){
  ns <- tryCatch(getNamespaceInfo(asNamespace(pkg), "path"), error = function(e) "")
  if (!nzchar(ns)) return("")
  file.path(ns, ...)
}
