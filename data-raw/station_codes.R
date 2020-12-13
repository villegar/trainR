## code to prepare `station_codes` dataset goes here

filename <- "https://www.nationalrail.co.uk/station_codes%20(07-12-2020).csv"
station_codes <- readr::read_csv(filename)
station_codes <- dplyr::bind_rows(station_codes[, 1:2],
                                  station_codes[, 3:4],
                                  station_codes[, 5:6])[, 1:2]
colnames(station_codes) <- c("name", "crs")
usethis::use_data(station_codes, overwrite = TRUE)
