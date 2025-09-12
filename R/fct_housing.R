#' Pull raw housing data
#' @export
housing_pull_raw <- function(dsn = "edify", context = "shiny") {
  utHelpR::get_data_from_sql_file("housing_fillrate.sql", dsn = dsn, context = context)
}

#' Build housing datasets (value boxes + detailed table)
#'
#' Returns a list with:
#'   final_housing_for_valueboxs : value box friendly tibble
#'   detailed_table_for_DT       : detailed building-level tibble
#' @export
housing_build <- function(raw) {
  if (is.null(raw) || !nrow(raw)) {
    empty_vb <- tibble::tibble(
      names = character(),
      `Student Type` = character(),
      `Current Year` = numeric(),
      `Previous Year` = numeric(),
      `Percent Change` = numeric(),
      difference = numeric()
    )
    empty_detailed <- tibble::tibble()
    return(list(
      final_housing_for_valueboxs = empty_vb,
      detailed_table_for_DT = empty_detailed
    ))
  }

  number_of_beds <- raw %>%
    dplyr::distinct(building_name, number_of_beds, term_id)

  make_rates <- function(year_, status_code_) {
    df <- raw %>%
      dplyr::filter(.data$year == year_, .data$status_code %in% status_code_) %>%
      dplyr::group_by(.data$building_name, .data$term_id)

    has_student_id <- "student_id" %in% names(df)

    rates <- df %>%
      dplyr::summarise(
        number_of_students = if (has_student_id) dplyr::n_distinct(.data$student_id) else dplyr::n(),
        .groups = "drop"
      ) %>%
      dplyr::left_join(number_of_beds,
                       by = dplyr::join_by(building_name, term_id)) %>%
      dplyr::mutate(
        raw_diff = .data$number_of_students - .data$number_of_beds,
        occupancy_rate = dplyr::if_else(.data$number_of_beds > 0,
                                        .data$number_of_students / .data$number_of_beds,
                                        NA_real_)
      )

    total_row <- rates %>%
      dplyr::summarise(
        building_name       = glue::glue("{year_} total"),
        number_of_students  = sum(.data$number_of_students, na.rm = TRUE),
        number_of_beds      = sum(.data$number_of_beds, na.rm = TRUE),
        raw_diff            = sum(.data$raw_diff, na.rm = TRUE),
        occupancy_rate      = dplyr::if_else(sum(.data$number_of_beds, na.rm = TRUE) > 0,
                                             sum(.data$number_of_students, na.rm = TRUE) / sum(.data$number_of_beds, na.rm = TRUE),
                                             NA_real_)
      )

    dplyr::bind_rows(rates %>% dplyr::select(-.data$term_id),
                     total_row)
  }

  active       <- make_rates("current",  c("RV","AC")) %>% dplyr::mutate(category = "active")
  reserved_only  <- make_rates("current",  c("RV"))      %>% dplyr::mutate(category = "reserved_only")
  current_only   <- make_rates("current",  c("AC"))      %>% dplyr::mutate(category = "current_only")
  historical     <- make_rates("previous", c("IN"))      %>% dplyr::mutate(category = "historical")

  get_total <- function(df) {
    df %>% dplyr::filter(stringr::str_ends(.data$building_name, " total"))
  }

  totals_current <- dplyr::bind_rows(active, reserved_only, current_only, historical) %>%
    get_total() %>%
    dplyr::select(
      .data$category,
      number_of_students_current = .data$number_of_students,
      .data$number_of_beds,
      .data$raw_diff,
      occupancy_rate_current = .data$occupancy_rate
    )

  historical_total <- totals_current %>%
    dplyr::filter(.data$category == "historical") %>%
    dplyr::transmute(historical_rate = .data$occupancy_rate_current)

  current_totals_no_hist <- totals_current %>%
    dplyr::filter(.data$category != "historical")

  occupancy_join <- dplyr::cross_join(
    current_totals_no_hist,
    historical_total
  )

  historical_headcount <- historical %>%
    dplyr::filter(stringr::str_ends(.data$building_name, " total")) %>%
    dplyr::pull(.data$number_of_students)

  housing_value_box_df <- occupancy_join %>%
    dplyr::mutate(category = stringr::str_replace_all(.data$category, "_", " ") %>% stringr::str_to_title()) %>%
    dplyr::mutate(
      historical_rate = round(.data$historical_rate * 100, 1),
      current_rate    = round(.data$occupancy_rate_current * 100, 1),
      percent_change  = dplyr::if_else(is.na(.data$historical_rate) | .data$historical_rate == 0,
                                       NA_real_,
                                       (.data$current_rate - .data$historical_rate) / .data$historical_rate),
      difference      = .data$number_of_students_current - historical_headcount
    ) %>%
    dplyr::transmute(
      names           = .data$category,
      `Student Type`  = "Previous Year Comparison",
      `Previous Year` = .data$historical_rate,
      `Current Year`  = .data$current_rate,
      difference      = .data$difference,
      `Percent Change`= .data$percent_change
    )

  make_filtered_tables <- function(category_filter) {
    totals_current %>%
      dplyr::mutate(category = stringr::str_replace_all(.data$category, "_", " ") %>% stringr::str_to_title()) %>%
      dplyr::transmute(
        names            = category_filter,
        `Student Type`   = paste(.data$category, "Fill Rate"),
        `Previous Year`  = .data$number_of_beds,              # capacity
        `Current Year`   = .data$number_of_students_current,  # headcount
        difference       = .data$raw_diff,                    # diff
        `Percent Change` = .data$occupancy_rate_current * 100  # proportion -> percent
      )
  }

  filtered_active       <- make_filtered_tables("Active")
  filtered_reserved_only  <- make_filtered_tables("Reserved Only")
  filtered_current_only   <- make_filtered_tables("Current Only")

  final_housing_for_valueboxs <- dplyr::bind_rows(
    housing_value_box_df,
    filtered_active,
    filtered_reserved_only,
    filtered_current_only
  ) %>%
    dplyr::arrange(.data$names, dplyr::desc(.data$`Student Type`)) %>%
    dplyr::mutate(
      dplyr::across(c(`Current Year`, `Previous Year`, difference),
                    ~ as.double(round(.x, 2)))
    ) %>%
    dplyr::select(
      .data$`Student Type`,
      .data$`Current Year`,
      .data$`Previous Year`,
      .data$`Percent Change`,
      .data$difference,
      .data$names,
    )

  detailed_table_for_DT <- dplyr::bind_rows(active, reserved_only, current_only, historical) %>%
    dplyr::arrange(.data$category, .data$building_name) #%>%
    #dplyr::mutate(
     # occupancy_rate = round(.data$occupancy_rate * 100, 1)
    #)


  list(
    final_housing_for_valueboxs = final_housing_for_valueboxs,
    detailed_table_for_DT = detailed_table_for_DT
  )
}

#' Convenience: return just the value box dataset
#' @export
housing_value_box_data <- function(dsn = "edify", context = "shiny") {
  raw <- housing_pull_raw(dsn = dsn, context = context)
  housing_build(raw)$final_housing_for_valueboxs
}

#' Convenience: return detailed table
#' @export
housing_detailed_table <- function(dsn = "edify", context = "shiny") {
  raw <- housing_pull_raw(dsn = dsn, context = context)
  housing_build(raw)$detailed_table_for_DT
}

# Backward-compatible alias
#' @export
get_housing_value_box_data <- housing_value_box_data

