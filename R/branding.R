#' Shared branding assets
#' @param prefix resource path prefix
#' @export
kpi_branding <- function(prefix = "gkss"){
  root <- system.file("app","www", package = "GolemKpiSnapshotSuite")
  if (root == "" || !dir.exists(root)) return(htmltools::tagList())
  if (is.null(shiny::getResourcePaths()[[prefix]])){
    shiny::addResourcePath(prefix, root)
  }
  deps <- list()
  for (css in c("litera_style.css","custom.css")){
    f <- file.path(root, css)
    if (file.exists(f)){
      deps[[css]] <- htmltools::htmlDependency(
        name = sub("\\.css$","", css),
        version = "1.0",
        src = c(href = prefix),
        stylesheet = css
      )
    }
  }
  fav <- NULL
  for (icon in c("favicon.png","favicon.ico")){
    if (file.exists(file.path(root, icon))){
      fav <- htmltools::tags$link(rel="icon", href = sprintf("/%s/%s", prefix, icon))
      break
    }
  }
  htmltools::tagList(deps, fav)
}

#' Logo tag
#' @param file image filename in inst/app/www
#' @export
kpi_logo <- function(file = "ut.png", prefix = "gkss", ...){
  htmltools::tags$img(
    src = sprintf("/%s/%s", prefix, file),
    alt = "Logo",
    ...
  )
}
