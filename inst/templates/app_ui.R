#' The application User-Interface
#' @param request Internal parameter for `{shiny}`.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    shiny::tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "litera_style.css")
    ),
    shinybrowser::detect(),
    bslib::page_navbar(
      id = "main_tabs",
      bg = "#e6f4ff",
      title = title_logo(),
      theme = litera_theme(),
      sidebar = bslib::sidebar(
        width = 275,
        uiOutput("custom_sidebar")
      ),
     bslib::nav_panel("Main",      mod_headcount_ui("headcount_tab")),
     bslib::nav_panel("Student Type",   mod_student_type_ui("student_type_tab")),
     bslib::nav_panel("Race & Ethnicity",          mod_ipeds_ui("ipeds_tab")),
     bslib::nav_panel("Cohort Retention",      mod_retention_ui("retention_tab"))
     ,
      mod_housing_ui("housing_tab")
      # bslib::nav_panel("New Tab", mod_new_ui("new_tab"))
    )
  )
}

#' Add external Resources
#' @noRd
# ...inside golem_add_external_resources()
golem_add_external_resources <- function() {
  golem::add_resource_path("www", app_sys("app/www"))

  tags$head(
    golem::favicon(),
    golem::bundle_resources(
      path = app_sys("app/www"),
      app_title = "mobileCabinetKpi"
    )
  )
}
