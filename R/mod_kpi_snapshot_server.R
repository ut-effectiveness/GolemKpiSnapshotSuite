#' KPI Snapshot Server Module
#' @export
mod_kpi_snapshot_server <- function(id, custom_server = NULL) {
  moduleServer(id, function(input, output, session) {
    # Mother server logic here

    # Call custom server function if provided
    if (!is.null(custom_server)) custom_server(input, output, session)
  })
}
