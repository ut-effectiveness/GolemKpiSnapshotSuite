#' Create an object for importing R objects from files
#'
#' @param   path   Scalar character. The filepath to the data to be imported.
#'
#' @return   A `file_importer` object (parent: `data_importer`) to be used when importing data.
#' @export

file_importer <- function(path) {
  x <- structure(
    list(path = path),
    class = c("file_importer", "data_importer")
  )

  x
}

#' Create an object for importing R objects from pin boards
#'
#' @param   board   The pin board.
#' @param   name   The name of the pin on the pin board.
#'
#' @return   A `pin_importer` object (parent: `data_importer`) to be used when importing data from
#'   the pin.
#' @export

pin_importer <- function(board, name) {
  x <- structure(
    list(
      board = board,
      name = name
    ),
    class = c("pin_importer", "data_importer")
  )

  x
}

#' Import an object from a file or pin, or from a SQL query
#'
#' @param   x   A `data_importer` object
#' @param   ...   Further arguments.
#'
#' @return   The imported object (typically a data-frame)
#'
#' @export

import <- function(x, ...) {
  UseMethod("import", x)
}

#' @export
import.file_importer <- function(x, ...) {
  path <- x[["path"]]
  ext <- tolower(tools::file_ext(path))

  if (ext == "csv") {
    readr::read_csv(path, col_types = readr::cols())
  } else if (ext == "rds") {
    readRDS(path)
  } else {
    stop("Unsupported file extension/format in import.file_importer: ", path)
  }
}

#' @export
import.pin_importer <- function(x, ...) {
  pins::pin_read(board = x[["board"]], name = x[["name"]], ...)
}
