#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  device <- reactive(shinybrowser::get_device())

  data_dir <- here::here("data")
  pins_board <- get_pins_board()
  pin_author <- get_golem_config("connect_account")
  pin_prefix <- glue::glue("{pin_author}/mobile_cabinet_kpi")



  # Details of how to import the data for the value boxes
  #
  vb_data_details <- list(
    headcount = list(
      importer = pin_importer(board = pins_board, name = glue::glue("{pin_prefix}-headcount")),
      config_field = "main_tab_value_boxes"
    ),
    student_type = list(
      importer = pin_importer(board = pins_board, name = glue::glue("{pin_prefix}-student_type")),
      config_field = "student_tab_value_boxes"
    ),
    retention = list(
      importer = pin_importer(board = pins_board, name = glue::glue("{pin_prefix}-cohort_retention")),
      config_field = "retention_tab_value_boxes"
    ),
    ipeds = list(
      importer = pin_importer(board = pins_board, name = glue::glue("{pin_prefix}-ipeds")),
      config_field = "ipeds_tab_value_boxes"
    ),
    housing = list(
      importer = housing_value_box_data,
      config_field = "housing_tab_value_boxes"
    )
  )


  vb_data_raw <- purrr::map(
    vb_data_details,
    function(x) {
      if (is.function(x$importer)) {
        # Direct function (housing) -> call it
        reactive(x$importer())
      } else {
        # pin_importer or other importer object -> use import()
        reactive(import(x$importer))
      }
    }
  )


  vb_data_processed <- purrr::map2(
    vb_data_details,
    vb_data_raw,
    function(details, raw) {
      reactive({
        raw() |>
          dplyr::filter(names == input$comparison_mode_selector) |>
          get_value_box_data(
            rows = get_golem_config(details[["config_field"]])
          )
      })
    }
  )


  plot_data <- reactive({
    # TODO: convert this to use pin_importer() when all_line_charts_df has been converted to a pin
    #importer <- file_importer(path = file.path(data_dir, "all_line_charts_df.rds"))
    importer = pin_importer(board = pins_board, name = glue::glue("{pin_prefix}-all_line_charts_df"))
    import(importer)
  })


  dt_data <- reactive({
    # Return the detailed table (not just the function)
    housing_detailed_table()
  })

  ################################################################################

  mod_headcount_server(
    "headcount_tab",
    device_type = device(),
    value_box_data = vb_data_processed[["headcount"]],
    plot_data = plot_data
  )
  mod_student_type_server(
    "student_type_tab",
    device_type = device(),
    value_box_data = vb_data_processed[["student_type"]],
    plot_data = plot_data
  )
  mod_retention_server(
    "retention_tab",
    device_type = device(),
    value_box_data = vb_data_processed[["retention"]],
    plot_data = plot_data
  )
  mod_ipeds_server(
    "ipeds_tab",
    device_type = device(),
    value_box_data = vb_data_processed[["ipeds"]],
    plot_data = plot_data
  )

  mod_housing_server(
    "housing_tab",
    device_type = device(),
    value_box_data = vb_data_processed[["housing"]],
    dt_data = dt_data,
    comparison_mode = reactive(input$comparison_mode_selector)  # pass selector
  )





  # Dynamic sidebar UI based on selected tab
  output$custom_sidebar <- renderUI({
    # Tabs that should show the dropdown

    tabs_with_dropdown <- c("Main", "Student Type", "Race & Ethnicity", "Cohort Retention")
    # Get the selected tab's id
    selected_tab <- input$main_tabs
    if (selected_tab %in% tabs_with_dropdown) {
      selectInput("comparison_mode_selector",
                  "Select Comparison Mode",
                  choices = c(
                    "Previous Year PIT",
                    "Previous Year Census",
                    "Daily Goal",
                    "Census Goal"
                  ),
                  selectize = FALSE
      )
    } else if (selected_tab == "Housing") {

      selectInput("comparison_mode_selector",
                  "Select Comparison Mode",
                  choices = c(
                    "Active",
                    "Current Only",
                    "Reserved Only"
                  ),
                  selectize = FALSE
      )

    }
  })
}
