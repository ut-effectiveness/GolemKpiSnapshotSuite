#' KPI Snapshot UI Module
#' @export
mod_kpi_snapshot_ui <- function(id, custom_ui = NULL) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::h2("Mother Package Header"),
    # Insert custom UI passed from daughter app
    if (!is.null(custom_ui)) custom_ui,
    shiny::div("Mother footer")
  )
}
