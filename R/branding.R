#' Register parent asset path + (optionally) navbar CSS only
#' @param prefix resource path prefix
#' @param include_navbar logical include navbar.css
#' @export
kpi_branding <- function(prefix = "gkss", include_navbar = TRUE){
  root <- system.file("app","www", package = "GolemKpiSnapshotSuite")
  if (!nzchar(root) || !dir.exists(root))
    return(htmltools::tagList())

  shiny::addResourcePath(prefix, root)

  deps <- list()
  if (include_navbar) {
    css <- "navbar.css"
    if (file.exists(file.path(root, css))) {
      deps[[1]] <- htmltools::htmlDependency(
        name = "gkss-navbar",
        version = as.character(utils::packageVersion("GolemKpiSnapshotSuite")),
        src = c(href = prefix),
        stylesheet = css
      )
    }
  }

  # favicon (optional)
  fav <- NULL
  for (icon in c("favicon.png","favicon.ico","favicon.svg")){
    if (file.exists(file.path(root, icon))){
      fav <- htmltools::tags$link(rel="icon", href = sprintf("%s/%s", prefix, icon))
      break
    }
  }
  htmltools::tagList(deps, fav)
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
