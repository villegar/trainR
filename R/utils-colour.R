
#' Add colour to string
#' Add colour to string based on scheduled (`time`) and `expected` time of a
#' service.
#'
#' @param time String with service scheduled time, format: `%H:%M`.
#' @param expected String with service expected time, format: `%H:%M`.
#' @inheritParams print_board
#'
#' @return
#' @keywords internal
colour_time <- function(time, expected, show_colours = TRUE) {
  if (is.na(time) | time == "")
    return("")
  if (!show_colours)
    return(expected)
  purrr::map2_chr(time, expected,
                  .colour_time)
}

#' @keywords internal
.colour_time <- function(time, expected) {
  if (tolower(expected) == "on time")
    return(crayon::green(expected))
  if (tolower(expected) == "delayed")
    return(crayon::yellow(expected))
  if (tolower(expected) == "cancelled")
    return(crayon::red(expected))

  minutes <- difftime(strptime(expected, format = "%H:%M"),
                      strptime(time, format = "%H:%M"),
                      units = "mins")
  if (minutes <= 0)
    return(crayon::green(expected))
  if (minutes <= 5)
    return(crayon::yellow(expected))
  if (minutes > 5)
    return(crayon::red(expected))
}
