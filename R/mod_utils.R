#' @keywords internal
normalize_device <- function(x){
  if (inherits(x, "reactive")) x <- x()
  if (is.list(x) && !is.null(x$device)) x <- x$device
  x <- tolower(as.character(x)[1])
  if (!x %in% c("desktop","mobile","tablet")) x <- "desktop"
  x
}