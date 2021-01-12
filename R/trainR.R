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
  # Local binding
  . <- NULL
  # Check arguments

  # Check if filterCrs is not empty
  if (!is.na(filterCrs)) {
    filterCrs <- glue::glue("<ldb:filterCrs>{filterCrs}</ldb:filterCrs>")
  } else {
    filterCrs <- ""
  }

  # Create SOAP request components
  header <- glue::glue("<typ:AccessToken>
                           <typ:TokenValue>{token}</typ:TokenValue>
                        </typ:AccessToken>")
  body <- glue::glue("<ldb:GetArrBoardWithDetailsRequest>
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
                      </ldb:GetArrBoardWithDetailsRequest>")
  # Submit request
  request(body, header, url, verbose)
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

    # Create SOAP request components
    header <- glue::glue("<typ:AccessToken>
                           <typ:TokenValue>{token}</typ:TokenValue>
                        </typ:AccessToken>")
    body <- glue::glue("<ldb:GetArrDepBoardWithDetailsRequest>
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
                        </ldb:GetArrDepBoardWithDetailsRequest>")
    # Submit request
    request(body, header, url, verbose)
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
    # Create SOAP request components
    header <- glue::glue("<typ:AccessToken>
                           <typ:TokenValue>{token}</typ:TokenValue>
                        </typ:AccessToken>")
    body <- glue::glue("<ldb:GetServiceDetailsRequest>
                           <ldb:serviceID>{serviceID}</ldb:serviceID>
                        </ldb:GetServiceDetailsRequest>")
    # Submit request
    request(body, header, url, verbose)
  }

#' Obtain previous calling points
#'
#' @param data List with previous calling point records.
#'
#' @return Tibble with previous calling point records.
#' @export
get_calling_points <- function(data) {
  # Local binding
  . <- locationName <- serviceID <- value <- value_id <- NULL
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

#' @keywords internal
request <- function(body, header, url, verbose = FALSE) {
  # Local binding
  . <- NULL
  body_contents <-
    glue::glue('<soap:Envelope
                  xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
                  xmlns:typ="http://thalesgroup.com/RTTI/2013-11-28/Token/types"
                  xmlns:ldb="http://thalesgroup.com/RTTI/2017-10-01/ldb/">
                 <soap:Header>
                    {header}
                 </soap:Header>
                 <soap:Body>
                    {body}
                 </soap:Body>
              </soap:Envelope>')

  header_contents <- c(Connection = "close",
                       # Accept = "text/xml",
                       # Accept = "multipart/*",
                       'Content-Type' = "text/xml; charset=utf-8",
                       # 'Content-Type' = "application/xml",
                       'Content-length' = nchar(body_contents))

  # Send request to server
  RCurl::getURL(url = url,
                postfields = body_contents,
                httpheader = header_contents,
                verbose = verbose) %>%
    xml2::read_xml() %>%
    # xml2::xml_find_all(xpath = ".//lt7:trainServices") %>%
    xml2::xml_find_all(".//soap:Body") %>%
    xml2::xml_contents() %>%
    xml2::as_list() %>%
    .[[1]] %>% # Extract request result
    validate() %>% # Validate request result
    reclass(class = names(.)) %>% # Update class of the result object
    extract()
}
