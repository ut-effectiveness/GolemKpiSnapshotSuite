#' Title logo UI fragment
#'
#' @param height CSS height (character).
#' @param class Additional CSS classes.
#' @return A shiny tag.
#' @export
title_logo <- function(height = "40px", class = NULL){
  # Create a tagList to hold the logo elements
  logo_tag <- tagList()

  # Add the main logo image
  logo_tag <- tagAppendChild(logo_tag, tags$img(src = "www/logo.png", height = height, class = class))

  # Add a title next to the logo
  logo_tag <- tagAppendChild(logo_tag, tags$span("My Application", style = paste("height:", height, "; line-height:", height, ";"), class = class))

  # Return the complete logo tag
  logo_tag
}