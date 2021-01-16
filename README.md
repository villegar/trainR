
<!-- README.md is generated from README.Rmd. Please edit that file -->

# trainR: An Interface to the National Rail Enquiries Systems <img src="https://raw.githubusercontent.com/villegar/trainR/main/inst/images/logo.png" alt="logo" align="right" height=200px/>

<!-- badges: start -->

[![](https://img.shields.io/badge/devel%20version-0.0.1-yellow.svg)](https://github.com/villegar/trainR)
[![R build
status](https://github.com/villegar/trainR/workflows/R-CMD-check/badge.svg)](https://github.com/villegar/trainR/actions)
[![](https://www.r-pkg.org/badges/version/trainR?color=black)](https://cran.r-project.org/package=trainR)
<!-- badges: end -->

The goal of `trainR` is to provide a simple interface to the National
Rail Enquiries (NRE) systems. There are few data feeds available, the
simplest of them is Darwin, which provides real-time arrival and
departure predictions, platform numbers, delay estimates, schedule
changes and cancellations. There are other data feeds that provide
historical data, Historic Service Performance (HSP), and much more.
`trainR` simplifies the data retrieval, so the users can focus on their
analyses. For more details visit
<https://www.nationalrail.co.uk/46391.aspx>.

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
`.Renviron` file; this can be done by executing the following command:

``` r
trainR::set_token()
```

This will open a text file, `.Renviron`, add a new line at the end (as
follows):

``` bash
NRE="<token>"
```

`<token>` should be replaced by the access token obtained from the NRE.
Save the changes and restart your R session.

You only need to perform this configuration once.

## Example

Load `trainR` to your working environment:

``` r
library(trainR)
```

### Arrivals board at Reading Station (RDG)

Generated on 2021-01-16 19:44:48.

``` r
rdg_arr <- trainR::GetArrBoardWithDetailsRequest("RDG")
print(rdg_arr)
#> Reading (RDG) Station Board on 2021-01-16 19:44:48
#> Time   From                                    Plat  Expected
#> 19:39  Manchester Piccadilly                   13    19:44
#> 19:41  London Waterloo                         4     19:43
#> 19:44  London Paddington                       12    On time
#> 19:45  London Paddington                       7B    On time
#> 19:46  London Paddington                       9     On time
#> 19:50  Swansea                                 11    19:52
#> 19:51  Gatwick Airport                         5     On time
#> 19:58  Great Malvern                           10A   On time
#> 19:59  Basingstoke                             2     On time
#> 20:08  London Paddington                       8     On time
```

<!-- Inspect the `rdg_arr` object: -->

<!-- #### Previous calling points -->

### Departures board at Reading Station (RDG)

Generated on 2021-01-16 19:44:48.

``` r
rdg_dep <- trainR::GetDepBoardWithDetailsRequest("RDG")
print(rdg_dep)
#> Reading (RDG) Station Board on 2021-01-16 19:44:48
#> Time   To                                      Plat  Expected
#> 19:42  London Waterloo                         5     On time
#> 19:47  Bedwyn                                  7B    On time
#> 19:49  Oxford                                  9     On time
#> 19:52  Basingstoke                             2     On time
#> 19:52  Ealing Broadway                         14    On time
#> 19:53  Didcot Parkway                          12    On time
#> 19:55  London Paddington                       11    On time
#> 20:00  London Paddington                       10A   On time
#> 20:01  Redhill                                 6     On time
#> Time   To                                      Plat  Expected
#> 19:55  Swindon (Wilts)                         BUS   On time
```

<!-- #### Previous calling points -->

## Acknowledgements

Access to the data feeds it is only possible thanks to the National Rail
Enquiries. This package is just a tool to facilitate access to the data.
For more information about the available data feeds, visit
<https://www.nationalrail.co.uk>.

![](https://raw.githubusercontent.com/villegar/trainR/main/inst/images/NRE_Powered_logo.jpg)
