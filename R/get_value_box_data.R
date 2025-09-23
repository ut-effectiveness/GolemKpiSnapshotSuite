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

get_val_box_text_class_generic <- function(data, var_name, threshold = 0) {
  change <- data[[var_name]]
  if (change > threshold) {
    "text-success"
  } else if (change < threshold) {
    "text-danger"          # CHANGED from text-primary
  } else {
    "text-secondary"       # CHANGED from text-light (better contrast)
  }
}

get_val_box_color_generic <- function(data, var_name, threshold = 0) {
  change <- data[[var_name]]
  if (change > threshold) {
    "success"
  } else if (change < threshold) {
    "danger"               # CHANGED from primary
  } else {
    "secondary"
  }
}

# In value_box_config you can leave Student/Housing/Retention ‘color = function(data) "alert"’,
# but “alert” is not a Bootstrap context; set to NULL if unnecessary, or reuse get_val_box_color_generic.
# Example (optional):
# color = function(data) NULL

