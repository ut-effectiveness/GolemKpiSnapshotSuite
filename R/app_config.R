.gkss_state <- new.env(parent = emptyenv())
.gkss_state$default_child <- NULL

#' Set default child package for config lookups
#' @param pkg child package name
#' @export
set_default_child_pkg <- function(pkg){
  stopifnot(is.character(pkg), length(pkg) == 1, nzchar(pkg))
  .gkss_state$default_child <- pkg
  invisible(pkg)
}

#' Read a config value from a child golem-config.yml
#' @export
get_golem_config <- function(
  value,
  pkg,
  config = Sys.getenv("GOLEM_CONFIG_ACTIVE", Sys.getenv("R_CONFIG_ACTIVE", "default")),
  use_parent = TRUE
){
  if (missing(pkg) || !nzchar(pkg)) {
    pkg <- .gkss_state$default_child
    if (is.null(pkg) || !nzchar(pkg)) {
      stop("Argument 'pkg' (child package name) is required. Set via pkg= or set_default_child_pkg().", call. = FALSE)
    }
  }
  ns_path <- tryCatch(getNamespaceInfo(asNamespace(pkg), "path"), error = function(e) "")
  if (!nzchar(ns_path)) stop("Child package not installed or loaded: ", pkg, call. = FALSE)
  candidates <- c(file.path(ns_path, "golem-config.yml"),
                  file.path(ns_path, "inst", "golem-config.yml"))
  yml <- candidates[file.exists(candidates)][1]
  if (is.na(yml) || !nzchar(yml)) stop("Child package has no golem-config.yml: ", pkg, call. = FALSE)
  config::get(value = value, config = config, file = yml, use_parent = use_parent)
}

app_sys <- function(...){
  system.file(..., package = "GolemKpiSnapshotSuite")
}
