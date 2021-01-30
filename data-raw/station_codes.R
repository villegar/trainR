## code to prepare the `station_codes` dataset
filename <- "https://www.nationalrail.co.uk/station_codes%20(07-12-2020).csv"
station_codes <- readr::read_csv(filename)
names(station_codes) <- rep(c("name", "crs"), 4)
station_codes <- station_codes %>%
  tidyr::pivot_longer(c("name", "crs"), names_repair = "minimal") %>%
  tidyr::pivot_wider(values_fn = list) %>%
  tidyr::unnest(cols = c("name", "crs")) %>%
  dplyr::arrange(name)

# Find rows with NAs
station_codes <- station_codes[!is.na(station_codes$name) &
                               !is.na(station_codes$crs), ]

# Find duplicates
idx <- which(duplicated(station_codes$crs))
if (length(idx) > 0) {
  # Show duplicated CRS codes
  station_codes[station_codes$crs %in% station_codes$crs[idx], ]
  # Remove duplicated
  station_codes <- station_codes[-idx, ]
}
usethis::use_data(station_codes, overwrite = TRUE)

