#' style_utils
#'
#' Create title logo
#'
#' Returns UT logo with correct dimensions for app title.
#'
#' @return The return value, if any, from executing the function.
#' @export
#' @noRd

title_logo <- function(
  text        = getOption("gkss.app_title", "Enrollment KPI"),
  logo        = TRUE,
  logo_src    = "www/ut.png",
  logo_width  = 80,
  logo_height = 40,
  class       = "app-brand-left",
  text_class  = "app-brand-text"
){
  img_tag <- if (isTRUE(logo)) shiny::tags$img(
    src = logo_src,
    width = logo_width,
    height = logo_height,
    alt = "Logo",
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


#' Litera Bootstrap Theme for Shiny UI
#'
#' @return A bslib theme object using the Litera Bootswatch theme.
#' @export
#'
litera_theme = function() {
  bslib::bs_theme(
    bootswatch = "litera",
    bg = "#FFFFFF", fg = "#000",
    primary = "#B5302A",
    base_font = bslib::font_google("Source Serif Pro"),
    heading_font = bslib::font_google("Josefin Sans", wght = 100)
  )
}
