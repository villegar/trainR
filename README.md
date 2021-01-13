
<!-- README.md is generated from README.Rmd. Please edit that file -->

# trainR: An Interface to the National Rail Enquiries Systems <img src="https://raw.githubusercontent.com/villegar/trainR/main/inst/images/logo.png" alt="logo" align="right" height=200px/>

<!-- badges: start -->

[![](https://img.shields.io/badge/devel%20version-0.0.1-yellow.svg)](https://github.com/villegar/trainR)
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

## Setup

Before starting to retrieve data from the NRE data feeds, you must
obtain an access token. Visit the following website for details:
<http://realtime.nationalrail.co.uk/OpenLDBWSRegistration/>

Once you have received your access token, you have to store it in the
`.Renviron` file. This can be done by executing the following command:

``` r
trainR::set_token()
```

This will open a text file, `.Renviron`, add a new line at the end:

``` bash
NRE="<token>"
```

`<token>` should be replaced by the access token obtained from the NRE.
Save the changes and restart your session.

This configuration is done once, unless you somehow delete the
`.Renviron` file.

## Example

Load `trainR` to your working environment:

``` r
library(trainR)
```

### Arrivals board at Reading Station (RDG)

Generated on 2021-01-13 15:05:25.

``` r
rdg_arr <- trainR::GetArrBoardWithDetailsRequest("RDG")
print(rdg_arr)
#> Reading (RDG) Station Board on 2021-01-13 15:05:26
#> Time     From                                    Plat    Expected
#> 14:59    Didcot Parkway                          14      On time
#> 14:59    Penzance                                11      On time
#> 15:06    Bournemouth                             8       15:03
#> 15:10    London Waterloo                         4       On time
#> 15:11    London Paddington                       9       On time
#> 15:13    London Paddington                       13      On time
#> 15:14    London Paddington                       12      On time
#> 15:16    London Paddington                       9B      On time
#> 15:22    Bedwyn                                  11A     On time
#> 15:26    Basingstoke                             2       On time
```

<!-- Inspect the `rdg_arr` object: -->

<!-- #### Previous calling points -->

### Departures board at Reading Station (RDG)

Generated on 2021-01-13 15:05:26.

``` r
rdg_dep <- trainR::GetDepBoardWithDetailsRequest("RDG")
print(rdg_dep)
#> Reading (RDG) Station Board on 2021-01-13 15:05:27
#> Time     To                                      Plat    Expected
#> 15:04    London Paddington                       11      On time
#> 15:05    Basingstoke                             2       On time
#> 15:10    Ealing Broadway                         14      On time
#> 15:10    Newbury                                 1       On time
#> 15:12    London Waterloo                         6       On time
#> 15:13    Swansea                                 9       On time
#> 15:15    Manchester Piccadilly                   8       On time
#> 15:18    Redhill                                 NA  On time
#> 15:18    Worcester Foregate Street               9B      On time
#> 15:22    Ealing Broadway                         13      On time
```

<!-- #### Previous calling points -->
