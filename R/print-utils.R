.glue_details <- function(expected, platform, station, time, via, show_colours) {
  if (is.na(time)) time <- ""
  if (is.na(station)) station <- ""
  if (is.na(platform)) platform <- ""
  if (is.na(via)) via <- ""
  glue::glue("{stringr::str_pad(time, 7, 'right')}",
             "{stringr::str_pad(station, 40, 'right')}",
             "{stringr::str_pad(platform, 6, 'right')}",
             "{colour_time(time, expected, show_colours)}\n",
             "{via %>% .print_via}",
             "{ifelse(!is.na(via) & via != '', '\n', '')}")
}

.print_service_details <- function(expected, platform, station, time, via, show_colours, ...) {
  if (length(station) > 1 & length(via) > 1) { # Services with multiple locations
    locations <- paste0(station, collapse = " and ")
    if (length(unique(via)) == 1) {
      via[1:(length(via) - 1)] <- NA
      if (nchar(locations) <= 40) {
        return(.glue_details(expected = expected,
                             platform = platform,
                             station = locations,
                             time = time,
                             via = via[length(via)],
                             show_colours = show_colours))
      }
    }
    aux <- .glue_details(expected, platform, station[1], time, via[1], show_colours)
    paste0(aux,
           purrr::map_chr(seq_along(station)[-1],
                          function(i) {
                            .glue_details(NA, NA, paste("and", station[i]), NA, via[i], show_colours)
                          }),
           collapse = "\n")
  } else { # Services with single location
    .glue_details(expected, platform, station, time, via, show_colours)
  }
}

.print_via <- function(.data) {
  ifelse(!is.na(.data) & .data != "",
         stringr::str_pad(stringr::str_pad(.data, 40, 'right'), 47, 'left'),
         '')
}
