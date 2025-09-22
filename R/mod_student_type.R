#' main_tab UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @noRd
#' @export
#'
#' @importFrom shiny NS tagList
mod_student_type_ui <- function(id) {
  ns <- NS(id)
  bslib::nav_panel(
    title = "Student Type",
    shinyjs::useShinyjs(),
    shiny::tags$style(".small-box {
                        background-color: rgba(0,0,0,0.03) !important;
                        border-width: 1px;
                        border-color: rgba(0,0,0,0.1);
                        border-style: solid;
                        border-radius: .25rem;
                        padding-left: 1rem;
	                      box-shadow: none;
                        position: relative;
                      }

                      .fa-percent {
                        font-size: 66px;
                        position: absolute;
                        top: 19%;
                        right: 72%;
                        opacity: 0.2
                      }"),
    bslib::layout_columns(
      fill = FALSE,
      uiOutput(ns("value_boxes_ui"))
    ),
    uiOutput(ns("plot_card"))
  )
}

#' main_tab Server Functions
#'
#' @param id Module id.
#' @param device_type Reactive or value describing device type.
#' @param value_box_data Reactive providing value box data.
#' @param plot_data Reactive providing plotting data.
#' @param custom_server Optional function to override server internals.
#' @export
#'
mod_student_type_server <- function(id,
                                    device_type,
                                    value_box_data,
                                    plot_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    val_boxes <- reactive({
      lookup <- read.csv("data/lookup_student.csv")

      purrr::map(
        .x = get_golem_config("student_tab_value_boxes"),
        ~ get_value_box(value_box_data(), .x, lookup)
      )
    })

    filtered_plot_data <- reactive({
      plot_data() |>
        dplyr::filter(
          .data[["metric"]] == "headcount",
          .data[["metric_group"]] == "Freshman",
          .data[["Comparison"]] != "Goal",
        )
    })

    output$value_boxes_ui <- renderUI({
      do.call(bslib::layout_columns, val_boxes())
    })


    observe({
      dev <- normalize_device(device_type)
      if (dev == "desktop") {
        # desktop-specific code
      } else {
        shinyjs::hide(selector = ".desktop-only")
      }
    })

    output$plot_card <- renderUI({
      dev <- normalize_device(device_type)
      req(dev == "desktop")
      bslib::card(
        bslib::card_header("Point-in-time headcount for incoming Freshman"),
        plotly::plotlyOutput(session$ns("line_plot_2"))
      )
    })
  })
}


## To be copied in the UI
# mod_student_type_ui("id")

## To be copied in the server
# mod_student_type_server("id")

###################
#### FUNCTIONS ####
###################
