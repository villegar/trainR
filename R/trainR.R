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
  if (length(x) == 1 & names(x) == "GetServiceDetailsResult")
    x <- x[[1]]
  tibble::tibble(generatedAt = get_element(x, "generatedAt"),
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
                          get_calling_points()
                   ) %>%
                   reclass("previousCallingPoints"),
                 subsequentCallingPoints = get_element(x,
                                                       "subsequentCallingPoints",
                                                       TRUE)) %>%
    reclass("GetServiceDetailsResult")
}

#' @rdname extract
#' @keywords internal
extract.GetStationBoardResult <- function(x, ...) {
  class <- names(x)
  if (length(x) == 1 & inherits(x, class))
    x <- x[[1]]
  tibble::tibble(generatedAt = get_element(x, "generatedAt"),
                 locationName = get_element(x, "locationName"),
                 crs = get_element(x, "crs"),
                 platformAvailable = get_element(x, "platformAvailable"),
                 trainServices =
                   list(get_element(x, "trainServices", TRUE) %>%
                          reclass("trainServices") %>%
                          extract()
                        ),
                 busServices =
                   list(get_element(x, "busServices", TRUE) %>%
                          reclass("busServices") %>%
                          extract()
                        )) %>%
    reclass(class)
}

#' @rdname extract
#' @keywords internal
extract.busServices <- function(x, ...) {
  purrr::map_df(x, function(x) x %>% reclass("service") %>% extract())
}

#' @rdname extract
#' @keywords internal
extract.callingPoint <- function(x, ...) {
  tibble::tibble(generatedAt = get_element(x, "locationName"),
                 serviceType = get_element(x, "crs"),
                 locationName = get_element(x, "st"),
                 crs = get_element(x, "at"))
}

#' @rdname extract
#' @keywords internal
extract.trainServices <- function(x, ...) {
  purrr::map_df(x, function(x) x %>% reclass("service") %>% extract())
}

#' @rdname extract
#' @keywords internal
extract.service <- function(x, ...) {
  tibble::tibble(sta = get_element(x, "sta"),
                 eta = get_element(x, "eta"),
                 platform = get_element(x, "platform"),
                 operator = get_element(x, "operator"),
                 operatorCode = get_element(x, "operatorCode"),
                 serviceType = get_element(x, "serviceType"),
                 serviceID = get_element(x, "serviceID"),
                 rsid = get_element(x, "rsid"),
                 origin = get_element(x, "origin", TRUE),
                 destination = get_element(x, "destination", TRUE),
                 previousCallingPoints =
                   list(get_element(x, "previousCallingPoints", TRUE) #%>%
                          # purrr::map_df(function(x) x[[1]] %>%
                          #                 reclass("callingPoint") %>%
                          #                 extract())
                   ) %>%
                   reclass("previousCallingPoints"),
                 isCancelled = get_element(x, "isCancelled"),
                 cancelReason = get_element(x, "cancelReason"),
                 delayReason = get_element(x, "delayReason"))
}

#' Get all public arrivals
#'
#' Get all public arrivals for the supplied CRS code within a defined time
#' window, including service details.
#'
#' @param crs (string, 3 characters, alphabetic): The CRS code (see above) of
#'     the location for which the request is being made.
#' @param filterCrs (string, 3 characters, alphabetic): The CRS code of either
#'     an origin or destination location to filter in. Optional.
#' @param filterType (string, either "from" or "to"): The type of filter to
#'     apply. Filters services to include only those originating or terminating
#'     at the \code{filterCrs} location. Defaults to "to".
#' @param numRows (integer, between 0 and 150 exclusive): The number of
#'     services to return in the resulting station board.
#' @param timeOffset (integer, between -120 and 120 exclusive): An offset in
#'     minutes against the current time to provide the station board for.
#'     Defaults to 0.
#' @param timeWindow (integer, between -120 and 120 exclusive): How far into
#'     the future in minutes, relative to \code{timeOffset}, to return services
#'     for. Defaults to 120.
#' @param token Token to access the data feed. The token can be obtained at
#'     \url{http://realtime.nationalrail.co.uk/OpenLDBWSRegistration/}.
#' @param url Data feed source URL.
#' @param verbose Boolean flag to indicate whether or not to show status
#'     messages.
#'
#' @return Tibble with arrival records.
#' @export
GetArrBoardWithDetailsRequest <-
  function(crs,
           filterCrs = NA,
           filterType = "to",
           numRows = 150,
           timeOffset = 0,
           timeWindow = 120,
           token = get_token(),
           url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
           verbose = FALSE) {

  # Check arguments

  # Check if filterCrs is not empty
  if (!is.na(filterCrs)) {
    filterCrs <- glue::glue("<ldb:filterCrs>{filterCrs}</ldb:filterCrs>")
  } else {
    filterCrs <- ""
  }

  body <-
    glue::glue('<soap:Envelope
                  xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
                  xmlns:typ="http://thalesgroup.com/RTTI/2013-11-28/Token/types"
                  xmlns:ldb="http://thalesgroup.com/RTTI/2017-10-01/ldb/">
                 <soap:Header>
                    <typ:AccessToken>
                       <typ:TokenValue>{token}</typ:TokenValue>
                    </typ:AccessToken>
                 </soap:Header>
                 <soap:Body>
                    <ldb:GetArrBoardWithDetailsRequest>
                       <ldb:numRows>{numRows}</ldb:numRows>
                       <ldb:crs>{crs}</ldb:crs>
                       <!--Optional:-->
                       {filterCrs}
                       <!--Optional:-->
                       <ldb:filterType>{filterType}</ldb:filterType>
                       <!--Optional:-->
                       <ldb:timeOffset>{timeOffset}</ldb:timeOffset>
                       <!--Optional:-->
                       <ldb:timeWindow>{timeWindow}</ldb:timeWindow>
                    </ldb:GetArrBoardWithDetailsRequest>
                 </soap:Body>
              </soap:Envelope>')

  myheader <- c(Connection = "close",
                # Accept = "text/xml",
                # Accept = "multipart/*",
                'Content-Type' = "text/xml; charset=utf-8",
                # 'Content-Type' = "application/xml",
                'Content-length' = nchar(body))

  RCurl::getURL(url = url,
                postfields = body,
                httpheader = myheader,
                verbose = verbose) %>%
    xml2::read_xml() %>%
    # xml2::xml_find_all(xpath = ".//lt7:trainServices") %>%
    xml2::xml_find_all(".//soap:Body") %>%
    xml2::xml_contents() %>%
    xml2::as_list() %>%
    .[[1]] %>%
    reclass(class = names(.)) %>%
    extract()
    # purrr::map_df(extract) %>%
    # dplyr::bind_rows()
}

#' Get all public departures
#'
#' Get all public departures for the supplied CRS code within a defined time
#' window, including service details.
#'
#' @param crs (string, 3 characters, alphabetic): The CRS code (see above) of
#'     the location for which the request is being made.
#' @param filterCrs (string, 3 characters, alphabetic): The CRS code of either
#'     an origin or destination location to filter in. Optional.
#' @param filterType (string, either "from" or "to"): The type of filter to
#'     apply. Filters services to include only those originating or terminating
#'     at the \code{filterCrs} location. Defaults to "to".
#' @param numRows (integer, between 0 and 150 exclusive): The number of
#'     services to return in the resulting station board.
#' @param timeOffset (integer, between -120 and 120 exclusive): An offset in
#'     minutes against the current time to provide the station board for.
#'     Defaults to 0.
#' @param timeWindow (integer, between -120 and 120 exclusive): How far into
#'     the future in minutes, relative to \code{timeOffset}, to return services
#'     for. Defaults to 120.
#' @param token Token to access the data feed. The token can be obtained at
#'     \url{http://realtime.nationalrail.co.uk/OpenLDBWSRegistration/}.
#' @param url Data feed source URL.
#' @param verbose Boolean flag to indicate whether or not to show status
#'     messages.
#'
#' @return Tibble with departure records.
#' @export
GetArrDepBoardWithDetailsRequest <-
  function(crs,
           filterCrs = NA,
           filterType = "from",
           numRows = 150,
           timeOffset = 0,
           timeWindow = 120,
           token = get_token(),
           url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
           verbose = FALSE) {

    # Check arguments

    # Check if filterCrs is not empty
    if (!is.na(filterCrs)) {
      filterCrs <- glue::glue("<ldb:filterCrs>{filterCrs}</ldb:filterCrs>")
    } else {
      filterCrs <- ""
    }

    body <-
      glue::glue('<soap:Envelope
                  xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
                  xmlns:typ="http://thalesgroup.com/RTTI/2013-11-28/Token/types"
                  xmlns:ldb="http://thalesgroup.com/RTTI/2017-10-01/ldb/">
                 <soap:Header>
                    <typ:AccessToken>
                       <typ:TokenValue>{token}</typ:TokenValue>
                    </typ:AccessToken>
                 </soap:Header>
                 <soap:Body>
                    <ldb:GetArrDepBoardWithDetailsRequest>
                       <ldb:numRows>{numRows}</ldb:numRows>
                       <ldb:crs>{crs}</ldb:crs>
                       <!--Optional:-->
                       {filterCrs}
                       <!--Optional:-->
                       <ldb:filterType>{filterType}</ldb:filterType>
                       <!--Optional:-->
                       <ldb:timeOffset>{timeOffset}</ldb:timeOffset>
                       <!--Optional:-->
                       <ldb:timeWindow>{timeWindow}</ldb:timeWindow>
                    </ldb:GetArrDepBoardWithDetailsRequest>
                 </soap:Body>
              </soap:Envelope>')

    myheader <- c(Connection = "close",
                  # Accept = "text/xml",
                  # Accept = "multipart/*",
                  'Content-Type' = "text/xml; charset=utf-8",
                  # 'Content-Type' = "application/xml",
                  'Content-length' = nchar(body))

    RCurl::getURL(url = url,
                  postfields = body,
                  httpheader = myheader,
                  verbose = verbose) %>%
      xml2::read_xml() %>%
      xml2::xml_find_all(xpath = ".//lt7:trainServices") %>%
      xml2::xml_contents() %>%
      xml2::as_list() %>%
      purrr::map_df(extract) %>%
      dplyr::bind_rows()
}

#' Get service details
#'
#' Get the service details for a specific service identified by a station board.
#' These details are supplied relative to the station board from which the
#' \code{serviceID} field value was generated. Service details are only
#' available while the service appears on the station board from which it was
#' obtained. This is normally for two minutes after it is expected to have
#' departed, or after a terminal arrival. If a request is made for a service
#' that is no longer available then a \code{NULL} value is returned.
#'
#' @param serviceID (string): The LDBWS service ID of the service to request
#'     the details of. The service ID is obtained from a service listed in a
#'     \code{StationBoard} object returned from any other request.
#' @param token Token to access the data feed. The token can be obtained at
#'     \url{http://realtime.nationalrail.co.uk/OpenLDBWSRegistration/}.
#' @param url Data feed source URL.
#' @param verbose Boolean flag to indicate whether or not to show status
#'     messages.
#'
#' @return Tibble with departure records.
#' @export
GetServiceDetailsRequest <-
  function(serviceID,
           token = get_token(),
           url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
           verbose = FALSE) {

    body <-
      glue::glue('<soap:Envelope
                  xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
                  xmlns:typ="http://thalesgroup.com/RTTI/2013-11-28/Token/types"
                  xmlns:ldb="http://thalesgroup.com/RTTI/2017-10-01/ldb/">
                     <soap:Header>
                        <typ:AccessToken>
                           <typ:TokenValue>{token}</typ:TokenValue>
                        </typ:AccessToken>
                     </soap:Header>
                     <soap:Body>
                        <ldb:GetServiceDetailsRequest>
                           <ldb:serviceID>{serviceID}</ldb:serviceID>
                        </ldb:GetServiceDetailsRequest>
                     </soap:Body>
                  </soap:Envelope>')

    header <- c(Connection = "close",
                'Content-Type' = "text/xml; charset=utf-8",
                'Content-length' = nchar(body))

    RCurl::getURL(url = url,
                  postfields = body,
                  httpheader = header,
                  verbose = verbose) %>%
      xml2::read_xml() %>%
      xml2::xml_find_all(".//soap:Body") %>%
      xml2::xml_contents() %>%
      xml2::as_list() %>%
      .[[1]] %>%
      reclass(.[[1]], class = names(.)) %>%
      extract()
      # purrr::map_df(extract) %>%
      # dplyr::bind_rows()
  }

#' Obtain previous calling points
#'
#' @param data List with previous calling point records.
#'
#' @return Tibble with previous calling point records.
#' @export
get_calling_points <- function(data) {
  idx <- purrr::map_lgl(data, ~length(.) != 0)
  data[idx] %>%
    tibble::enframe(., name = "serviceID") %>%
    tidyr::unnest_longer(value) %>%
    tidyr::unnest_wider(value) %>%
    tidyr::unnest(-serviceID) %>%
    dplyr::select(-c(locationName, value_id)) %>%
    dplyr::mutate(timestamp =
                    lubridate::as_datetime(glue::glue("{lubridate::today()} {st}:00 GMT")))
}

