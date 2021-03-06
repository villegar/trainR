% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/store.R
\name{store}
\alias{store}
\alias{store.StationBoard}
\alias{store.busServices}
\alias{store.ferryServices}
\alias{store.trainServices}
\alias{store.CallingPoints}
\alias{store.previousCallingPoints}
\alias{store.subsequentCallingPoints}
\title{Store object to disk}
\usage{
store(x, ...)

\method{store}{StationBoard}(x, ..., file)

\method{store}{busServices}(x, ..., wb)

\method{store}{ferryServices}(x, ..., wb)

\method{store}{trainServices}(x, ..., wb)

\method{store}{CallingPoints}(x, ..., wb, serviceID)

\method{store}{previousCallingPoints}(x, ..., wb, serviceID)

\method{store}{subsequentCallingPoints}(x, ..., wb, serviceID)
}
\arguments{
\item{x}{Data.}

\item{...}{Optional parameters.}

\item{file}{String with filename and path.}

\item{wb}{Workbook object, created with
\code{\link[openxlsx:createWorkbook]{openxlsx::createWorkbook}}.}

\item{serviceID}{(string): The LDBWS service ID of the service to request
the details of. The service ID is obtained from a service listed in a
\code{StationBoard} object returned from any other request.}
}
\value{
Nothing, call for its side effect.
}
\description{
\ifelse{html}{\out{<a href='https://www.tidyverse.org/lifecycle/#experimental'><img src='figures/lifecycle-experimental.svg' alt='Experimental lifecycle'></a>}}{\strong{Experimental}}
}
\details{
The goal of this generic is to facilitate storing data retrieved from
arrival and departure boards. Each request has multiple parts that should be
stored individually (e.g. Excel Workbook or individual CSV files).
}
\examples{
\dontrun{
`\%>\%` <- magrittr::`\%>\%`
pad <- trainR::GetArrBoardWithDetailsRequest("PAD")
pad \%>\%
  trainR::store(file = "arrivals-PAD.xlsx")

# Delete test file
unlink("arrivals-PAD.xlsx")
}
}
