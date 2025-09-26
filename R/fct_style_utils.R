#' style_utils
#'
#' Title logo component (mobile layout mimic)
#'
#' @export
title_logo <- function(
    text     = getOption("gkss.app_title", "Enrollment KPI"),
    prefix   = "gkss",
    logo_src = "ut.png",
    width    = 80,
    height   = 40,
    text_size = "22pt",
    text_right = 80,   # px from right edge
    text_top   = 0,    # px from top
    text_margin_top = 10,
    container_width = 150
){
  shiny::div(
    style = sprintf(
      "position:relative;text-align:justify;width:%dpx;height:%dpx;",
      container_width, height
    ),
    shiny::tags$img(
      style = "display:block;margin-left:5px;margin-top:0;margin-bottom:0;",
      src   = sprintf("%s/%s", prefix, logo_src),
      width = width,
      height = height,
      alt   = "UT Data"
    ),
    shiny::span(
      text,
      style = sprintf(
        "position:absolute;font-size:%s;right:%dpx;top:%dpx;margin-top:%dpx;line-height:1;",
        text_size, text_right, text_top, text_margin_top
      )
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
