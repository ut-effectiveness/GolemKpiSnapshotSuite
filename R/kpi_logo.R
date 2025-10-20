#' Simple logo (ut.png) from parent assets
#' @export
kpi_logo <- function(height = "48px", prefix = "gkss"){
  root <- system.file("app","www", package = "GolemKpiSnapshotSuite")
  if (!nzchar(root)) return(tags$span("[Logo missing]"))
  shiny::addResourcePath(prefix, root)
  if (!file.exists(file.path(root, "ut.png")))
    return(tags$span("[Logo missing]"))
  tags$img(src = sprintf("%s/%s", prefix, "ut.png"),
           height = height, alt = "Logo",
           style = "vertical-align:middle;display:inline-block;")
}