#' @keywords internal
"_PACKAGE"

#' Get all public arrivals
#'
#' Get all public arrivals for the supplied CRS code within a defined time
#' window, including service details.
#'
#' @inheritParams process
#' @inheritParams request
#'
#' @return Tibble with arrival records. Each column is described below:
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
#' @source Documentation for the Live Departure Boards Web Service
#' (LDBWS / OpenLDBWS):
#' \url{http://lite.realtime.nationalrail.co.uk/openldbws/}
# @eval StationBoard_return()
#' @family OpenLDBSVWS requests
#' @export
#' @examples
#' \dontrun{
#' rdg_arr <- trainR::GetArrBoardWithDetailsRequest("RDG")
#' rdg_arr <- trainR::GetArrBoardWithDetailsRequest("RDG", filterCrs = "BRI")
#' trainR::print(rdg_arr)
#' }
GetArrBoardWithDetailsRequest <-
  function(crs,
           filterCrs = NA,
           filterType = "from",
           numRows = 150,
           timeOffset = 0,
           timeWindow = 120,
           token = get_token(),
           url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
           verbose = FALSE) {
  process(crs = crs,
          filterCrs = filterCrs,
          filterType = filterType,
          numRows = numRows,
          timeOffset = timeOffset,
          timeWindow = timeWindow,
          token = token,
          url = url,
          verbose = verbose,
          class = "ArrBoardWithDetails")
}

#' Get all public arrivals and departures
#'
#' Get all public arrivals and departures for the supplied CRS code within a
#' defined time window, including service details.
#'
#' @inheritParams process
#' @inheritParams request
#'
#' @return Tibble with arrival and departure records. Each column is described
#' below:
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
#' @source Documentation for the Live Departure Boards Web Service
#' (LDBWS / OpenLDBWS):
#' \url{http://lite.realtime.nationalrail.co.uk/openldbws/}
#' @family OpenLDBSVWS requests
#' @export
#' @examples
#' \dontrun{
#' rdg<- trainR::GetArrDepBoardWithDetailsRequest("RDG")
#' rdg <- trainR::GetArrDepBoardWithDetailsRequest("RDG", filterCrs = "BRI")
#' trainR::print(rdg)
#' }
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
    process(crs = crs,
            filterCrs = filterCrs,
            filterType = filterType,
            numRows = numRows,
            timeOffset = timeOffset,
            timeWindow = timeWindow,
            token = token,
            url = url,
            verbose = verbose,
            class = "ArrDepBoardWithDetails")
  }

#' Get all public arrivals
#'
#' Get all public arrivals for the supplied CRS code within a defined time
#' window.
#'
#' @inheritParams process
#' @inheritParams request
#'
#' @return Tibble with arrival records. Each column is described below:
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
#' @source Documentation for the Live Departure Boards Web Service
#' (LDBWS / OpenLDBWS):
#' \url{http://lite.realtime.nationalrail.co.uk/openldbws/}
# @eval StationBoard_return()
#' @family OpenLDBSVWS requests
#' @export
#' @examples
#' \dontrun{
#' rdg_arr <- trainR::GetArrBoardRequest("RDG")
#' rdg_arr <- trainR::GetArrBoardRequest("RDG", filterCrs = "BRI")
#' trainR::print(rdg_arr)
#' }
GetArrBoardRequest <-
  function(crs,
           filterCrs = NA,
           filterType = "from",
           numRows = 150,
           timeOffset = 0,
           timeWindow = 120,
           token = get_token(),
           url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
           verbose = FALSE) {
    process(crs = crs,
            filterCrs = filterCrs,
            filterType = filterType,
            numRows = numRows,
            timeOffset = timeOffset,
            timeWindow = timeWindow,
            token = token,
            url = url,
            verbose = verbose,
            class = "ArrivalBoard")
  }

#' Get all public departures
#'
#' Get all public departures for the supplied CRS code within a defined time
#' window.
#'
#' @inheritParams process
#' @inheritParams request
#'
#' @return Tibble with departure records. Each column is described below:
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
#' @source Documentation for the Live Departure Boards Web Service
#' (LDBWS / OpenLDBWS):
#' \url{http://lite.realtime.nationalrail.co.uk/openldbws/}
#' @family OpenLDBSVWS requests
#' @export
#' @examples
#' \dontrun{
#' rdg_dep <- trainR::GetDepBoardRequest("RDG")
#' rdg_dep <- trainR::GetDepBoardRequest("RDG", filterCrs = "BRI")
#' trainR::print(rdg_dep)
#' }
GetDepBoardRequest <-
  function(crs,
           filterCrs = NA,
           filterType = "to",
           numRows = 150,
           timeOffset = 0,
           timeWindow = 120,
           token = get_token(),
           url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
           verbose = FALSE) {
    process(crs = crs,
            filterCrs = filterCrs,
            filterType = filterType,
            numRows = numRows,
            timeOffset = timeOffset,
            timeWindow = timeWindow,
            token = token,
            url = url,
            verbose = verbose,
            class = "DepartureBoard")
  }

#' Get all public departures
#'
#' Get all public departures for the supplied CRS code within a defined time
#' window, including service details.
#'
#' @inheritParams process
#' @inheritParams request
#'
#' @return Tibble with departure records. Each column is described below:
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
#' @source Documentation for the Live Departure Boards Web Service
#' (LDBWS / OpenLDBWS):
#' \url{http://lite.realtime.nationalrail.co.uk/openldbws/}
#' @family OpenLDBSVWS requests
#' @export
#' @examples
#' \dontrun{
#' rdg_dep <- trainR::GetDepBoardWithDetailsRequest("RDG")
#' rdg_dep <- trainR::GetDepBoardWithDetailsRequest("RDG", filterCrs = "BRI")
#' trainR::print(rdg_dep)
#' }
GetDepBoardWithDetailsRequest <-
  function(crs,
           filterCrs = NA,
           filterType = "to",
           numRows = 150,
           timeOffset = 0,
           timeWindow = 120,
           token = get_token(),
           url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
           verbose = FALSE) {
    process(crs = crs,
            filterCrs = filterCrs,
            filterType = filterType,
            numRows = numRows,
            timeOffset = timeOffset,
            timeWindow = timeWindow,
            token = token,
            url = url,
            verbose = verbose,
            class = "DepBoardWithDetails")
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
#'
#' @inheritParams process
#' @inheritParams request
#'
#' @return Tibble with departure records.
#' @family OpenLDBSVWS requests
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
    request(body, header, url, verbose, c("ServiceDetails", "service"))
  }

#' Process \code{StationBoard} request
#'
#' @param crs (string, 3 characters, alphabetic): The CRS code of the location
#'     for which the request is being made.
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
#' @param class String with request class.
#' @param extra String with extra classes (default = "StationBoard").
#' @return Tibble with request data.
#' @keywords internal
process <- function(crs,
                    filterCrs = NA,
                    filterType = "to",
                    numRows = 150,
                    timeOffset = 0,
                    timeWindow = 120,
                    token = get_token(),
                    url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
                    verbose = FALSE,
                    class = NULL,
                    extra = "StationBoard") {
  # Check arguments
  is_valid_crs(crs)

  # Check if filterCrs is not empty
  if (!is.na(filterCrs)) {
    is_valid_crs(filterCrs, "filterCrs")
    filterCrs <- glue::glue("<ldb:filterCrs>{filterCrs}</ldb:filterCrs>")
  } else {
    filterCrs <- ""
  }

  # Create SOAP request components
  header <- glue::glue("<typ:AccessToken>
                           <typ:TokenValue>{token}</typ:TokenValue>
                        </typ:AccessToken>")
  body <- glue::glue("<ldb:Get{class}Request>
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
                      </ldb:Get{class}Request>")
  # Submit request
  request(body, header, url, verbose, class = c(class, extra))
}

#' Submit a SOAP XML request
#'
#' @param body XML body arguments.
#' @param header XML header arguments.
#' @param url Data feed source URL.
#' @param verbose Boolean flag to indicate whether or not to show status
#'     messages.
#' @inheritParams process
#'
#' @return Request results or error message if not found.
#' @keywords internal
request <- function(body, header, url, verbose = FALSE, class = NULL) {
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
    reclass(class = class) %>% # Update class of the result object
    extract()
}
