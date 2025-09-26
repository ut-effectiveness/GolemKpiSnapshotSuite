#' style_utils
#'
#' Title logo component (mobile layout mimic)
#'
#' @param text Title text.
#' @param logo Show logo (TRUE/FALSE).
#' @param prefix Resource path prefix registered by kpi_branding().
#' @param logo_src Logo filename under inst/app/www.
#' @param width,height Logo dimensions (px).
#' @param container_width Outer div width (px) to mimic original fixed layout.
#' @param text_font_size CSS font-size for title text.
#' @param text_offset_right Distance (px) from right edge (kept from original).
#' @param text_margin_top Additional top margin (px) for the text span.
#' @export
title_logo <- function(
  text              = getOption("gkss.app_title", "Enrollment KPI"),
  logo              = TRUE,
  prefix            = "gkss",
  logo_src          = "ut.png",
  width             = 80,
  height            = 40,
  container_width   = 150,
  text_font_size    = "22pt",
  text_offset_right = 80,
  text_margin_top   = 10
){
  img_tag <- if (isTRUE(logo)) shiny::tags$img(
    src   = sprintf("%s/%s", prefix, logo_src),
    width = width,
    height = height,
    alt   = "Logo",
    style = "display:block;margin-left:5px;margin-top:0;margin-bottom:0;"
  ) else NULL

  shiny::div(
    style = sprintf(
      "position:relative;text-align:justify;width:%dpx;height:%dpx;display:block;",
      container_width, height
    ),
    img_tag,
    shiny::span(
      text,
      style = sprintf(
        "position:absolute;font-size:%s;right:%dpx;top:0;margin-top:%dpx;line-height:1;",
        text_font_size, text_offset_right, text_margin_top
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
