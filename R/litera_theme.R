#' Shared Litera theme (ported from mobileCabinetKpi)
#' @export
litera_theme <- function() {
  bslib::bs_theme(
    bootswatch = "litera",
    base_font = bslib::font_google("Helvetica Neue", fallback = "Arial, sans-serif"),
    primary = "#003058",
    secondary = "#a50000"
  )
}