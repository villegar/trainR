
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

Load `trainR` to your working environment:

``` r
library(trainR)
```

### Arrivals boards at Reading Station (RDG)

Generated on 2021-01-13 10:03:46.

``` r
rdg_arr <- trainR::GetArrBoardWithDetailsRequest("RDG")
print(rdg_arr)
#> Reading (RDG) Station Board on 2021-01-13 10:03:46
#> Time     From                                    Plat    Expected
#> 09:55    Worcester Shrub Hill                    11A     09:59
#> 10:00    Penzance                                11      10:03
#> 10:05    Didcot Parkway                          15      10:08
#> 10:06    Swansea                                 10      On time
#> 10:10    London Waterloo                         5       On time
#> 10:11    Bedwyn                                  11A     On time
#> 10:11    London Paddington                       9       On time
#> 10:13    London Paddington                       14      On time
#> 10:14    Bristol Temple Meads                    10      On time
#> 10:19    Basingstoke                             2       On time
```

Inspect the `rdg_arr` object:

``` r
rdg_arr %>%
  dplyr::select(-c(5:6)) %>% # Drop the lists of train and bus services
  knitr::kable()
if (!is.na(rdg_arr %>% dplyr::select(5) %>% .[[1]]))
  rdg_arr %>%
    dplyr::select(5) %>%
    .[[1]] %>%
    .[[1]] %>%
    dplyr::select(-previousCallingPoints) %>%
    knitr::kable(caption = "Train services")
if (!is.na(rdg_arr %>% dplyr::select(6) %>% .[[1]]))
  rdg_arr %>%
    dplyr::select(6) %>%
    .[[1]] %>%
    .[[1]] %>%
    dplyr::select(-previousCallingPoints) %>%
    knitr::kable(caption = "Bus services")
```

<!-- #### Previous calling points -->

### Departures board at Reading Station (RDG)

Generated on 2021-01-13 10:03:46.

``` r
rdg_dep <- trainR::GetDepBoardWithDetailsRequest("RDG")
print(rdg_dep)
#> Reading (RDG) Station Board on 2021-01-13 10:03:47
#> Time     To                                      Plat    Expected
#> 09:57    London Paddington                       11A     10:01
#> 10:04    London Paddington                       11      On time
#> 10:08    London Paddington                       10      On time
#> 10:12    London Paddington                       11A     On time
#> 10:12    London Waterloo                         6       On time
#> 10:12    Newbury                                 1       On time
#> 10:13    Swansea                                 9       On time
#> 10:15    Ealing Broadway                         15      On time
#> 10:15    Manchester Piccadilly                   7       On time
#> 10:16    London Paddington                       10      On time
```

<!-- #### Previous calling points -->
