#' @keywords internal
normalize_device <- function(x){
  # If reactive
  if (inherits(x, "reactive")) {
    x <- x()
  } else if (is.function(x)) {
    # reactive passed without calling
    tmp <- try(x(), silent = TRUE)
    if(!inherits(tmp,"try-error")) x <- tmp
  }
  # If list with $device
  if (is.list(x) && !is.null(x$device)) x <- x$device
  # Coerce
  x <- tolower(as.character(x)[1])
  if (!x %in% c("desktop","mobile","tablet")) x <- "desktop"
  x
}