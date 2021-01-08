
<!-- README.md is generated from README.Rmd. Please edit that file -->

# trainR: An Interface to the National Rail Enquiries Systems <img src="https://raw.githubusercontent.com/villegar/trainR/main/inst/images/logo.png" alt="logo" align="right" height=200px/>

<!-- badges: start -->

[![](https://img.shields.io/badge/devel%20version-0.0.0.9000-yellow.svg)](https://github.com/villegar/trainR)
[![R build
status](https://github.com/villegar/trainR/workflows/R-CMD-check/badge.svg)](https://github.com/villegar/trainR/actions)
[![](https://www.r-pkg.org/badges/version/trainR?color=black)](https://cran.r-project.org/package=trainR)
<!-- badges: end -->

The goal of trainR is to provide a simple interface to the National Rail
Enquiries (NRE) systems: <https://www.nationalrail.co.uk/46391.aspx>

## Installation

You can install the released version of trainR from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("trainR")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("villegar/trainR")
```

## Example

### Arrivals boards at Reading Station (RDG)

Generated on 2021-01-08 18:04:44.

``` r
rdg <- trainR::GetArrBoardWithDetailsRequest("RDG") %>%
  dplyr::mutate(origin = purrr::transpose(.$origin) %>%
                  purrr::pluck("crs") %>%
                  purrr::map_chr(as.character),
                destination = purrr::transpose(.$destination) %>%
                  purrr::pluck("crs") %>%
                  purrr::map_chr(as.character))

rdg %>%
  dplyr::select(-11) %>% # Drop the calling points list
  knitr::kable()
```

| sta   | eta     | platform | operator              | operatorCode | serviceType | serviceID                 | rsid     | origin | destination | isCancelled | cancelReason | delayReason                                  |
| :---- | :------ | :------- | :-------------------- | :----------- | :---------- | :------------------------ | :------- | :----- | :---------- | :---------- | :----------- | :------------------------------------------- |
| 17:39 | Delayed | 11       | Great Western Railway | GW           | train       | yeQsrjQQbblj7+HreA/Amg==  | GW143600 | EXD    | PAD         | NA          | NA           | This train has been delayed by a broken rail |
| 17:57 | Delayed | 11       | Great Western Railway | GW           | train       | cdmRYCXr8xZQq0WZkL/c/w==  | GW143800 | PLY    | PAD         | NA          | NA           | This train has been delayed by a broken rail |
| 18:03 | On time | 15       | Great Western Railway | GW           | train       | LcJMQS7aQ/SifoSVz/Sn6g==  | GW228300 | DID    | EAL         | NA          | NA           | NA                                           |
| 18:03 | On time | 7B       | Great Western Railway | GW           | train       | KmZbzwDDZbmaOBfd6hf5jw==  | GW133500 | PAD    | PGN         | NA          | NA           | NA                                           |
| 18:07 | On time | 12       | CrossCountry          | XC           | train       | ByPbk4VU7ykselgmMh5Z3Q==  | XC328000 | BMH    | MAN         | NA          | NA           | NA                                           |
| 18:09 | On time | 11       | Great Western Railway | GW           | train       | IbrthgxX2r1ZqNajVb6UOg==  | GW445400 | BRI    | PAD         | NA          | NA           | NA                                           |
| 18:11 | On time | 9        | Great Western Railway | GW           | train       | \+jY96tK+5qIQ8MjOQvKaVg== | GW635100 | PAD    | CMN         | NA          | NA           | NA                                           |
| 18:13 | On time | 14       | TFL Rail              | XR           | train       | nWBTPXBSFCaMfZD1QcoNvQ==  | XR248600 | PAD    | RDG         | NA          | NA           | NA                                           |
| 18:14 | On time | 5        | South Western Railway | SW           | train       | x6pl1KXFakPchca5/xoWtA==  | SW043100 | WAT    | RDG         | NA          | NA           | NA                                           |
| 18:20 | On time | 2        | Great Western Railway | GW           | train       | 3upol1ey/6QF2szWUnW5RA==  | GW199700 | BSK    | RDG         | NA          | NA           | NA                                           |

#### Previous calling points

``` r
names(rdg$previousCallingPoints) <- rdg$serviceID
trainR::get_calling_points(rdg$previousCallingPoints) %>%
  dplyr::left_join(rdg[, c(7, 9, 10)], by = "serviceID") %>%
  dplyr::select(-c("timestamp")) %>%
  knitr::kable()
```

| serviceID                 | crs | st    | at      | length | et      | origin | destination |
| :------------------------ | :-- | :---- | :------ | :----- | :------ | :----- | :---------- |
| yeQsrjQQbblj7+HreA/Amg==  | EXD | 15:38 | On time | NULL   | NULL    | EXD    | PAD         |
| yeQsrjQQbblj7+HreA/Amg==  | TAU | 16:02 | On time | NULL   | NULL    | EXD    | PAD         |
| yeQsrjQQbblj7+HreA/Amg==  | CLC | 16:23 | On time | NULL   | NULL    | EXD    | PAD         |
| yeQsrjQQbblj7+HreA/Amg==  | WSB | 16:46 | On time | NULL   | NULL    | EXD    | PAD         |
| yeQsrjQQbblj7+HreA/Amg==  | PEW | 17:02 | On time | NULL   | NULL    | EXD    | PAD         |
| yeQsrjQQbblj7+HreA/Amg==  | NBY | 17:22 | On time | NULL   | NULL    | EXD    | PAD         |
| cdmRYCXr8xZQq0WZkL/c/w==  | PLY | 15:14 | On time | NULL   | NULL    | PLY    | PAD         |
| cdmRYCXr8xZQq0WZkL/c/w==  | TOT | 15:40 | On time | NULL   | NULL    | PLY    | PAD         |
| cdmRYCXr8xZQq0WZkL/c/w==  | NTA | 15:53 | On time | NULL   | NULL    | PLY    | PAD         |
| cdmRYCXr8xZQq0WZkL/c/w==  | EXD | 16:14 | On time | NULL   | NULL    | PLY    | PAD         |
| cdmRYCXr8xZQq0WZkL/c/w==  | TVP | 16:28 | On time | NULL   | NULL    | PLY    | PAD         |
| cdmRYCXr8xZQq0WZkL/c/w==  | TAU | 16:41 | On time | NULL   | NULL    | PLY    | PAD         |
| LcJMQS7aQ/SifoSVz/Sn6g==  | DID | 17:39 | On time | NULL   | NULL    | DID    | EAL         |
| LcJMQS7aQ/SifoSVz/Sn6g==  | CHO | 17:44 | On time | NULL   | NULL    | DID    | EAL         |
| LcJMQS7aQ/SifoSVz/Sn6g==  | GOR | 17:49 | On time | NULL   | NULL    | DID    | EAL         |
| LcJMQS7aQ/SifoSVz/Sn6g==  | PAN | 17:53 | 17:55   | NULL   | NULL    | DID    | EAL         |
| LcJMQS7aQ/SifoSVz/Sn6g==  | TLH | 17:58 | 18:00   | NULL   | NULL    | DID    | EAL         |
| KmZbzwDDZbmaOBfd6hf5jw==  | PAD | 17:36 | On time | NULL   | NULL    | PAD    | PGN         |
| KmZbzwDDZbmaOBfd6hf5jw==  | MAI | 17:54 | On time | NULL   | NULL    | PAD    | PGN         |
| ByPbk4VU7ykselgmMh5Z3Q==  | BMH | 16:47 | On time | 9      | NULL    | BMH    | MAN         |
| ByPbk4VU7ykselgmMh5Z3Q==  | SOU | 17:17 | On time | 9      | NULL    | BMH    | MAN         |
| ByPbk4VU7ykselgmMh5Z3Q==  | SOA | 17:24 | On time | 9      | NULL    | BMH    | MAN         |
| ByPbk4VU7ykselgmMh5Z3Q==  | WIN | 17:33 | On time | 9      | NULL    | BMH    | MAN         |
| ByPbk4VU7ykselgmMh5Z3Q==  | BSK | 17:49 | On time | 9      | NULL    | BMH    | MAN         |
| IbrthgxX2r1ZqNajVb6UOg==  | BRI | 17:00 | On time | NULL   | NULL    | BRI    | PAD         |
| IbrthgxX2r1ZqNajVb6UOg==  | BTH | 17:13 | On time | NULL   | NULL    | BRI    | PAD         |
| IbrthgxX2r1ZqNajVb6UOg==  | CPM | 17:26 | On time | NULL   | NULL    | BRI    | PAD         |
| IbrthgxX2r1ZqNajVb6UOg==  | SWI | 17:41 | On time | NULL   | NULL    | BRI    | PAD         |
| IbrthgxX2r1ZqNajVb6UOg==  | DID | 17:57 | On time | NULL   | NULL    | BRI    | PAD         |
| \+jY96tK+5qIQ8MjOQvKaVg== | PAD | 17:48 | On time | NULL   | NULL    | PAD    | CMN         |
| nWBTPXBSFCaMfZD1QcoNvQ==  | PAD | 17:13 | On time | NULL   | NULL    | PAD    | RDG         |
| nWBTPXBSFCaMfZD1QcoNvQ==  | EAL | 17:21 | On time | NULL   | NULL    | PAD    | RDG         |
| nWBTPXBSFCaMfZD1QcoNvQ==  | STL | 17:28 | On time | NULL   | NULL    | PAD    | RDG         |
| nWBTPXBSFCaMfZD1QcoNvQ==  | HAY | 17:31 | 17:33   | NULL   | NULL    | PAD    | RDG         |
| nWBTPXBSFCaMfZD1QcoNvQ==  | WDT | 17:35 | On time | NULL   | NULL    | PAD    | RDG         |
| nWBTPXBSFCaMfZD1QcoNvQ==  | IVR | 17:38 | On time | NULL   | NULL    | PAD    | RDG         |
| nWBTPXBSFCaMfZD1QcoNvQ==  | LNY | 17:40 | 17:42   | NULL   | NULL    | PAD    | RDG         |
| nWBTPXBSFCaMfZD1QcoNvQ==  | SLO | 17:44 | 17:46   | NULL   | NULL    | PAD    | RDG         |
| nWBTPXBSFCaMfZD1QcoNvQ==  | BNM | 17:48 | On time | NULL   | NULL    | PAD    | RDG         |
| nWBTPXBSFCaMfZD1QcoNvQ==  | TAP | 17:51 | 17:54   | NULL   | NULL    | PAD    | RDG         |
| nWBTPXBSFCaMfZD1QcoNvQ==  | MAI | 17:54 | 17:57   | NULL   | NULL    | PAD    | RDG         |
| nWBTPXBSFCaMfZD1QcoNvQ==  | TWY | 18:01 | NULL    | NULL   | 18:04   | PAD    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | WAT | 16:50 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | CLJ | 16:58 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | RMD | 17:06 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | TWI | 17:10 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | FEL | 17:16 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | SNS | 17:24 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | EGH | 17:28 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | VIR | 17:32 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | LNG | 17:36 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | SNG | 17:39 | 17:41   | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | ACT | 17:44 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | MAO | 17:48 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | BCE | 17:51 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | WKM | 17:58 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | WNS | 18:01 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | WTI | 18:03 | On time | NULL   | NULL    | WAT    | RDG         |
| x6pl1KXFakPchca5/xoWtA==  | EAR | 18:06 | NULL    | NULL   | On time | WAT    | RDG         |
| 3upol1ey/6QF2szWUnW5RA==  | BSK | 17:54 | On time | NULL   | NULL    | BSK    | RDG         |
| 3upol1ey/6QF2szWUnW5RA==  | BMY | 18:01 | On time | NULL   | NULL    | BSK    | RDG         |
| 3upol1ey/6QF2szWUnW5RA==  | MOR | 18:06 | NULL    | NULL   | On time | BSK    | RDG         |
| 3upol1ey/6QF2szWUnW5RA==  | RDW | 18:15 | NULL    | NULL   | On time | BSK    | RDG         |

### Departures board at Reading Station (RDG)

Generated on 2021-01-08 18:04:45.

``` r
rdg <- trainR::GetArrDepBoardWithDetailsRequest("RDG") %>%
  dplyr::mutate(origin = purrr::transpose(.$origin) %>%
                  purrr::pluck("crs") %>%
                  purrr::map_chr(as.character),
                destination = purrr::transpose(.$destination) %>%
                  purrr::pluck("crs") %>%
                  purrr::map_chr(as.character))

rdg %>%
  dplyr::select(-11) %>% # Drop the calling points list
  knitr::kable()
```

| sta   | eta     | platform | operator              | operatorCode | serviceType | serviceID                 | rsid     | origin | destination | isCancelled | cancelReason | delayReason                                                |
| :---- | :------ | :------- | :-------------------- | :----------- | :---------- | :------------------------ | :------- | :----- | :---------- | :---------- | :----------- | :--------------------------------------------------------- |
| 17:39 | Delayed | 11       | Great Western Railway | GW           | train       | yeQsrjQQbblj7+HreA/Amg==  | GW143600 | EXD    | PAD         | NA          | NA           | This train has been delayed by a broken rail               |
| 17:57 | Delayed | 11       | Great Western Railway | GW           | train       | cdmRYCXr8xZQq0WZkL/c/w==  | GW143800 | PLY    | PAD         | NA          | NA           | This train has been delayed by a broken rail               |
| NA    | NA      | 14       | TFL Rail              | XR           | train       | au2GQHJI9u7fCUHAeJeyew==  | XR252600 | RDG    | EAL         | NA          | NA           | NA                                                         |
| 18:03 | On time | 7B       | Great Western Railway | GW           | train       | KmZbzwDDZbmaOBfd6hf5jw==  | GW133500 | PAD    | PGN         | NA          | NA           | NA                                                         |
| 18:03 | On time | 15       | Great Western Railway | GW           | train       | LcJMQS7aQ/SifoSVz/Sn6g==  | GW228300 | DID    | EAL         | NA          | NA           | NA                                                         |
| NA    | NA      | 1        | Great Western Railway | GW           | train       | Zsw3EENnZBUOnZsZaDNlnA==  | GW211000 | RDG    | NBY         | NA          | NA           | This train has been delayed by urgent repairs to the track |
| NA    | NA      | 6        | South Western Railway | SW           | train       | iiihZt8GjopYoXBWbhDdQg==  | SW044000 | RDG    | WAT         | NA          | NA           | NA                                                         |
| 18:09 | On time | 11       | Great Western Railway | GW           | train       | IbrthgxX2r1ZqNajVb6UOg==  | GW445400 | BRI    | PAD         | NA          | NA           | NA                                                         |
| NA    | NA      | 2        | Great Western Railway | GW           | train       | 02EAZ/tBa8J/OLBKX3pJzg==  | GW200200 | RDG    | BSK         | NA          | NA           | NA                                                         |
| 18:11 | On time | 9        | Great Western Railway | GW           | train       | \+jY96tK+5qIQ8MjOQvKaVg== | GW635100 | PAD    | CMN         | NA          | NA           | NA                                                         |

#### Previous calling points

``` r
names(rdg$previousCallingPoints) <- rdg$serviceID
trainR::get_calling_points(rdg$previousCallingPoints) %>%
  dplyr::left_join(rdg[, c(7, 9, 10)], by = "serviceID") %>%
  dplyr::select(-c("timestamp")) %>%
  knitr::kable()
```

| serviceID                 | crs | st    | at      | origin | destination |
| :------------------------ | :-- | :---- | :------ | :----- | :---------- |
| yeQsrjQQbblj7+HreA/Amg==  | EXD | 15:38 | On time | EXD    | PAD         |
| yeQsrjQQbblj7+HreA/Amg==  | TAU | 16:02 | On time | EXD    | PAD         |
| yeQsrjQQbblj7+HreA/Amg==  | CLC | 16:23 | On time | EXD    | PAD         |
| yeQsrjQQbblj7+HreA/Amg==  | WSB | 16:46 | On time | EXD    | PAD         |
| yeQsrjQQbblj7+HreA/Amg==  | PEW | 17:02 | On time | EXD    | PAD         |
| yeQsrjQQbblj7+HreA/Amg==  | NBY | 17:22 | On time | EXD    | PAD         |
| cdmRYCXr8xZQq0WZkL/c/w==  | PLY | 15:14 | On time | PLY    | PAD         |
| cdmRYCXr8xZQq0WZkL/c/w==  | TOT | 15:40 | On time | PLY    | PAD         |
| cdmRYCXr8xZQq0WZkL/c/w==  | NTA | 15:53 | On time | PLY    | PAD         |
| cdmRYCXr8xZQq0WZkL/c/w==  | EXD | 16:14 | On time | PLY    | PAD         |
| cdmRYCXr8xZQq0WZkL/c/w==  | TVP | 16:28 | On time | PLY    | PAD         |
| cdmRYCXr8xZQq0WZkL/c/w==  | TAU | 16:41 | On time | PLY    | PAD         |
| KmZbzwDDZbmaOBfd6hf5jw==  | PAD | 17:36 | On time | PAD    | PGN         |
| KmZbzwDDZbmaOBfd6hf5jw==  | MAI | 17:54 | On time | PAD    | PGN         |
| LcJMQS7aQ/SifoSVz/Sn6g==  | DID | 17:39 | On time | DID    | EAL         |
| LcJMQS7aQ/SifoSVz/Sn6g==  | CHO | 17:44 | On time | DID    | EAL         |
| LcJMQS7aQ/SifoSVz/Sn6g==  | GOR | 17:49 | On time | DID    | EAL         |
| LcJMQS7aQ/SifoSVz/Sn6g==  | PAN | 17:53 | 17:55   | DID    | EAL         |
| LcJMQS7aQ/SifoSVz/Sn6g==  | TLH | 17:58 | 18:00   | DID    | EAL         |
| IbrthgxX2r1ZqNajVb6UOg==  | BRI | 17:00 | On time | BRI    | PAD         |
| IbrthgxX2r1ZqNajVb6UOg==  | BTH | 17:13 | On time | BRI    | PAD         |
| IbrthgxX2r1ZqNajVb6UOg==  | CPM | 17:26 | On time | BRI    | PAD         |
| IbrthgxX2r1ZqNajVb6UOg==  | SWI | 17:41 | On time | BRI    | PAD         |
| IbrthgxX2r1ZqNajVb6UOg==  | DID | 17:57 | On time | BRI    | PAD         |
| \+jY96tK+5qIQ8MjOQvKaVg== | PAD | 17:48 | On time | PAD    | CMN         |
