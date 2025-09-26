#' style_utils
#'
#' Create title logo
#'
#' Returns UT logo with correct dimensions for app title
#'
#' @param text Title string (defaults to option gkss.app_title or "Enrollment KPI")
#' @param logo Include logo image
#' @param logo_src Image filename in inst/app/www
#' @param prefix Resource path prefix added by kpi_branding()
#' @param width,height Logo dimensions (px)
#' @param class Wrapper div class
#' @param text_class CSS class for title text
#' @export
#'
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
    style = "display:flex;align-items:center;gap:10px;",
    img_tag,
    shiny::span(
      text,
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
