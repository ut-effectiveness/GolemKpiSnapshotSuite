get_value_box_data = function(data, rows){

  # Going to change moving forward
  # Chnaged to grab more columns for "Goal" and "Colour" functions
  l = purrr::map(rows, ~data[data[["Student Type"]] == .x, ])

  names(l) = rows

  l
}

