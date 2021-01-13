
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

Generated on 2021-01-13 19:31:04.

``` r
rdg_arr <- trainR::GetArrBoardWithDetailsRequest("RDG")
print(rdg_arr)
#> Reading (RDG) Station Board on 2021-01-13 19:31:04
#> Time   From                                    Plat  Expected
#> 19:29  London Paddington                       7     On time
#> 19:30  London Paddington                       12    On time
#> 19:31  Cheltenham Spa                          11A   On time
#> 19:33  Redhill                                 4     19:41
#> 19:34  Basingstoke                             2     On time
#> 19:34  London Paddington                       8     19:41
#> 19:39  Bristol Temple Meads                    10A   19:42
#> 19:41  London Paddington                       9     19:46
#> 19:43  London Paddington                       13    On time
#> 19:44  London Paddington                       12    On time
```

<!-- Inspect the `rdg_arr` object: -->

<!-- #### Previous calling points -->

### Departures board at Reading Station (RDG)

Generated on 2021-01-13 19:31:04.

``` r
rdg_dep <- trainR::GetDepBoardWithDetailsRequest("RDG")
print(rdg_dep)
#> Reading (RDG) Station Board on 2021-01-13 19:31:05
#> Time   To                                      Plat  Expected
#> 19:30  Didcot Parkway                          12    On time
#> 19:31  Plymouth                                7     On time
#> 19:34  London Paddington                       11A   On time
#> 19:36  Bedwyn                                  8     19:42
#> 19:36  London Waterloo                         5     On time
#> 19:41  London Paddington                       10A   19:43
#> 19:42  Newbury                                 1     On time
#> 19:43  Swansea                                 9     19:47
#> 19:49  Bournemouth                             7     On time
#> 19:49  London Paddington                       10    19:52
```

<!-- #### Previous calling points -->

## Acknowledgements

Access to the data feeds it is only possible thanks to the National Rail
Enquiries. This package is just a tool to facilitate access to the data.
For more information about the available data feeds, visit
<https://www.nationalrail.co.uk>.

![](https://raw.githubusercontent.com/villegar/trainR/main/inst/images/NRE_Powered_logo.jpg)
