#' style_utils
#'
#' Create title logo
#'
#' Returns UT logo with correct dimensions for app title.
#'
#' @return The return value, if any, from executing the function.
#' @export
#' @noRd

title_logo = function() {
  shiny::div(
    style = "text-align: justify; width:150;",
    shiny::tags$img(
      style = "display: block;
               margin-left:5px;
               margin-top:0px;
               margin-bottom:0px",
      src = "www/ut.png",
      width = "80",
      height = "40",
      alt = "UT Data"
    ),
    shiny::span("Enrollment KPI",
                style = "position: absolute;
                font-size: 22pt;
                right: 80px;
                top: 0px;
                margin-top: 10px;")
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
