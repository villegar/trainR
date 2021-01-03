## code to prepare `station_codes` dataset goes here

filename <- "https://www.nationalrail.co.uk/station_codes%20(07-12-2020).csv"
station_codes <- readr::read_csv(filename)
names(station_codes) <- rep(1:2, 4)
station_codes <- dplyr::bind_rows(station_codes[, 1:2],
                                  station_codes[, 3:4],
                                  station_codes[, 5:6])[, 1:2]
colnames(station_codes) <- c("name", "crs")

station_codes <- station_codes[!is.na(station_codes$name) &
                               !is.na(station_codes$crs), ]
usethis::use_data(station_codes, overwrite = TRUE)

