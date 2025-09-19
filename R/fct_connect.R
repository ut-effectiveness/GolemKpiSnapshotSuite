#' Access the pins board that contains data for this app
#'
#' @export
#' @return A pins board object
get_pins_board <- function(
  config_file = NULL,
  server_key = "connect_server",
  account_key = "connect_account",
  api_key_key = "connect_api_key"
) {
  resolve_config <- function() {
    if (!is.null(config_file) && file.exists(config_file)) return(config_file)
    env_path <- Sys.getenv("GOLEM_KPI_CONFIG_FILE", "")
    if (nzchar(env_path) && file.exists(env_path)) return(env_path)
    self <- app_sys("golem-config.yml")
    if (nzchar(self) && file.exists(self)) return(self)
    for (pkg in loadedNamespaces()) {
      if (identical(pkg, "GolemKpiSnapshotSuite")) next
      ns_path <- tryCatch(getNamespaceInfo(asNamespace(pkg), "path"), error = function(e) "")
      if (!nzchar(ns_path)) next
      cand1 <- file.path(ns_path, "golem-config.yml")
      if (file.exists(cand1)) return(cand1)
      cand2 <- file.path(ns_path, "config.yml")
      if (file.exists(cand2)) return(cand2)
    }
    ""
  }

  cfg_path <- resolve_config()
  if (!nzchar(cfg_path) || !file.exists(cfg_path)) {
    stop("No config file found (golem-config.yml / config.yml).", call. = FALSE)
  }

  getv <- function(k) config::get(k, file = cfg_path)

  server  <- Sys.getenv("CONNECT_SERVER",  getv(server_key))
  account <- Sys.getenv("CONNECT_ACCOUNT", getv(account_key))
  api_key <- Sys.getenv("RSCONNECT_SERVICE_USER_API_KEY", getv(api_key_key))

  pins::board_connect(server = server, account = account, key = api_key)
}

#' Is the app running on Connect?
#' @export
#' @return logical
is_connect <- function() {
  Sys.getenv("R_CONFIG_ACTIVE", "") == "rsconnect"
}
