#' Read a config value from a CHILD package's golem-config.yml
#'
#' Parent package has no config; you MUST pass pkg (a child package name).
#'
#' @param value Config key
#' @param pkg Child package name (required)
#' @param config Active config section (env-controlled)
#' @param use_parent Passed to config::get
#' @return The config value
#' @export
get_golem_config <- function(
  value,
  pkg,
  config = Sys.getenv("GOLEM_CONFIG_ACTIVE", Sys.getenv("R_CONFIG_ACTIVE", "default")),
  use_parent = TRUE
){
  if (missing(pkg) || !nzchar(pkg)) {
    stop("Argument 'pkg' (child package name) is required.", call. = FALSE)
  }
  ns_path <- tryCatch(getNamespaceInfo(asNamespace(pkg), "path"), error = function(e) "")
  if (!nzchar(ns_path)) {
    stop("Child package not installed or not loaded: ", pkg, call. = FALSE)
  }
  yml <- file.path(ns_path, "golem-config.yml")
  if (!file.exists(yml)) {
    stop("Child package has no golem-config.yml: ", pkg, call. = FALSE)
  }
  config::get(
    value = value,
    config = config,
    file = yml,
    use_parent = use_parent
  )
}

# Single required literal occurrence for golem name check
app_sys <- function(...){
  system.file(..., package = "GolemKpiSnapshotSuite")
}

.pkg_file <- function(pkg, ...){
  ns <- tryCatch(getNamespaceInfo(asNamespace(pkg), "path"), error = function(e) "")
  if (!nzchar(ns)) return("")
  file.path(ns, ...)
}
