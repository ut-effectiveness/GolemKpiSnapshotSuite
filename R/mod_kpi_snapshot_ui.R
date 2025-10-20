#' KPI Snapshot UI Module
#' @param id module id
#' @importFrom shiny NS tagList uiOutput
#' @noRd
#' @export
kpi_snapshot_inner_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("value_boxes_ui")),
    uiOutput(ns("plots_ui"))
  )
}

#' mod_kpi_snapshot_ui
#' @param id module id
#' @param custom_ui Optional custom UI elements to insert into the module.
#' @importFrom shiny NS tagList uiOutput
#' @noRd
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
