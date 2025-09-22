#' Shared KPI branding assets
#' @param prefix resource path prefix
#' @param include_css include custom.css & litera_style.css
#' @export
kpi_branding <- function(prefix = "gkss", include_css = TRUE){
  root <- system.file("app","www", package = "GolemKpiSnapshotSuite")
  if (root == "" || !dir.exists(root)) return(htmltools::tagList())
  if (is.null(shiny::getResourcePaths()[[prefix]])){
    shiny::addResourcePath(prefix, root)
  }
  deps <- list()
  if (include_css){
    for (css in c("custom.css","litera_style.css")){
      if (file.exists(file.path(root, css))){
        deps[[css]] <- htmltools::htmlDependency(
          name = sub("\\.css$","", css),
          version = "1.0",
            src = c(href = prefix),
          stylesheet = css
        )
      }
    }
  }
  fav <- NULL
  if (file.exists(file.path(root,"favicon.png"))){
    fav <- htmltools::tags$link(rel="icon", href = sprintf("%s/favicon.png", prefix))
  }
  htmltools::tagList(deps, fav)
}

#' Logo tag
#' @param file image filename in inst/app/www
#' @param prefix resource prefix
#' @export
kpi_logo <- function(file = "ie_logo.png", prefix = "gkss", ...){
  htmltools::tags$img(src = sprintf("%s/%s", prefix, file), alt = "Logo", ...)
}
