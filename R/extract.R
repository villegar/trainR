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

#' @return \code{ServiceLocation:}
#' \describe{
#'  \item{locationName}{The name of the location.}
#'  \item{crs}{The CRS code of this location. A CRS code of \code{???} indicates
#'  an error situation where no crs code is known for this location.}
#'  \item{via}{An optional via text that should be displayed after the location,
#'  to indicate further information about an ambiguous route. Note that vias are
#'  only present for \code{ServiceLocation} objects that appear in destination
#'  lists.}
#'  \item{futureChangeTo}{A text string containing service type
#'  (Bus/Ferry/Train) to which will be changed in the future.}
#'  \item{assocIsCancelled}{This origin or destination can no longer be reached
#'  because the association has been cancelled.}
#' }
#' @rdname extract
#' @keywords internal
extract.ServiceLocation <- function(x, ...) {
  x <- x[[1]]
  if (all(is.null(x)) |
      all(is.na(x)) |
      length(x) == 0 |
      is.null(x[[1]]))
    return(NA)
  tibble::tibble(locationName = get_element(x, "locationName"),
                 crs = get_element(x, "crs"),
                 via = get_element(x, "via"),
                 futureChangeTo = get_element(x, "futureChangeTo"),
                 assocIsCancelled = get_element(x, "assocIsCancelled")) %>%
    list() %>%
    reclass("ServiceLocation")
}

#' @return \code{StationBoard:}
#' \describe{
#'  \item{generatedAt}{The time at which the station board was generated.}
#'  \item{locationName}{The name of the location that the station board is for.}
#'  \item{crs}{The CRS code of the location that the station board is for.}
#'  \item{filterLocationName}{If a filter was requested, the location name of
#'  the filter location.}
#'  \item{filtercrs}{If a filter was requested, the CRS code of the filter
#'  location.}
#'  \item{filterType}{If a filter was requested, the type of filter.}
#'  \item{nrccMessages}{An optional list of textual messages that should be
#'  displayed with the station board. The message may include embedded and XML
#'  encoded HTML-like hyperlinks and paragraphs. The messages are typically
#'  used to display important disruption information that applies to the
#'  location that the station board was for. Any embedded \code{<p>} tags are
#'  used to force a new-line in the output. Embedded \code{<a>} tags allow
#'  links to external web pages that may provide more information. Output
#'  channels that do not support HTML should strip out the \code{<a>} tags and
#'  just leave the enclosed text.}
#'  \item{platformAvailable}{An optional value that indicates if platform
#'  information is available. If this value is present with the value "true"
#'  then platform information will be returned in the service lists. If this
#'  value is not present, or has the value "false", then the platform "heading"
#'  should be suppressed in the user interface for this station board.}
#'  \item{areServicesAvailable}{An optional value that indicates if services
#'  are currently available for this station board. If this value is present
#'  with the value "false" then no services will be returned in the service
#'  lists. This value may be set, for example, if access to a station has been
#'  closed to the public at short notice, even though the scheduled services
#'  are still running. It would be usual in such cases for one of the
#'  \code{nrccMessages} to describe why the list of services has been
#'  suppressed.}
#'  \item{trainServices}{A list of \code{ServiceItem} object for each services
#'  of the relevant type that is to appear on the station board. May contain
#'  zero items, or may not be present at all.}
#'  \item{busServices}{A list of \code{ServiceItem} object for each services
#'  of the relevant type that is to appear on the station board. May contain
#'  zero items, or may not be present at all.}
#'  \item{ferryServices}{A list of \code{ServiceItem} object for each services
#'  of the relevant type that is to appear on the station board. May contain
#'  zero items, or may not be present at all.}
#' }
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
                 filterLocationName = get_element(x, "filterLocationName"),
                 filtercrs = get_element(x, "filtercrs"),
                 filterType = get_element(x, "filterType"),
                 nrccMessages =
                   get_element(x, "nrccMessages", TRUE) %>%
                   reclass("nrccMessages") %>%
                   extract(),
                 platformAvailable = get_element(x, "platformAvailable"),
                 trainServices =
                   get_element(x, "trainServices", TRUE) %>%
                   reclass("trainServices") %>%
                   extract(),
                 busServices =
                   get_element(x, "busServices", TRUE) %>%
                   reclass("busServices") %>%
                   extract(),
                 ferryServices =
                   get_element(x, "ferryServices", TRUE) %>%
                   reclass("ferryServices") %>%
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

#' @return \code{callingPoint:}
#' \describe{
#'  \item{locationName}{The display name of this location.}
#'  \item{crs}{The CRS code of this location. A CRS code of \code{???} indicates
#'  an error situation where no crs code is known for this location.}
#'  \item{st}{The scheduled time of the service at this location. The time will
#'  be either an arrival or departure time, depending on whether it is in the
#'  subsequent or previous calling point list.}
#'  \item{et}{The estimated time of the service at this location. The time will
#'  be either an arrival or departure time, depending on whether it is in the
#'  subsequent or previous calling point list. Will only be present if an actual
#'  time (at) is not present.}
#'  \item{at}{The actual time of the service at this location. The time will be
#'  either an arrival or departure time, depending on whether it is in the
#'  subsequent or previous calling point list. Will only be present if an
#'  estimated time (et) is not present.}
#'  \item{isCancelled}{A flag to indicate that this service is cancelled at this
#'  location.}
#'  \item{length}{The train length (number of units) at this location. If not
#'  supplied, or zero, the length is unknown.}
#'  \item{detachFront}{True if the service detaches units from the front at this
#'  location.}
#'  \item{adhocAlerts}{A list of active Adhoc Alert texts for to this location.
#'  This list contains an object called \code{AdhocAlertTextType} which contains
#'  a string to show the Adhoc Alert Text for the location.}
#' }
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
extract.ferryServices <- function(x, ...) {
  if (all(is.null(x)) |
      all(is.na(x)) |
      length(x) == 0 |
      is.null(x[[1]]))
    return(NA)
  purrr::map_df(x, function(x) x %>% reclass("service") %>% extract()) %>%
    list() %>%
    reclass("ferryServices")
}

#' @rdname extract
#' @keywords internal
extract.nrccMessages <- function(x, ...) {
  if (all(is.null(x)) |
      all(is.na(x)) |
      length(x) == 0 |
      is.null(x[[1]]))
    return(NA)
  purrr::transpose(x)[[1]] %>%
    purrr::flatten_chr() %>%
    tibble::tibble(message = .) %>%
    list() %>%
    reclass("nrccMessages")
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
                   reclass("ServiceLocation") %>%
                   extract(),
                   # get_element("location") %>%
                   # get_element("crs"),
                 destination =
                   get_element(x, "destination", TRUE)  %>%
                   reclass("ServiceLocation") %>%
                   extract(),
                   # get_element("location") %>%
                   # get_element("crs"),
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
