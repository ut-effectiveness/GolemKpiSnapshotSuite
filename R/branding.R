#' Register parent assets & inject navbar + value box styling
#' @param prefix resource path prefix
#' @param include_css logical include the CSS bundle
#' @export
kpi_branding <- function(prefix = "gkss", include_css = TRUE){
  root <- system.file("app","www", package = "GolemKpiSnapshotSuite")
  if (!nzchar(root) || !dir.exists(root))
    return(htmltools::tagList())

  shiny::addResourcePath(prefix, root)

  deps <- list()
  if (include_css){
    css_order <- c("litera_style.css","custom.css","value_box_mobile.css")
    present <- css_order[file.exists(file.path(root, css_order))]
    for (f in present){
      deps[[length(deps)+1]] <- htmltools::htmlDependency(
        name = paste0("gkss-", sub("\\.css$","", f)),
        version = as.character(utils::packageVersion("GolemKpiSnapshotSuite")),
        src = c(href = prefix),
        stylesheet = f
      )
    }
  }

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
  if (!nzchar(root) || !file.exists(file.path(root,file)))
    return(htmltools::tags$span("[Logo missing]"))
  shiny::addResourcePath(prefix, root)
  htmltools::tags$img(
    src = sprintf("%s/%s", prefix, file),
    height = height,
    alt = alt,
    style="vertical-align:middle;display:inline-block;"
  )
}
