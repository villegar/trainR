
<!-- README.md is generated from README.Rmd. Please edit that file -->

# trainR: An Interface to the National Rail Enquiries Systems <img src="https://raw.githubusercontent.com/villegar/trainR/main/inst/images/logo.png" alt="logo" align="right" height=200px/>

<!-- badges: start -->

[![](https://www.r-pkg.org/badges/version/trainR?color=black)](https://cran.r-project.org/package=trainR)
[![](https://img.shields.io/badge/devel%20version-0.0.1-yellow.svg)](https://github.com/villegar/trainR)
[![R build
status](https://github.com/villegar/trainR/workflows/R-CMD-check/badge.svg)](https://github.com/villegar/trainR/actions)
[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
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

Generated on 2021-01-24 16:37:39.

``` r
rdg_arr <- trainR::GetArrBoardWithDetailsRequest("RDG")
print(rdg_arr)
#> Reading (RDG) Station Board on 2021-01-24 16:37:40
#> Time   From                                    Plat  Expected
#> 16:18  Bristol Temple Meads                    10    16:38
#> 16:39  Manchester Piccadilly                   13    On time
#> 16:41  London Paddington                       7B    On time
#> 16:43  London Paddington                       14    16:37
#> 16:45  Salisbury                               1     On time
#> 16:51  Swansea                                 10A   16:53
#> 16:58  Worcester Shrub Hill                    10A   On time
#> 16:45  Guildford                               BUS   On time
#> 16:50  Swindon                                 BUS   On time
#> 16:52  Ascot                                   BUS   On time
```

<!-- Inspect the `rdg_arr` object: -->

<!-- #### Previous calling points -->

### Departures board at Reading Station (RDG)

Generated on 2021-01-24 16:37:40.

``` r
rdg_dep <- trainR::GetDepBoardWithDetailsRequest("RDG")
print(rdg_dep)
#> Reading (RDG) Station Board on 2021-01-24 16:37:40
#> Time   To                                      Plat  Expected
#> 16:25  London Paddington                       10    16:44
#> 16:35  Newbury                                 8     On time
#> 16:38  Basingstoke                             2     On time
#> 16:46  Bristol Temple Meads                    7B    On time
#> 16:52  Ealing Broadway                         14    On time
#> 16:55  London Paddington                       10A   On time
#> 16:40  Guildford                               BUS   On time
#> 16:45  Ascot                                   BUS   On time
#> 16:55  Chippenham                              BUS   On time
#> 17:00  Ascot                                   BUS   On time
```

<!-- #### Previous calling points -->

## Acknowledgements

Access to the data feeds it is only possible thanks to the National Rail
Enquiries. This package is just a tool to facilitate access to the data.
For more information about the available data feeds, visit
<https://www.nationalrail.co.uk>.

<img alt="Powered by NRE logo" src="https://raw.githubusercontent.com/villegar/trainR/main/inst/images/NRE_Powered_logo.jpg" style="max-width:400px;width:100%">
