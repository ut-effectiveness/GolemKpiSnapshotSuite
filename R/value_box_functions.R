# --- Generic Helper Functions ---

#' Title
#'
#' @param data a data frame with a single row
#' @param var_name the name of the variable to use
#' @param threshold the threshold value to compare against
#' @param neg a string to display if the value is above the threshold
#' @param pos a string to display if the value is below the threshold
#'
#' @returns a goal string
#' @export
#'
get_val_box_goal_generic <- function(data, var_name, threshold = 0, neg = " still needed ", pos = " ahead ") {
  value <- data[[var_name]]

  if (value > threshold) {
    paste0(scales::comma(abs(value - threshold)), neg)
  } else if (value < threshold) {
    paste0(scales::comma(abs(value - threshold)), pos)
  } else {
    "on target"
  }
}

get_val_box_title_generic <- function(data, var_name, scale = 100, prefix = TRUE) {
  percentage <- round(data[[var_name]] * scale, 1)
  if (!prefix) return(paste0(" ", percentage, "%"))

  if (percentage > 0) {
    paste0(" up ", percentage, "%")
  } else if (percentage < 0) {
    paste0(" down ", abs(percentage), "%")
  } else {
    " percentage change is 0"
  }
}

#' get_val_box_arrow_generic
#'
#' @param data a data frame with a single row
#' @param var_name the name of the variable to use
#' @param threshold the threshold value to compare against
#'
#' @returns a bsicon
#' @export
#'
get_val_box_arrow_generic <- function(data, var_name, threshold = 0) {
  change <- data[[var_name]]
  if (change > threshold) {
    bsicons::bs_icon("arrow-up-circle")
  } else if (change < threshold) {
    bsicons::bs_icon("arrow-down-circle")
  } else {
    bsicons::bs_icon("dash-circle-fill")
  }
}

#' get_val_box_text_class_generic
#'
#' @param data a data frame with a single row
#' @param var_name the name of the variable to use
#' @param threshold the threshold value to compare against
#'
#' @returns a text class
#' @export
#'
get_val_box_text_class_generic <- function(data, var_name, threshold = 0) {
  change <- data[[var_name]]
  if (change > threshold) {
    "text-success"
  } else if (change < threshold) {
    "text-danger"          # was text-primary
  } else {
    "text-secondary"       # better neutral than text-light
  }
}

#' get_val_box_color_generic
#'
#' @param data a data frame with a single row
#' @param var_name the name of the variable to use
#' @param threshold the threshold value to compare against
#'
#' @returns a theme color
#' @export
#'
get_val_box_color_generic <- function(data, var_name, threshold = 0) {
  change <- data[[var_name]]
  if (change > threshold) {
    "success"
  } else if (change < threshold) {
    "danger"               # was primary
  } else {
    "secondary"
  }
}

# --- Config List ---

value_box_config <- list(
  Total = list(
    title = function(data) get_val_box_title_generic(data, "Percent Change", scale = 100, prefix = TRUE),
    format = function(val) scales::comma(val),
    goal = function(data) get_val_box_goal_generic(data, "Previous Year", threshold = data[["Current Year"]]),
    showcase = function(data) bsicons::bs_icon("people"),
    color = function(data) get_val_box_color_generic(data, "Percent Change", threshold = 0),
    class = NULL
  ),

  TotalHousing = list(
    title = function(data) get_val_box_title_generic(data, "Percent Change", scale = 100, prefix = TRUE),
    format = function(val) paste0(val, "%"),
    goal = function(data) get_val_box_goal_generic(data, "difference", threshold = 1, neg = " ahead ", pos = " still needed"),
    showcase = function(data) bsicons::bs_icon("house"),
    color = function(data) get_val_box_color_generic(data, "difference", threshold = 1),
    class = NULL
  ),

  Student = list(
    title = function(data) get_val_box_title_generic(data, "Percent Change", scale = 100, prefix = TRUE),
    format = function(val) scales::comma(val),
    goal = function(data) get_val_box_goal_generic(data, "Previous Year", threshold = data[["Current Year"]]),
    showcase = function(data) get_val_box_arrow_generic(data, "Percent Change", threshold = 0),
    color = function(data) "alert",
    class = function(data) get_val_box_text_class_generic(data, "Percent Change", threshold = 0)
  ),

  Housing = list(
    title = function(data) get_val_box_title_generic(data, "Percent Change", scale = 1, prefix = FALSE),
    format = function(val) scales::comma(val),
    goal = function(data) get_val_box_goal_generic(data, "difference", threshold = 0, pos = " beds available ", neg = " over capacity "),
    showcase = function(data) get_val_box_arrow_generic(data, "difference", threshold = 1),
    color = function(data) "alert",
    class = function(data) get_val_box_text_class_generic(data, "difference", threshold = 1)
  ),

TotalRetention = list(
    title = function(data) get_val_box_title_generic(data, "Percent Change", scale = 100, prefix = TRUE),
    format = function(val) paste0(round(val, 1), "%"),
    goal = function(data) get_val_box_goal_generic(data, "Previous Year", threshold = data[["Current Year"]], neg = "% still needed ", pos = "% ahead "),
    showcase = function(data) bsicons::bs_icon("people"),
    color = function(data) get_val_box_color_generic(data, "Percent Change", threshold = 0),
    class = NULL
  ),

Retention = list(
    title = function(data) get_val_box_title_generic(data, "Percent Change", scale = 100, prefix = TRUE),
    format = function(val) paste0(round(val, 1), "%"),
    goal = function(data) get_val_box_goal_generic(data, "Previous Year", threshold = data[["Current Year"]], neg = "% still needed ", pos = "% ahead "),
    showcase = function(data) get_val_box_arrow_generic(data, "Percent Change", threshold = 0),
    color = function(data) "alert",
    class = function(data) get_val_box_text_class_generic(data, "Percent Change", threshold = 0)
  )
)


# --- Main Function ---

#' get_value_box
#'
#' @param data a data frame with a single row
#' @param metric the metric to display
#' @param lookup a data frame with two columns: metric and test
#'
#' @returns A value box
#' @export
#'
get_value_box <- function(data, metric, lookup) {
  data <- data[[metric]]
  type <- lookup[lookup[[1]] == metric, ][["test"]]

  config <- value_box_config[[type]]
  if (is.null(config)) stop(paste("Unknown value box type:", type))

  bslib::value_box(
    title = paste0(data[["Student Type"]], config$title(data)),
    value = config$format(data[["Current Year"]]),
    p(config$goal(data)),
    showcase = config$showcase(data),
    theme_color = config$color(data),
    class = if (!is.null(config$class)) config$class(data) else NULL
  )
}
# (No raw CSS below this point)
