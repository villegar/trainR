#' Print Values
#' @param x an object used to select a method.
#' @param ... further arguments passed to or from other methods.
#' @rdname print
#' @export
NULL

#' @param station String to indicate if the destination or origin station
#'     should be displayed.
#' @param string Boolean flag to indicate whether or not the station board
#'     results, should be returned as a string.
#' @rdname print
#' @export
print.StationBoard <- function(x, ..., station = NA, string = FALSE) {
  if (is.na(station)) {
    if (inherits(x, "ArrDepBoardWithDetails")) {
      station = "both" # Arrivals and departures
    } else if (inherits(x, "DepBoardWithDetails") |
               inherits(x, "DepartureBoard")) {
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
  if (string) {
   board_txt <- ""
   if (!is.na(x$trainServices))
     board_txt <- print(x$trainServices,
                        station = station,
                        string = string,
                        ...)
   # return(strsplit(board_txt,'\\n'))
   # return(strsplit(board_txt, ','))
   # browser()
   return(paste("", "", knitr::kable(board_txt, output = FALSE), collapse = "\n"))
  }

  cat(glue::glue("{x$locationName} ({x$crs}) Station Board ",
                 "on {x$generatedAt}\n\n"))#,
  # "Number of services found:",
  # "{trains}",
  # "{buses}",
  # "\n\n"))
  # cli::cat_line(x[, -c(5:6)])
  if (station == "both") {
    print_services(x, station = "origin", show_header = show_header, ...)
    print_services(x, station = "destination", show_header = show_header, ...)
  } else {
    print_services(x, station = station, show_header = show_header, ...)
  }
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
print.ferryServices <- function(x, ...) {
  print_board(x[[1]], ...)
  invisible(x)
}

#' #' @rdname print
#' #' @export
#' print.service <- function(x, ...) {
#'   print_board(x, ...)
#'   invisible(x)
#' }

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
  if (all(is.na(x)))
    return(invisible(x))
  purrr::walk(x, function(calls) {
    # x[[1]] %>%
    calls %>%
      dplyr::mutate(station = get_location(crs)) %>%
      glue::glue_data("{station} ({ifelse(is.na(at) | at == 'On time', st, at)})") %>%
      paste0(collapse = ", ") %>%
      paste0("Previous calls: ", ., "\n\n") %>%
      cat()
  })
  invisible(x)
}

#' @rdname print
#' @export
print.subsequentCallingPoints <- function(x, ...) {
  # Local binding
  . <- crs <- NULL
  if (all(is.na(x)))
    return(invisible(x))
  purrr::walk(x, function(calls) {
    # x[[1]] %>%
    calls %>%
      # x[[1]] %>%
      # dplyr::filter_all(is.na, .preserve = TRUE) %>%
      dplyr::mutate(station = get_location(crs)) %>%
      glue::glue_data("{station} ({ifelse(is.na(et), st, st)})") %>%
      paste0(collapse = ", ") %>%
      paste0("Calling at: ", ., "\n\n") %>%
      cat()
  })
  invisible(x)
}

#' Print arrivals/departures board
#'
#' @param x Tibble with arrivals/departures information.
#' @param show_details Boolean flag to indicate if detail information about
#'     previous calling points should be included or not.
#' @param show_header Boolean flag to indicate if the header of board should be
#'     displayed or not.
#' @param show_colours Boolean flag to indicate if the `Expected` time should
#'     be colour coded or not, based on service time.
#' @inheritParams print.StationBoard
#' @param ... Optional parameters (not used).
#'
#' @return Nothing, call for its side effect.
#' @keywords internal
print_board <- function(x,
                        show_details = getOption("show_details",
                                                 default = FALSE),
                        station = "destination",
                        string = FALSE,
                        show_header = TRUE,
                        show_colours = getOption("show_colours",
                                                 default = FALSE),
                        ...) {
  # Local binding
  . <- eta <- etd <- expected <- platform <- sta <- std <- time <- NULL
  # Filter records by `station`, arrivals and departures
  if (station == "origin") {
    header <- "From"
    x <- x %>%
      dplyr::filter(!is.na(sta) & !is.na(eta)) %>%
      dplyr::mutate(time = sta,
                    expected = eta)
  } else {
    header <- "To"
    x <- x %>%
      dplyr::filter(!is.na(std) & !is.na(etd)) %>%
      dplyr::mutate(time = std,
                    expected = etd)
  }

  # Retrieve full station names
  x <- x %>%
    dplyr::mutate(platform = ifelse(is.na(platform), "-", platform),
                  via =
                    get_element(x, station, TRUE) %>%
                    purrr::transpose() %>%
                    get_element("via", TRUE),
                  station =
                    get_element(x, station, TRUE) %>%
                    purrr::transpose() %>%
                    get_element("locationName", TRUE))

  if (string) {
    return(x %>%
             dplyr::select(time, station, platform, expected))
  }

  header <- paste0(stringr::str_pad("Time", 7, 'right'),
                   stringr::str_pad(header, 40, 'right'),
                   stringr::str_pad("Plat", 6, 'right'),
                   "Expected\n")

  if (show_header)
    cat(header)

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
      purrr::pmap_chr(.print_service_details,
                      show_colours = show_colours) %>%
      # glue::glue_data("{stringr::str_pad(time, 7, 'right')}",
      #                 "{stringr::str_pad(station, 40, 'right')}",
      #                 "{stringr::str_pad(platform, 6, 'right')}",
      #                 "{colour_time(time, expected, show_colours)}\n",
      #                 "{via %>% .print_via}",
      #                 "{ifelse(!is.na(via), '\n', '')}") %>%
      purrr::walk(cat)
  }
}

#' @keywords internal
print_services <- function(x, station, show_header, ...) {
  show_header <- TRUE
  if (!is.na(x$trainServices)) {
    print(x$trainServices, station = station, show_header = show_header, ...)
    show_header <- FALSE
  }
  if (!is.na(x$busServices)) {
    print(x$busServices, station = station, show_header = show_header, ...)
    show_header <- FALSE
  }
  if (!is.na(x$ferryServices))
    print(x$ferryServices, station = station, show_header = show_header, ...)
  if (!show_header)
    cat("\n")
}

#' #' @export
#' #' @importFrom knitr knit_print asis_output
#' knit_print.StationBoard <- function(x, ...) {
#'   res <- capture.output(print(x, string = TRUE))
#'   # class(x) <- 'knit_asis'
#'   # x
#'   asis_output(res)
#' }
