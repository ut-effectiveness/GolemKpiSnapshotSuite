#' Access the pins board that contains data for this app
#'
#' If running outside of Connect, this requires the {pins} server/account/key to be defined in the
#' {golem} config for this app. These values are typically stored in the environment variables
#' `CONNECT_SERVER`, `CONNECT_ACCOUNT` and `RSCONNECT_SERVICE_USER_API_KEY`. They are accessed from
#' the fields `connect_server`, `connect_account`, `connect_api_key` in the config.
#'
#' If the API key is not available as an environment variable, a keyring entry is used.
#' NOTE: The API key should only be an environment variable on the server. For local machines, set a
#' keyring entry.
#'
#' If running on Connect, the server/account/key information is not used.
#' @export
#' @return   A {pins} board object
get_pins_board <- function(
  config_file = NULL,
  server_key = "connect_server",
  account_key = "connect_account",
  api_key_key = "connect_api_key"
) {
  # 1. Resolve config file
  resolve_config <- function() {
    # explicit param
    if (!is.null(config_file) && file.exists(config_file)) return(config_file)
    # env var override
    env_path <- Sys.getenv("GOLEM_KPI_CONFIG_FILE", "")
    if (nzchar(env_path) && file.exists(env_path)) return(env_path)
    # this package's own
    self <- system.file("golem-config.yml", package = "GolemKpiSnapshotSuite")
    if (nzchar(self) && file.exists(self)) return(self)
    # look through loaded namespaces (app packages)
    for (pkg in loadedNamespaces()) {
      p <- system.file("golem-config.yml", package = pkg)
      if (nzchar(p) && file.exists(p)) return(p)
      p2 <- system.file("config.yml", package = pkg)
      if (nzchar(p2) && file.exists(p2)) return(p2)
    }
    ""
  }

  cfg_path <- resolve_config()
  if (!nzchar(cfg_path) || !file.exists(cfg_path)) {
    stop("No config file found (looked for golem-config.yml or config.yml in loaded packages).",
         call. = FALSE)
  }

  getv <- function(k) config::get(k, file = cfg_path)

  server  <- Sys.getenv("CONNECT_SERVER",  getv(server_key))
  account <- Sys.getenv("CONNECT_ACCOUNT", getv(account_key))
  api_key <- Sys.getenv("RSCONNECT_SERVICE_USER_API_KEY", getv(api_key_key))

  pins::board_connect(server = server, account = account, key = api_key)
}

#' Is the app running on Connect?
#'
#' @export
#' @return   Boolean. TRUE if the app is running on a Connect server.

is_connect <- function() {
  # This environment variable is "rsconnect" when running on a Connect server.
  context <- Sys.getenv("R_CONFIG_ACTIVE", "")
  return(context == "rsconnect")
}
