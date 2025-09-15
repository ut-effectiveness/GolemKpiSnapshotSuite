#' IPEDS_tab UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @import shiny
#' @noRd
#' @export
#'
#' @importFrom shiny NS tagList
mod_ipeds_ui <- function(id) {
  ns <- NS(id)
  bslib::nav_panel(
    title = "Race & Ethnicity",
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
#' @noRd
mod_ipeds_server <- function(id,
                             device_type = "Desktop",
                             value_box_data,
                             plot_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    val_boxes <- reactive({
      lookup <- read.csv("data/lookup_ipeds.csv")

      purrr::map(
        .x = get_golem_config("ipeds_tab_value_boxes"),
        ~ get_value_box(value_box_data(), .x, lookup)
      )
    })

    filtered_plot_data <- reactive({
      plot_data() |>
        dplyr::filter(
          .data[["metric"]] == "headcount",
          .data[["metric_group"]] %in% c("Minority", "Hispanic"))
    })

    output$value_boxes_ui <- renderUI({
      do.call(bslib::layout_columns, val_boxes())
    })

    observe({
      if (device_type == "Desktop") {
        # Code that is specific for the desktop version
      } else {
        # Hide any UI elements that are declared to be 'desktop-only'
        shinyjs::hide(selector = ".desktop-only")
      }
    })

    output$line_plot_2 <- plotly::renderPlotly({
      x_var <- "Days to class start"
      x_label <- "Days to class start"
      y_var <- "metric_number"
      y_label <- "Headcount"
      y_formatter <- scales::comma_format()
      group_var <-"Comparison"
      color_var <- group_var
      date_var <- "Date"
      text_var <- "metric_text"

      gg <- ggplot2::ggplot(
        filtered_plot_data(),
        ggplot2::aes(
          x = .data[[x_var]], y = .data[[y_var]], group = .data[[group_var]],
          date = .data[[date_var]], text = paste("Headcount:",.data[[text_var]])
        )
      ) +
        ggplot2::geom_line(ggplot2::aes(color = .data[[color_var]]), size = .2) +
        ggplot2::geom_point(ggplot2::aes(color = .data[[color_var]]), size = .5, alpha = .5) +
        ggplot2::scale_color_manual(values = c("#6d7e86", "#C2C5C7", "#003058","#BA1C21"))+
        ggplot2::scale_y_continuous(labels = y_formatter) +
        ggplot2::labs(x = x_label, y = y_label) +
        ggplot2::theme_minimal()

      plotly::ggplotly(
        gg,
        tooltip = c("x", "text", "colour", "date")
      ) |>
        plotly::layout(hovermode = "x unified")
    })

    output$plot_card <- renderUI({
      req(device_type == "Desktop")

      bslib::card(
        bslib::card_header("Point-in-time headcount for Minority and Hispanic populations"),
        plotly::plotlyOutput(ns("line_plot_2"))
      )
    })
  })
}


## To be copied in the UI
# mod_ipeds_ui("id")

## To be copied in the server
# mod_ipeds_server("id")

###################
#### FUNCTIONS ####
###################
