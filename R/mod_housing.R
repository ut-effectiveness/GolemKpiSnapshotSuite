#' housing_tab UI Function
#' @export
#' @noRd
mod_housing_ui <- function(id) {
  ns <- shiny::NS(id)
  bslib::nav_panel(
    title = "Housing",
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
    uiOutput(ns("table_card"))
  )
}

mod_housing_server <- function(id,
                               device_type = "Desktop",
                               value_box_data,
                               dt_data,
                               comparison_mode) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    val_boxes <- reactive({
      lookup <- read.csv(here::here("data/lookup_housing.csv"))
      purrr::map(
        .x = get_golem_config("housing_tab_value_boxes"),
        ~ get_value_box(value_box_data(), .x, lookup)
      )
    })

    output$value_boxes_ui <- renderUI({
      do.call(bslib::layout_columns, val_boxes())
    })

    filtered_dt <- reactive({
      req(dt_data())
      sel <- comparison_mode()
      if (is.null(sel) || !nzchar(sel)) return(dt_data())
      key <- gsub(" ", "_", tolower(sel))
      d <- dt_data()
      if ("category" %in% names(d)) {
        d <- d[d$category == key, , drop = FALSE]
        if (nrow(d) == 0) d <- dt_data()
      }
      d
    })


    output$housing_dt <- DT::renderDT({
      req(device_type == "Desktop")

      dat <- filtered_dt() %>%
        dplyr::mutate(category = stringr::str_replace_all(.data$category, "_", " ") |> stringr::str_to_title()
        ) |>
        dplyr::mutate(
         occupancy_rate = round(.data$occupancy_rate * 100, 1)
        )

      names(dat) <- stringr::str_to_title(stringr::str_replace_all(names(dat), "_", " "))  # adjust to match actual columns

      DT::datatable(
        dat,
        filter = "top",
        extensions = c("Buttons"),
        options = list(
          dom = "Bfrtip",
          buttons = list(
            list(extend = "excel", title = "housing_detail"),
            list(extend = "csv", title = "housing_detail")
          ),
          pageLength = 25,
          lengthMenu = c(10, 25, 50, 100),
          scrollX = TRUE
        )
      )
    }, server = FALSE)

    output$table_card <- renderUI({
      # On mobile hide the table (consistent w/ other modules hiding plots)
      if (device_type != "Desktop") return(NULL)
      bslib::card(
        full_screen = TRUE,
        bslib::card_header("Building Detail"),
        DT::DTOutput(ns("housing_dt"))
      )
    })

    # Optional debug block (kept hidden unless needed)
    # output$housing_dbg <- renderPrint(str(head(dt_data())))

  })
}
