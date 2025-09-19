#' Transform raw metric rows into value box data
#'
#' @param data A data.frame / tibble containing metric rows.
#' @param rows Character vector of metric identifiers to keep.
#' @return A tibble with columns required by value box renderers.
#' @export
get_value_box_data <- function(data, rows){

  # Going to change moving forward
  # Chnaged to grab more columns for "Goal" and "Colour" functions
  l = purrr::map(rows, ~data[data[["Student Type"]] == .x, ])

  names(l) = rows

  l
}

