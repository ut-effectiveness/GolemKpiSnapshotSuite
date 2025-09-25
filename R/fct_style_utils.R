#' style_utils
#'
#' Create title logo
#'
#' Returns UT logo with correct dimensions for app title.
#'
#' @export
title_logo <- function(){
  shiny::div(
    style = "display:flex;align-items:center;gap:10px;",
    shiny::tags$img(
      src = "www/ut.png",
      width = 80, height = 40,
      alt = "UT Logo",
      style = "display:block;margin:0;"
    ),
    shiny::span(
      "Enrollment KPI",
      style = "font-size:22pt;font-weight:600;line-height:1;"
    )
  )
}

#' Simple Litera theme (system fonts only)
#' @export
litera_theme <- function(){
  bslib::bs_theme(
    bootswatch = "litera",
    primary    = "#003058",
    secondary  = "#a50000",
    base_font  = "Helvetica Neue, Arial, sans-serif",
    heading_font = "Helvetica Neue, Arial, sans-serif"
  )
}
