#' Register assets & inject cleaned CSS set
#' @export
kpi_branding <- function(prefix = "gkss"){
  root <- system.file("app","www", package = "GolemKpiSnapshotSuite")
  if (!nzchar(root) || !dir.exists(root)) return(htmltools::tagList())
  shiny::addResourcePath(prefix, root)

  css <- "custom.css"
  if (file.exists(file.path(root, css))) {
    dep <- htmltools::htmlDependency(
      name = "gkss-custom",
      version = as.character(utils::packageVersion("GolemKpiSnapshotSuite")),
      src = c(href = prefix),
      stylesheet = css
    )
    return(htmltools::tagList(dep))
  }
  htmltools::tagList()
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
app_ui <- function(request){
  tagList(
    GolemKpiSnapshotSuite::kpi_branding(),  # loads CSS + path
    bslib::page_navbar(
      id = "main_tabs",
      theme = GolemKpiSnapshotSuite::litera_theme(),
      title = div(
        style="display:flex;align-items:center;gap:8px;",
        GolemKpiSnapshotSuite::kpi_logo(height="44px"),
        span("Enrollment Management KPIs")
      ),
      shinybrowser::detect(),
      sidebar = bslib::sidebar(width=275, uiOutput("custom_sidebar")),
      bslib::nav_panel("Main",             GolemKpiSnapshotSuite::mod_headcount_ui("headcount_tab")),
      bslib::nav_panel("Student Type",     GolemKpiSnapshotSuite::mod_student_type_ui("student_type_tab")),
      bslib::nav_panel("Race & Ethnicity", GolemKpiSnapshotSuite::mod_ipeds_ui("ipeds_tab")),
      bslib::nav_panel("Cohort Retention", GolemKpiSnapshotSuite::mod_retention_ui("retention_tab")),
      bslib::nav_panel("Housing",          GolemKpiSnapshotSuite::mod_housing_ui("housing_tab"))
    )
  )
}