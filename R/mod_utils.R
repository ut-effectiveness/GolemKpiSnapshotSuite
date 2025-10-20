#' @keywords internal
# Normalizes any device_type input (reactive, function, list, char)
normalize_device <- function(x){
  if (inherits(x,"reactive")) x <- x()
  else if (is.function(x)) {
    tmp <- try(x(), silent=TRUE)
    if(!inherits(tmp,"try-error")) x <- tmp
  }
  if (is.list(x) && !is.null(x$device)) x <- x$device
  x <- tolower(as.character(x)[1])
  if(!x %in% c("desktop","mobile","tablet")) x <- "desktop"
  x
}