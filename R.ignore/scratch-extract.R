#' @rdname extract
#' @keywords internal
extract.service <- function(x, ...) {
  # Local binding
  . <- NULL
  browser()
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
                 # .[[1]] %>% # callingPointList
                 # purrr::map_df(function(x) x %>%
                 #                 reclass("callingPoint") %>%
                 #                 extract()) %>%
                 # list() %>%
                 # reclass("previousCallingPoints"),
                 # subsequentCallingPoints =
                 #   get_element(x, "subsequentCallingPoints", TRUE) %>%
                 #   .[[1]] %>% # callingPointList
                 #   purrr::map_df(function(x) x %>%
                 #                   reclass("callingPoint") %>%
                 #                   extract()) %>%
                 #   list() %>%
                 #   reclass("subsequentCallingPoints"),
                 subsequentCallingPoints =
                   get_element(x, "subsequentCallingPoints", TRUE) %>%
                   reclass("callingPointList") %>%
                   extract(class = "subsequentCallingPoints"),
                 isCancelled = get_element(x, "isCancelled"),
                 cancelReason = get_element(x, "cancelReason"),
                 delayReason = get_element(x, "delayReason"))
}
