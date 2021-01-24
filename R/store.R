#' Store object to disk
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' @details
#' The goal of this generic is to facilitate storing data retrieved from
#' arrival and departure boards. Each request has multiple parts that should be
#' stored individually (e.g. Excel Workbook or individual CSV files).
#'
#' @param x Data.
#' @param ... Optional parameters.
#'
#' @return Nothing, call for its side effect.
#' @rdname store
#' @export
store <- function(x, ...) {
  UseMethod("store", x)
}

#' @param file String with filename and path.
#' @rdname store
#' @export
#'
#' @examples
#' \dontrun{
#' `%>%` <- magrittr::`%>%`
#' pad <- trainR::GetArrBoardWithDetailsRequest("PAD")
#' pad %>%
#'   trainR::store(file = "arrivals-PAD.xlsx")
#'
#' # Delete test file
#' unlink("arrivals-PAD.xlsx")
#' }
store.StationBoard <- function(x, ..., file) {
  # Local bindings
  busServices <- ferryServices <- nrccMessages <- trainServices <- NULL

  # Create workbook
  wb <- openxlsx::createWorkbook(title = "trainR")
  # Add worksheet "StationBoard"
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
#' @export
store.trainServices <- function(x, ..., wb) {
  # Local bindings
  . <- crs <- destination <- locationName <- origin <- NULL
  previousCallingPoints <- subsequentCallingPoints <- value <- NULL

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

  # Find services without previous and subsequential calling points
  idx <- is.na(x[[1]]$previousCallingPoints) & is.na(x[[1]]$subsequentCallingPoints)
  x[[1]] <- x[[1]][!idx, ]
  if (any(!is.na(x[[1]]$previousCallingPoints)) |
      any(!is.na(x[[1]]$subsequentCallingPoints)))
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
#' @export
store.CallingPoints <- function(x, ..., wb, serviceID) {
  # Local bindings
  . <- crs <- locationName <- value <- NULL

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
#' @export
store.previousCallingPoints <- function(x, ..., wb, serviceID) {
  # Local bindings
  . <- crs <- locationName <- value <- NULL

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
#' @export
store.subsequentCallingPoints <- function(x, ..., wb, serviceID) {
  # Local bindings
  . <- crs <- locationName <- value <- NULL

  names(x) <- serviceID
  x %>%
    tibble::enframe(., name = "serviceID") %>%
    tidyr::unnest(value) %>%
    dplyr::filter(!is.na(locationName) & !is.na(crs)) %>%
    dplyr::select(-value) %>%
    openxlsx::writeData(wb = wb, sheet = "subsequentCallingPoints", ...)
}
