#' Print Values
#'
#' @param x an object used to select a method.
#' @param ... further arguments passed to or from other methods.
#'
#' @return Input data invisibly.
#' @rdname print
#' @export
print <- function(x, ...) {
  UseMethod("print", x)
}

#' @param station String to indicate if the destination or origin station
#'     should be displayed.
#' @rdname print
#' @export
print.StationBoard <- function(x, ..., station = NA) {
  if (is.na(station)) {
    if (inherits(x, "DepBoardWithDetails")) {
      station = "destination"
    } else {
      station = "origin"
    }
  }
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
  if (!is.na(x$trainServices)) print(x$trainServices, station = station, ...)
  if (!is.na(x$busServices)) print(x$busServices, station = station, ...)
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
  if (all(is.na(x[[1]])))
    return(invisible(x))
  x[[1]] %>%
    dplyr::mutate(station = get_location(crs)) %>%
    glue::glue_data("{station} ({ifelse(is.na(at) | at == 'On time', st, at)})") %>%
    paste0(collapse = ", ") %>%
    paste0("Previous calls: ", ., "\n\n") %>%
    cat()
  invisible(x)
}

#' @rdname print
#' @export
print.subsequentCallingPoints <- function(x, ...) {
  # Local binding
  . <- crs <- NULL
  if (all(is.na(x[[1]])))
    return(invisible(x))
  x[[1]] %>%
    # dplyr::filter_all(is.na, .preserve = TRUE) %>%
    dplyr::mutate(station = get_location(crs)) %>%
    glue::glue_data("{station} ({ifelse(is.na(et), st, st)})") %>%
    paste0(collapse = ", ") %>%
    paste0("Calling at: ", ., "\n\n") %>%
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
  . <- eta <- etd <- platform <- sta <- std <- NULL
  header <- "To"
  if (station == "origin")
    header <- "From"
  header <- paste0(stringr::str_pad("Time", 7, 'right'),
                   stringr::str_pad(header, 40, 'right'),
                   stringr::str_pad("Plat", 6, 'right'),
                   "Expected\n")
  cat(header)

  # Retrieve full station names
  x <- x %>%
    dplyr::mutate(time = ifelse(station == "destination" & !is.na(std),
                                std,
                                sta),
                  expected = ifelse(station == "destination" & !is.na(etd),
                                    etd,
                                    eta),
                  platform = ifelse(is.na(platform), "-", platform),
                  station = get_element(., station) %>%
                    get_location())

  if (show_details) {
    purrr::walk(seq_len(nrow(x)),
                function(i) {
                  x[i, ] %>%
                    glue::glue_data("{stringr::str_pad(time, 7, 'right')}",
                                    "{stringr::str_pad(station, 40, 'right')}",
                                    "{stringr::str_pad(platform, 6, 'right')}",
                                    "{expected}\n\n") %>%
                    cat()
                  if (station == "origin") {
                    print(x[i, ]$previousCallingPoints)
                  } else {
                    print(x[i, ]$subsequentCallingPoints)
                  }
                })
  } else {
    x %>%
      glue::glue_data("{stringr::str_pad(time, 7, 'right')}",
                      "{stringr::str_pad(station, 40, 'right')}",
                      "{stringr::str_pad(platform, 6, 'right')}",
                      "{expected}\n\n") %>%
      purrr::walk(cat)
  }
}
