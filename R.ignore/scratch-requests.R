GetArrivalBoard <- function(crs,
                            filterCrs = NA,
                            filterType = "from",
                            numRows = 150,
                            timeOffset = 0,
                            timeWindow = 120,
                            token = get_token(),
                            url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
                            verbose = FALSE) {
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
  body <- glue::glue("<ldb:GetArrivalBoardRequest>
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
                      </ldb:GetArrivalBoardRequest>")

  # Submit request
  request(body, header, url, verbose, type = "ArrivalBoard")
}

GetArrivalDepartureBoard <- function(crs,
                                     filterCrs = NA,
                                     filterType = "from",
                                     numRows = 150,
                                     timeOffset = 0,
                                     timeWindow = 120,
                                     token = get_token(),
                                     url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
                                     verbose = FALSE) {
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
  body <- glue::glue("<ldb:GetArrivalDepartureBoardRequest>
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
                      </ldb:GetArrivalDepartureBoardRequest>")

  # Submit request
  request(body, header, url, verbose, type = "ArrivalDepartureBoard")
}

GetDepartureBoard <- function(crs,
                              filterCrs = NA,
                              filterType = "from",
                              numRows = 150,
                              timeOffset = 0,
                              timeWindow = 120,
                              token = get_token(),
                              url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
                              verbose = FALSE) {
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
  body <- glue::glue("<ldb:GetDepartureBoardRequest>
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
                      </ldb:GetDepartureBoardRequest>")

  # Submit request
  request(body, header, url, verbose, type = "DepartureBoard")
}

GetFastestDepartures <- function(crs,
                                 filterCrs = NA, # vector allow
                                 timeOffset = 0,
                                 timeWindow = 120,
                                 token = get_token(),
                                 url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
                                 verbose = FALSE) {
  # Check arguments
  is_valid_crs(crs)

  # Check if filterCrs are not empty
  if (!is.na(filterCrs)) {
    purrr::walk(filterCrs, is_valid_crs)
    filterCrs <- purrr::map_chr(filterCrs,
                                ~glue::glue("<ldb:crs>{.}</ldb:crs>")) %>%
      paste0(., collapse = "") %>%
      paste0("<ldb:filterList>", ., "</ldb:filterList>")
  } else {
    filterCrs <- ""
  }

  # Create SOAP request components
  header <- glue::glue("<typ:AccessToken>
                           <typ:TokenValue>{token}</typ:TokenValue>
                        </typ:AccessToken>")
  body <- glue::glue("<ldb:GetFastestDeparturesRequest>
                         <ldb:crs>{crs}</ldb:crs>
                         {filterCrs}
                         <!--Optional:-->
                         <ldb:timeOffset>{timeOffset}</ldb:timeOffset>
                         <!--Optional:-->
                         <ldb:timeWindow>{timeWindow}</ldb:timeWindow>
                      </ldb:GetFastestDeparturesRequest>")

  # Submit request
  request(body, header, url, verbose, type = "FastestDepartures")
}

GetFastestDeparturesWithDetails <- function(crs,
                                            filterCrs = NA, # vector
                                            timeOffset = 0,
                                            timeWindow = 120,
                                            token = get_token(),
                                            url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
                                            verbose = FALSE) {
  # Check arguments
  is_valid_crs(crs)

  # Check if filterCrs are not empty
  if (!is.na(filterCrs)) {
    purrr::walk(filterCrs, is_valid_crs)
    filterCrs <- purrr::map_chr(filterCrs,
                                ~glue::glue("<ldb:crs>{.}</ldb:crs>")) %>%
      paste0(., collapse = "") %>%
      paste0("<ldb:filterList>", ., "</ldb:filterList>")
  } else {
    filterCrs <- ""
  }

  # Create SOAP request components
  header <- glue::glue("<typ:AccessToken>
                           <typ:TokenValue>{token}</typ:TokenValue>
                        </typ:AccessToken>")
  body <- glue::glue("<ldb:GetFastestDeparturesWithDetailsRequest>
                         <ldb:crs>{crs}</ldb:crs>
                         {filterCrs}
                         <!--Optional:-->
                         <ldb:timeOffset>{timeOffset}</ldb:timeOffset>
                         <!--Optional:-->
                         <ldb:timeWindow>{timeWindow}</ldb:timeWindow>
                      </ldb:GetFastestDeparturesWithDetailsRequest>")
  # Submit request
  request(body, header, url, verbose, type = "FastestDeparturesWithDetails")
}

GetNextDepartures <- function(crs,
                              filterCrs = NA, # vector
                              timeOffset = 0,
                              timeWindow = 120,
                              token = get_token(),
                              url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
                              verbose = FALSE) {
  # Check arguments
  is_valid_crs(crs)

  # Check if filterCrs are not empty
  if (!is.na(filterCrs)) {
    purrr::walk(filterCrs, is_valid_crs)
    filterCrs <- purrr::map_chr(filterCrs,
                                ~glue::glue("<ldb:crs>{.}</ldb:crs>")) %>%
      paste0(., collapse = "") %>%
      paste0("<ldb:filterList>", ., "</ldb:filterList>")
  } else {
    filterCrs <- ""
  }

  # Create SOAP request components
  header <- glue::glue("<typ:AccessToken>
                           <typ:TokenValue>{token}</typ:TokenValue>
                        </typ:AccessToken>")
  body <- glue::glue("<ldb:GetNextDeparturesRequest>
                         <ldb:crs>{crs}</ldb:crs>
                         {filterCrs}
                         <!--Optional:-->
                         <ldb:timeOffset>{timeOffset}</ldb:timeOffset>
                         <!--Optional:-->
                         <ldb:timeWindow>{timeWindow}</ldb:timeWindow>
                      </ldb:GetNextDeparturesRequest>")
  # Submit request
  request(body, header, url, verbose, type = "NextDepartures")
}

GetNextDeparturesWithDetails <- function(crs,
                                         filterCrs = NA, # vector
                                         timeOffset = 0,
                                         timeWindow = 120,
                                         token = get_token(),
                                         url = "https://lite.realtime.nationalrail.co.uk/OpenLDBWS/ldb11.asmx",
                                         verbose = FALSE) {
  # Check arguments
  is_valid_crs(crs)

  # Check if filterCrs are not empty
  if (!is.na(filterCrs)) {
    purrr::walk(filterCrs, is_valid_crs)
    filterCrs <- purrr::map_chr(filterCrs,
                                ~glue::glue("<ldb:crs>{.}</ldb:crs>")) %>%
      paste0(., collapse = "") %>%
      paste0("<ldb:filterList>", ., "</ldb:filterList>")
  } else {
    filterCrs <- ""
  }

  # Create SOAP request components
  header <- glue::glue("<typ:AccessToken>
                           <typ:TokenValue>{token}</typ:TokenValue>
                        </typ:AccessToken>")
  body <- glue::glue("<ldb:GetNextDeparturesWithDetailsRequest>
                         <ldb:crs>{crs}</ldb:crs>
                         {filterCrs}
                         <!--Optional:-->
                         <ldb:timeOffset>{timeOffset}</ldb:timeOffset>
                         <!--Optional:-->
                         <ldb:timeWindow>{timeWindow}</ldb:timeWindow>
                      </ldb:GetNextDeparturesWithDetailsRequest>")
  # Submit request
  request(body, header, url, verbose, type = "NextDeparturesWithDetails")
}
