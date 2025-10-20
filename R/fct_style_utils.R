#' style_utils
#'
#' Title logo component (mobile layout mimic)
#'
#' Mobile KPI style top bar (logo left, title right)
#' @param text Title text
#' @param prefix Resource path prefix (from kpi_branding)
#' @param logo_src Logo file name in inst/app/www
#' @param width,height Logo size (px)
#' @param show_logo Show logo?
#' @export
title_logo <- function(
    text      = getOption("gkss.app_title", "Enrollment KPI"),
    prefix    = "gkss",
    logo_src  = "ut.png",
    width     = 80,
    height    = 40,
    show_logo = TRUE
){
  logo_tag <- if (isTRUE(show_logo)) shiny::tags$img(
    src   = sprintf("%s/%s", prefix, logo_src),
    width = width,
    height = height,
    alt   = "UT",
    style = "display:block;margin:0;"
  ) else NULL

  shiny::div(
    class = "ut-brand-bar",
    logo_tag,
    shiny::span(
      text,
      class = "ut-brand-title"
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
