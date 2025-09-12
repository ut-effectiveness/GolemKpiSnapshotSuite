#' get_data_from_pin
#'
#' @description This function pulls data from the daily enrollment pin.
#'
#' @return Returns a data frame from the daily enrollment pin.
#' @export
#'
get_data_from_pin <- function() {

  pin_name <- 'rsconnectapi!service/daily_enrollment_pin'

  # Obtain the API key from environment variable.
  api_key <- Sys.getenv("RSCONNECT_SERVICE_USER_API_KEY")
  # If API key is not available as environment variable, use keyring entry.
  # NOTE: The API key should only be an environment variable on the server
  #       For local machines, set a keyring entry.
  if (api_key == "") {
    api_key <- keyring::key_get("pins", "api_key")
  }

  board_rsc = pins::board_connect(
    auth = "manual",
    account = "rsconnectapi!service",
    #server ="https://rs-connect.utahtech.edu", # old server
    server = "https://connect.ie.utahtech.edu/", # new server
    key = api_key)

  pins::pin_read(board=board_rsc, name = pin_name)
}


#' make_current_data
#'
#' @description This function pulls the latest term, and the previous terms data
#'
#' The current term of interest is the term we are watching the headcount for. The
#' current term is the term the university is currently in. The previous term of
#' interest is the term we want to compare the current term of interest to.
#'
#' @return Returns a data frame from the current term of interest and the previous term.
#'
#'
make_current_data <- function() {

  get_data_from_pin() %>%
    dplyr::filter(.data[["term_id"]] %in% c('202240', '202340')) %>%
    tidyr::unnest(cols = .data[["data"]])
}

#' get_current_dtcs
#'
#' @description This function returns the current days to class start dtcs
#'
#' The days to class start is a measure of how many days before the start of classes
#' an events fall on. The first day of class has a dtcs of 0. The days are negative
#' prior to the start of the semester, and positive after the start of the semester.
#'
#' @return An integer
#'
get_current_dtcs <- function() {

  make_current_data() %>%
    dplyr::filter(.data[["term_id"]] == '202340') %>%
    dplyr::select(.data[["days_to_class_start"]]) %>%
    max()
}


