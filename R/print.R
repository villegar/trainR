#' Print data
#'
#' @param x Data
#' @param ... Optional parameters.
#'
#' @return Input data invisibly.
#' @rdname print
#' @export
print <- function(x, ...) {
  UseMethod("print", x)
}

#' @rdname print
#' @export
print.GetStationBoardResult <- function(x, ...) {
  buses <- trains <- ""
  if (!is.na(x$busServices))
    buses <- paste0("\n- ",
                    nrow(x$busServices[[1]]),
                    " bus",
                    ifelse(nrow(x$busServices[[1]]) == 1, "", "es"),
                    "\n")
  if (!is.na(x$trainServices))
    trains <- paste0("\n- ",
                     nrow(x$trainServices[[1]]),
                     " train",
                     ifelse(nrow(x$trainServices[[1]]) == 1, "", "s"),
                     "\n")
  cat(glue::glue("{x$locationName} ({x$crs}) Station Board ",
                 "on {x$generatedAt}\n\n"))#,
  # "Number of services found:",
  # "{trains}",
  # "{buses}",
  # "\n\n"))
  # cli::cat_line(x[, -c(5:6)])
  if (!is.na(x$trainServices)) print(x$trainServices, ...)
  if (!is.na(x$busServices)) print(x$busServices, ...)
  invisible(x)
}

#' @rdname print
#' @export
print.busServices <- function(x, ...) {
  print_board(x[[1]], ...)
  invisible(x)
}

#' @rdname print
#' @export
print.trainServices <- function(x, ...) {
  print_board(x[[1]], ...)
  invisible(x)
}

#' @rdname print
#' @export
print.previousCallingPoints <- function(x, ...) {
  # Local binding
  . <- crs <- NULL
  x[[1]] %>%
    dplyr::mutate(station = get_location(crs)) %>%
    glue::glue_data("{station} ({ifelse(is.na(et), st, st)})") %>%
    paste0(collapse = ", ") %>%
    paste0("Previous calls: ", ., "\n\n") %>%
    cat()
  invisible(x)
}

#' Print arrivals/departures board
#'
#' @param x Tibble with arrivals/departures information.
#' @param show_details Boolean flag to indicate if detail information about
#'     previous calling points should be included or not.
#' @param station String to indicate if the destination or origin station
#'     should be displayed.
#' @param ... Optional parameters (not used).
#'
#' @return Nothing, call for its side effect.
#' @keywords internal
print_board <- function(x,
                        show_details = FALSE,
                        station = "destination",
                        ...) {
  # Local binding
  . <- NULL
  header <- "To"
  if (station == "origin")
    header <- "From"
  header <- paste0(stringr::str_pad("Time", 8, 'right'),
                   stringr::str_pad(header, 40, 'right'),
                   stringr::str_pad("Plat", 8, 'right'),
                   "Expected\n")
  cat(header)

  # Retrieve full station names
  x <- x %>%
    dplyr::mutate(station = get_element(., station) %>%
                    get_location())

  if (show_details) {
    purrr::walk(seq_len(nrow(x)),
                function(i) {
                  x[i, ] %>%
                    glue::glue_data("{stringr::str_pad(sta, 5, 'right')}\t",
                                    "{stringr::str_pad(station, 40, 'right')}",
                                    "{stringr::str_pad(platform, 4, 'right')}\t",
                                    "{eta}\n\n") %>%
                    cat()
                  print(x[i, ]$previousCallingPoints)
                })
  } else {
    x %>%
      glue::glue_data("{stringr::str_pad(sta, 5, 'right')}\t",
                      "{stringr::str_pad(station, 40, 'right')}",
                      "{stringr::str_pad(platform, 4, 'right')}\t",
                      "{eta}\n\n") %>%
      purrr::walk(cat)
  }
}
