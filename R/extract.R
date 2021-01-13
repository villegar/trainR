#' Extract data from XML request
#'
#' @param x List with request results.
#' @param ... Optional parameters.
#'
#' @return Tibble with the appropriate format.
#' @rdname extract
#' @keywords internal
extract <- function(x, ...) {
  UseMethod("extract", x)
}

#' @rdname extract
#' @keywords internal
extract.GetServiceDetailsResult <- function(x, ...) {
  # Local binding
  . <- NULL

  class <- names(x)
  if (length(x) == 1 & inherits(x, class))
    x <- x[[1]]
  tibble::tibble(generatedAt =
                   get_element(x, "generatedAt") %>%
                   lubridate::parse_date_time("%Y-%m-%d %H:%M:%OS %z"),
                 serviceType = get_element(x, "serviceType"),
                 locationName = get_element(x, "locationName"),
                 crs = get_element(x, "crs"),
                 operator = get_element(x, "operator"),
                 operatorCode = get_element(x, "operatorCode"),
                 rsid = get_element(x, "rsid"),
                 platform = get_element(x, "platform"),
                 sta = get_element(x, "sta"),
                 ata = get_element(x, "ata"),
                 std = get_element(x, "std"),
                 atd = get_element(x, "atd"),
                 previousCallingPoints =
                   list(get_element(x, "previousCallingPoints", TRUE) %>%
                          .[[1]] %>%
                          purrr::map_df(function(x) x %>%
                                          reclass("callingPoint") %>%
                                          extract())
                   ) %>%
                   reclass("previousCallingPoints"),
                 subsequentCallingPoints =
                   list(get_element(x, "subsequentCallingPoints", TRUE) %>%
                          .[[1]] %>%
                          purrr::map_df(function(x) x %>%
                                          reclass("callingPoint") %>%
                                          extract())
                   ) %>%
                   reclass("subsequentCallingPoints")
  ) %>%
    reclass(class)
}

#' @rdname extract
#' @keywords internal
extract.StationBoard <- function(x, ...) {
  class <- class(x)[1:2]
  if (length(x) == 1 & inherits(x, class))
    x <- x[[1]]
  tibble::tibble(generatedAt =
                   get_element(x, "generatedAt")  %>%
                   lubridate::parse_date_time("%Y-%m-%d %H:%M:%OS %z"),
                 locationName = get_element(x, "locationName"),
                 crs = get_element(x, "crs"),
                 platformAvailable = get_element(x, "platformAvailable"),
                 trainServices =
                   get_element(x, "trainServices", TRUE) %>%
                   reclass("trainServices") %>%
                   extract(),
                 busServices =
                   get_element(x, "busServices", TRUE) %>%
                   reclass("busServices") %>%
                   extract()
  ) %>%
    reclass(class)
}

#' @rdname extract
#' @keywords internal
extract.busServices <- function(x, ...) {
  if (all(is.null(x)) |
      all(is.na(x)) |
      length(x) == 0 |
      is.null(x[[1]]))
    return(NA)
  purrr::map_df(x, function(x) x %>% reclass("service") %>% extract()) %>%
    list() %>%
    reclass("busServices")
}

#' @rdname extract
#' @keywords internal
extract.callingPoint <- function(x, ...) {
  tibble::tibble(locationName = get_element(x, "locationName"),
                 crs = get_element(x, "crs"),
                 st = get_element(x, "st"),
                 at = get_element(x, "at"),
                 length = get_element(x, "length"),
                 et = get_element(x, "et"))
}

#' @param class String with class of the output object.
#' @rdname extract
#' @keywords internal
extract.callingPointList <- function(x, ..., class = "previousCallingPoints") {
  x <- x[[1]]
  if (all(is.null(x)) |
      all(is.na(x)) |
      length(x) == 0 |
      is.null(x[[1]])) {
    # return(NA)
    return(list(NA) %>%
             reclass(class))
  }

  purrr::map_df(x, function(x) x %>% reclass("callingPoint") %>% extract()) %>%
    list() %>%
    reclass(class)
  # x %>% # callingPointList
  #   purrr::map_df(function(x) x %>%
  #                   reclass("callingPoint") %>%
  #                   extract()) %>%
  #   list() %>%
  #   reclass(class)
}

#' @rdname extract
#' @keywords internal
extract.trainServices <- function(x, ...) {
  if (all(is.null(x)) |
      all(is.na(x)) |
      length(x) == 0 |
      is.null(x[[1]]))
    return(NA)
  purrr::map_df(x, function(x) x %>% reclass("service") %>% extract()) %>%
    list() %>%
    reclass("trainServices")
}

#' @rdname extract
#' @keywords internal
extract.service <- function(x, ...) {
  tibble::tibble(sta = get_element(x, "sta"), # arrival
                 eta = get_element(x, "eta"),
                 std = get_element(x, "std"), # departure
                 etd = get_element(x, "etd"),
                 platform = get_element(x, "platform"),
                 operator = get_element(x, "operator"),
                 operatorCode = get_element(x, "operatorCode"),
                 serviceType = get_element(x, "serviceType"),
                 serviceID = get_element(x, "serviceID"),
                 rsid = get_element(x, "rsid"),
                 origin =
                   get_element(x, "origin", TRUE) %>%
                   get_element("location") %>%
                   get_element("crs"),
                 destination =
                   get_element(x, "destination", TRUE)  %>%
                   get_element("location") %>%
                   get_element("crs"),
                 previousCallingPoints =
                   get_element(x, "previousCallingPoints", TRUE) %>%
                   reclass("callingPointList") %>%
                   extract(class = "previousCallingPoints"),
                 subsequentCallingPoints =
                   get_element(x, "subsequentCallingPoints", TRUE) %>%
                   reclass("callingPointList") %>%
                   extract(class = "subsequentCallingPoints"),
                 isCancelled = get_element(x, "isCancelled"),
                 cancelReason = get_element(x, "cancelReason"),
                 delayReason = get_element(x, "delayReason"))
}
