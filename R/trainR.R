#' Extract departure details
#'
#' @param x List with departure details.
#'
#' @return Tibble with departure details.
#' @keywords internal
extract <- function(x) {
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
                 previousCallingPoints = get_element(x,
                                                     "previousCallingPoints",
                                                     TRUE),
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
    xml2::xml_find_all(xpath = ".//lt7:trainServices") %>%
    xml2::xml_contents() %>%
    xml2::as_list() %>%
    purrr::map_df(extract) %>%
    dplyr::bind_rows()
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

