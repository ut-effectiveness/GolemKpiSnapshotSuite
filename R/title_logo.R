#' Title logo UI fragment
#'
#' @param file image filename inside inst/app/www
#' @param height CSS height (character).
#' @param alt alt text
#' @param prefix resource path prefix (auto-added if needed)
#' @export
title_logo <- function(file = "ie_logo.png",
                       height = "40px",
                       alt = "Logo",
                       prefix = "gkss") {

  # Locate installed file
  p <- system.file("app","www", file, package = "GolemKpiSnapshotSuite")
  if (!nzchar(p)) {
    return(tags$span("[Logo missing]"))
  }

  # Register resource path once
  if (is.null(shiny::getResourcePaths()[[prefix]])) {
    shiny::addResourcePath(prefix, system.file("app","www", package="GolemKpiSnapshotSuite"))
  }

  tags$img(
    src   = sprintf("%s/%s", prefix, file),
    height = height,
    alt    = alt,
    style  = "vertical-align:middle;"
  )
}