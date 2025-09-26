#' style_utils
#'
#' Title logo component (mobile layout mimic)
#'
#' @param text Title text.
#' @param logo Show logo (TRUE/FALSE).
#' @param prefix Resource path prefix registered by kpi_branding().
#' @param logo_src Logo filename under inst/app/www.
#' @param width Logo width
#' @param hight Logo height
#' @export
title_logo <- function(
  text     = getOption("gkss.app_title", "Enrollment KPI"),
  logo     = TRUE,
  prefix   = "gkss",
  logo_src = "ut.png",
  width    = 80,
  height   = 40
){
  img_tag <- if (isTRUE(logo)) shiny::tags$img(
    src   = sprintf("%s/%s", prefix, logo_src),
    width = width,
    height = height,
    alt   = "Logo",
    style = "display:block;margin:0;"
  ) else NULL

  shiny::div(
    class = "app-brand-inline",
    img_tag,
    shiny::span(
      text,
      class = "app-brand-text",
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
