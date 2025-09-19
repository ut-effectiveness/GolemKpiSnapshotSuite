#' KPI Snapshot Server Module
#' @import shiny
#' @param id Module id.
#' @param custom_server Optional function to override server internals.
#' @noRd
#' @export
mod_kpi_snapshot_server <- function(id, custom_server = NULL) {
  moduleServer(id, function(input, output, session) {
    # Mother server logic here

    # Call custom server function if provided
    if (!is.null(custom_server)) custom_server(input, output, session)
  })
}
