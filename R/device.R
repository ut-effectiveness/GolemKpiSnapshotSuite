#' Detect client device info (robust)
#'
#' Returns a list with at least element `device` (lowercase: mobile|tablet|desktop|unknown).
#' Safe even if shinybrowser not ready yet.
#'
#' @return list(device = <chr>, ... possible extra fields)
#' @export
device <- function() {
  if (!requireNamespace("shinybrowser", quietly = TRUE)) {
    return(list(device = "unknown"))
  }
  info <- shinybrowser::get_device()
  # Not ready yet
  if (is.null(info)) return(list(device = "unknown"))
  # If already a list containing $device
  if (is.list(info) && !is.null(info$device)) {
    info$device <- tolower(info$device)
    return(info)
  }
  # If atomic (character) fallback
  return(list(device = tolower(as.character(info)[1])))
}