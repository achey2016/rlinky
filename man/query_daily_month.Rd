% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/query_enedis.R
\name{query_daily_month}
\alias{query_daily_month}
\title{query_daily_month}
\usage{
query_daily_month(form_query, end_date)
}
\arguments{
\item{form_query}{a list with url, query and input like daily_month}

\item{end_date}{the end date for the 1-month query in Date format}
}
\value{
a list
}
\description{
Query daily records for one month
}
\details{
Requête sur un mois de relevés quotidiens
}
\examples{
connect_enedis(secretfile = "~/.secret_enedis_json")
this_month_data <- query_daily_month(end_date = Sys.Date())
disconnect_enedis()
kWh <- this_month_data$graphe$data$valeur
day1 <- as.Date(this_month_data$graphe$periode$dateDebut, 
                format="\%d/\%m/\%Y")
Horodate <- seq(from = day1, length.out = length(kWh), by="day")
plot(Horodate, kWh, type="b", pch=16,
     main = paste("Daily records since ", day1),
     xlab = "Date", ylab = "power consumption (kWh)")

}
\seealso{
\code{\link{connect_enedis}}

\code{\link{disconnect_enedis}}
}
