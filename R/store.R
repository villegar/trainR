#' Store object to disk
#'
#' @param x Data.
#' @param ... Optional parameters.
#'
#' @return Nothing, call for its side effect.
#' @rdname store
#' @keywords internal
store <- function(x, ...) {
  UseMethod("store", x)
}

#' @param file String with filename and path.
#' @rdname store
#' @keywords internal
store.StationBoard <- function(x, ..., file) {
  wb <- openxlsx::createWorkbook(title = "trainR")
  openxlsx::addWorksheet(wb, "StationBoard")
  x %>%
    dplyr::select(-c(nrccMessages,
                     trainServices,
                     busServices,
                     ferryServices)) %>%
    openxlsx::writeData(wb = wb, sheet = "StationBoard")
  openxlsx::addWorksheet(wb, "trainServices")
  if (all(!is.na(x$trainServices)))
      store(x$trainServices, wb = wb)
  openxlsx::saveWorkbook(wb, file = file)
}

#' @param wb Workbook object, created with
#'     \code{\link[openxlsx:createWorkbook]{openxlsx::createWorkbook}}.
#' @rdname store
#' @keywords internal
store.trainServices <- function(x, ..., wb) {
  services <- x[[1]] %>%
    dplyr::mutate(origin_crs = purrr::map(origin, "crs"),
                  origin_via = purrr::map(origin, "via"),
                  dest_crs = purrr::map(destination, "crs"),
                  dest_via = purrr::map(destination, "via")) %>%
    dplyr::select(-c(origin,
                     destination,
                     previousCallingPoints,
                     subsequentCallingPoints)) #%>%
  openxlsx::writeData(wb, "trainServices", services)
  # openxlsx::write.xlsx(file = file, sheetName = "trainServices", row.names = FALSE, overwrite = FALSE)
  openxlsx::addWorksheet(wb, "CallingPoints")

  purrr::map_df(x[[1]]$serviceID,
              function(serviceID) {
                prev <- x[[1]]$previousCallingPoints[x[[1]]$serviceID == serviceID]
                subs <- x[[1]]$subsequentCallingPoints[x[[1]]$serviceID == serviceID]
                if (any(!is.na(prev)) | any(!is.na(subs))) {
                  aux <- list(prev[[1]], subs[[1]])
                  names(aux) <- rep(serviceID, 2)
                  aux <- aux %>%
                    tibble::enframe(., name = "serviceID") %>%
                    tidyr::unnest(value) %>%
                    dplyr::filter(!is.na(locationName) & !is.na(crs))
                  if ("value" %in% colnames(aux))
                    aux <- aux %>%
                      dplyr::select(-value)
                  aux
                } else {
                  NA
                }
              }) %>%
    openxlsx::writeData(wb = wb, sheet = "CallingPoints", ...)

  # openxlsx::addWorksheet(wb, "previousCallingPoints")
  # if (any(!is.na(x[[1]]$previousCallingPoints)))
  #   store(x[[1]]$previousCallingPoints, wb = wb, serviceID = x[[1]]$serviceID)
  # openxlsx::addWorksheet(wb, "subsequentCallingPoints")
  # if (any(!is.na(x[[1]]$subsequentCallingPoints)))
  #   store(x[[1]]$subsequentCallingPoints, wb = wb, serviceID = x[[1]]$serviceID)
}

#' @inheritParams GetServiceDetailsRequest
#' @rdname store
#' @keywords internal
store.CallingPoints <- function(x, ..., wb, serviceID) {
  names(x) <- serviceID
  x %>%
    tibble::enframe(., name = "serviceID") %>%
    tidyr::unnest(value) %>%
    dplyr::filter(!is.na(locationName) & !is.na(crs)) %>%
    dplyr::select(-value) %>%
    openxlsx::writeData(wb = wb, sheet = "CallingPoints", ...)
}

#' @inheritParams GetServiceDetailsRequest
#' @rdname store
#' @keywords internal
store.previousCallingPoints <- function(x, ..., wb, serviceID) {
  names(x) <- serviceID
  x %>%
    tibble::enframe(., name = "serviceID") %>%
    tidyr::unnest(value) %>%
    dplyr::filter(!is.na(locationName) & !is.na(crs)) %>%
    dplyr::select(-value) %>%
    openxlsx::writeData(wb = wb, sheet = "previousCallingPoints", ...)
}

#' @inheritParams GetServiceDetailsRequest
#' @rdname store
#' @keywords internal
store.subsequentCallingPoints <- function(x, ..., wb, serviceID) {
  names(x) <- serviceID
  x %>%
    tibble::enframe(., name = "serviceID") %>%
    tidyr::unnest(value) %>%
    dplyr::filter(!is.na(locationName) & !is.na(crs)) %>%
    dplyr::select(-value) %>%
    openxlsx::writeData(wb = wb, sheet = "subsequentCallingPoints", ...)
}
