#' change_dates
#' 
#' Alter the start and end date for a enedis data query
#'
#' Change les dates de début et de fin pour une requête afin d'obtenir des
#' relevés 
#'
#' @param form_query a list with url, query and input like daily_month or hourly_day
#' @param end_date the end date 
#' @param start_date the start date
#' @param by_period a negative time interval to compute start_date from end_date. 
#' Ignored if start_date is provided. Passed as \code{by} argument to \code{\link{seq.POSIXt}}
#'
#' @return an updated form query
#' @export
#'
#' @examples
#' myquery <- change_dates(daily_month, by_period = "-2 months")
#' myquery <- change_dates(hourly_day, by_period = "-10 days")
#' @seealso \code{\link{daily_month}}
#' @seealso \code{\link{hourly_day}}
#' @seealso \code{\link{query_daily_month}}
change_dates <- function(form_query, end_date, start_date, by_period) {
  # initial values for missing parameters
  if (missing(form_query)) {
    form_query <- rlinky::daily_month
  }
  if (missing(end_date)) {
    end_date <- Sys.Date()
  }
  if (missing(by_period)) {
    by_period <- "-1 month"
  }
  if (missing(start_date)) {
    # start date should be by_period before end date
    start_date <- seq(from = end_date,
                      by = by_period,
                      length.out = 2)[2]
  }
  # Find where to change form query content: start date ends with _dateDebut
  num_start_date <- grep("_dateDebut$", names(form_query$input))
  if (length(num_start_date) != 1) {
    stop("Could not find a unique field with _dateDebut")
  }
  # change start date
  form_query$input[[num_start_date]] <- format(start_date, "%d/%m/%Y")
  # end date ends with _dateFin
  num_end_date <- grep("_dateFin$", names(form_query$input))
  stopifnot(length(num_end_date) == 1)
  if (length(num_end_date) != 1) {
    stop("Could not find a unique field with _dateFin")
  }
  # change end date
  form_query$input[[num_end_date]] <- format(end_date, "%d/%m/%Y")
  # return updated form parameters
  return(form_query)
}

#' query_daily_month
#' 
#' Query daily records for one month
#' 
#' Requête sur un mois de relevés quotidiens
#' 
#' @param form_query a list with url, query and input like daily_month
#' @param end_date the end date for the 1-month query in Date format
#'
#' @return a list 
#' @importFrom httr POST
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
#' @export
#'
#' @examples
#' connect_enedis(secretfile = "~/.secret_enedis_json")
#' this_month_data <- query_daily_month(end_date = Sys.Date())
#' disconnect_enedis()
#' kWh <- this_month_data$graphe$data$valeur
#' day1 <- as.Date(this_month_data$graphe$periode$dateDebut, 
#'                 format="%d/%m/%Y")
#' Horodate <- seq(from = day1, length.out = length(kWh), by="day")
#' plot(Horodate, kWh, type="b", pch=16,
#'      main = paste("Daily records since ", day1),
#'      xlab = "Date", ylab = "power consumption (kWh)")
#' 
#' @seealso \code{\link{connect_enedis}}
#' @seealso \code{\link{disconnect_enedis}}

query_daily_month <- function(form_query, end_date) {
  # initial values for missing parameters
  if (missing(form_query)) {
    form_query <- rlinky::daily_month
  }
  if (missing(end_date)) {
    end_date <- Sys.Date()
  }
  # One month query for daily data : update start and end date
  form_query <- change_dates(form_query, end_date)
  # Send form
  r4 <- POST(url = form_query$url,
             handle = handle_find(rlinky::enedis_url),
             body = form_query$input,
             encode = "form",
             query = form_query$query)
  # Check for expired session error
  if (grepl("SESSION EXPIREE", content(r4, "text"))) {
    stop("Session expired")
  }
  # Return data as list
  return(fromJSON(content(r4, "text")))
}
