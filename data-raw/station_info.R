## code to prepare `station_info` dataset goes here
rD <- RSelenium::rsDriver(browser = "firefox", port = 4546L, verbose = FALSE)
base_url <- "http://www.railwaycodes.org.uk/stations/"

station_info <- NULL
for (i in seq_along(letters)) {
  message("Processing stations starting by: ", LETTERS[i])
  rD$client$navigate(paste0(base_url, "station", letters[i], ".shtm"))
  tryCatch({
    out <- rD$client$getPageSource()[[1]] %>%
      xml2::read_html() %>% # parse HTML
      rvest::html_nodes("table#tablesort") # extract table node
    # Find small notes (<em>NOTE</em>)
    em_nodes <- out %>%
      rvest::html_nodes("em")
    # Remove notes
    xml2::xml_remove(em_nodes)
    # Parse page to table
    out <- out %>%
      rvest::html_table(fill = TRUE) %>%
      .[[1]] %>%
      magrittr::set_colnames(c("station",
                               "elr",
                               "mileage",
                               "status",
                               "owner",
                               "operator",
                               "longitude",
                               "latitude",
                               "grid_ref"))
    station_info <- rbind(station_info, out)
  }, error = function(e){
    warning(e)
  })
  Sys.sleep(2)
}
aux <- trainR::station_codes %>%
  dplyr::left_join(station_info, by = c("name" = "station")) %>%
  dplyr::filter(!grepl("nderground", name, ignore.case = TRUE)) # Filter underground stations
aux[is.na(aux$elr), ]

match_names <- function(out, idx, source) {
  string <- tolower(out[idx, 1])
  i <- nchar(string)
  # browser()
  while (i > 0) {
    idx2 <- pmatch(substr(string, 1, i), tolower(source[, 1]))
    if (!is.na(idx2)) {
      print(paste0("Found: ", idx2, " - Matched: '", out[idx, 1], "' to '", source[idx2, 1], "'"))
      # browser()
      out[idx, -c(1:2)] <- source[idx2, -1]
      break
    }
    i <- i - 1
  }
  out
}

##### Concept
# Match missing stations
unmatch_idx <- which(is.na(aux$elr))
aux[unmatch_idx[1],]
idx <- pmatch("Adlington (Lanc", station_info$station)
aux[unmatch_idx[1], -c(1:2)] <- station_info[idx, -1]

### Manually inspect
#### Ashford International (Eurostar)
aux[100, -c(1:2)] <- station_info[101, -1]
aux <- aux[-99, ] # Duplicated Ashford International (Eurostar)
#### Devon Dockyard
idx <- pmatch("Dockyard (Devonport)", station_info$station)
idx2 <- pmatch("Devonport Dockyard", aux$name)
aux[idx2, -c(1:2)] <- station_info[idx, -1]

#### Loop
# Match missing stations
unmatch_idx <- which(is.na(aux$elr))
aux2 <- aux
for (i in unmatch_idx)
  aux2 <- match_names(aux2, i, station_info)

# 2nd round
unmatch_idx <- aux2[is.na(aux2$elr), ]
#### Dinas Rhondda
idx <- pmatch("Dinas Rhondda", station_info$station)
idx2 <- pmatch("Dinas (Rhondda)", aux$name)
aux2[idx2, -c(1:2)] <- station_info[idx, -1]

#### Dorking Deepdene
idx <- pmatch("Dorking (Deepdene)", station_info$station)
idx2 <- pmatch("Dorking Deepdene", aux$name)
aux2[idx2, -c(1:2)] <- station_info[idx, -1]

#### Edenbridge (Kent)
idx <- pmatch("Edenbridge (Kent)", station_info$station)
idx2 <- pmatch("Edenbridge", aux2$name)
aux2[idx2, -c(1:2)] <- station_info[idx, -1]

#### Edinburgh
idx2 <- pmatch("Edinburgh", aux2$name)
aux2[idx2, -c(1:2)] <- station_info[824, -1]

#### Garth (Mid Glamorgan)
idx <- pmatch("Garth (Bridgend County)", station_info$station)
idx2 <- pmatch("Garth (Mid Glamorgan)", aux2$name)
aux2[idx2, -c(1:2)] <- station_info[idx, -1]

#### Heathrow
##### Terminals 2 and 3
idx <- pmatch("Heathrow Terminals 2 and 3 (Rail Station Only)", station_info$station)
idx2 <- pmatch("Heathrow Airport Terminals 1, 2 and 3", aux2$name)
aux2[idx2, -c(1:2)] <- station_info[idx, -1]
##### Terminal 4
idx <- pmatch("Heathrow Terminal 4 (Rail Station Only)", station_info$station)
idx2 <- pmatch("Heathrow Airport Terminal 4", aux2$name)
aux2[idx2, -c(1:2)] <- station_info[idx, -1]
##### Terminal 5
idx <- pmatch("Heathrow Terminal 5 (Rail Station Only)", station_info$station)
idx2 <- pmatch("Heathrow Airport Terminal 5", aux2$name)
aux2[idx2, -c(1:2)] <- station_info[idx, -1]

#### London St Pancras (Intl)
idx <- pmatch("London St Pancras International", station_info$station)
idx2 <- pmatch("London St Pancras (Intl)", aux2$name)
aux2[idx2, -c(1:2)] <- station_info[1516, -1]

#### Remove stations without information:
##### Corfe Castle
aux2 <- aux2[!(aux2$name %in% c("Corfe Castle")), ]

##### Dublin Ferryport and Dublin Port - Stena
aux2 <- aux2[!(aux2$name %in% c("Dublin Ferryport", "Dublin Port - Stena")), ]

aux2[is.na(aux2$elr), ]

#### Convert latitude and longitude to numeric
aux3 <- aux2 %>%
  dplyr::mutate(latitude = as.numeric(latitude),
                longitude = as.numeric(longitude))
#### Find records with NAs (these records have more than one line)
idx <- which(is.na(aux3$latitude) | is.na(aux3$longitude))
#### Parse each location and extract only the top records
tmp <- aux2[idx, ] %>%
  tidyr::separate_rows(latitude, sep = " ", convert = TRUE) %>%
  tidyr::separate_rows(longitude, sep = " ", convert = TRUE) %>%
  tidyr::separate_rows(grid_ref, sep = " ") %>%
  dplyr::filter((is.na(latitude) & is.na(longitude)) |
                (!is.na(latitude) & !is.na(longitude))) %>%
  dplyr::distinct(name, .keep_all = TRUE)

aux3[idx, ] <- tmp

station_info <- aux3
usethis::use_data(station_info, overwrite = TRUE)

aux3_lat <- aux2 %>%
  tidyr::separate_rows(latitude) %>%
  dplyr::filter(latitude != "")
aux3_lon <- aux2 %>%
  tidyr::separate_rows(longitude) %>%
  dplyr::filter(longitude != "")
aux3_grid <- aux2 %>%
  tidyr::separate_rows(grid_ref) %>%
  dplyr::filter(longitude != "")

aux3 <- aux2 %>%
  tidyr::separate_rows(longitude) %>%
  dplyr::filter(longitude != "") %>%
  tidyr::separate_rows(latitude) %>%
  dplyr::distinct(longitude, latitude, .keep_all = TRUE)

df <- tibble::tibble(lon = station_info$longitude,
                     lat = station_info$latitude)
df %>%
  ggmap::qmplot(lon, lat, data = ., size = I(0.5))
