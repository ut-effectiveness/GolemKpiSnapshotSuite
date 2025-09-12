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
#'
#' @return   A {pins} board object
get_pins_board <- function() {
  if (is_connect()) {
    return(pins::board_connect())
  }

  pins::board_connect(
    server = get_golem_config("connect_server"),
    account = get_golem_config("connect_account"),
    key = get_golem_config("connect_api_key")
  )
}

#' Is the app running on Connect?
#'
#' @return   Boolean. TRUE if the app is running on a Connect server.

is_connect <- function() {
  # This environment variable is "rsconnect" when running on a Connect server.
  context <- Sys.getenv("R_CONFIG_ACTIVE", "")
  return(context == "rsconnect")
}
