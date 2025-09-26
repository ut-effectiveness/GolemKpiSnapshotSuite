#' style_utils
#'
#' Create title logo
#'
#' Returns UT logo with correct dimensions for app title.
#'
#' @export
title_logo <- function(
  text       = getOption("gkss.app_title", "Enrollment KPI"),
  logo       = TRUE,
  logo_src   = "ut.png",
  prefix     = "gkss",
  width      = 80,
  height     = 40,
  class      = "app-brand-left",
  text_class = "app-brand-text"
){
  img_tag <- if (isTRUE(logo)) shiny::tags$img(
    src   = paste0(prefix, "/", logo_src),
    width = width,
    height = height,
    alt   = "Logo",
    style = "display:block;margin:0;"
  ) else NULL

  shiny::div(
    class = class,
    style = "display:flex;align-items:center;gap:10px;",
    img_tag,
    shiny::span(
      text,
      class = text_class,
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
