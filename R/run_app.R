#' Run Demo App (for development only)
#' @export
run_app <- function() {
  shiny::shinyApp(
    ui = mod_kpi_snapshot_ui("kpi"),
    server = function(input, output, session) {
      mod_kpi_snapshot_server("kpi")
    }
  )
}
