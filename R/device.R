#' Detect client device type
#'
#' Uses shinybrowser (if available) to classify the client device.
#' Falls back to "unknown" if detection not yet available.
#'
#' @return A length-1 character value: "mobile", "tablet", "desktop", or "unknown".
#' @export
device <- function() {
  if (!requireNamespace("shinybrowser", quietly = TRUE)) {
    return("unknown")
  }
  info <- shinybrowser::get_device()
  # shinybrowser::get_device() returns a list; element 'device' often "Desktop" etc.
  if (is.null(info) || is.null(info$device)) return("unknown")
  tolower(info$device)
}