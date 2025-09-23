#' Shared branding assets
#' @export
kpi_branding <- function(prefix = "gkss"){
  root <- system.file("app","www", package = "GolemKpiSnapshotSuite")
  if (!nzchar(root) || !dir.exists(root)) return(htmltools::tagList())
  shiny::addResourcePath(prefix, root)
  htmltools::tagList()
}

#' Logo tag
#' @export
kpi_logo <- function(file = "ut.png", prefix = "gkss", height = "40px", alt = "Logo"){
  root <- system.file("app","www", package = "GolemKpiSnapshotSuite")
  if (!nzchar(root) || !file.exists(file.path(root, file))) {
    return(htmltools::tags$span("[Logo missing]"))
  }
  shiny::addResourcePath(prefix, root)
  htmltools::tags$img(
    src = sprintf("%s/%s", prefix, file),
    height = height,
    alt = alt,
    style = "vertical-align:middle;display:inline-block;"
  )
}
