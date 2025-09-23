#' Shared Litera theme (same as mobileCabinetKpi)
#' @export
litera_theme <- function() {
  bslib::bs_theme(
    bootswatch = "litera",
    primary    = "#003058",
    secondary  = "#a50000",
    base_font  = bslib::font_google("Helvetica Neue", fallback = "Arial, sans-serif")
  )
}