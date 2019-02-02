#' change_dates
#' 
#' Alter the start and end date for a daily 1-month query
#'
#' @param form_query a list with url, query and input like daily_month
#' @param end_date the end date for the 1-month query in Date format
#'
#' @return an updated form query
#' @export
#'
#' @examples
#' change_dates()
#' @seealso \code{\link{daily_month}}
change_dates <- function(form_query, end_date) {
  # initial values for missing form_queryeters
  if (missing(form_query)) {
    form_query = rlinky::daily_month
  }
  if (missing(end_date)) {
    end_date = Sys.Date()
  }
  # start date should be one month before end date
  dateDebut = seq(from = end_date,
                  by = "-1 month",
                  length.out = 2)[2]
  # Find where to change form query content: start date ends with _dateDebut
  num_dateDebut = grep("_dateDebut$",names(form_query$input))
  stopifnot(length(num_dateDebut)==1)
  # change start date
  form_query$input[[num_dateDebut]] = format(dateDebut,"%d/%m/%Y")
  # end date ends with _dateFin
  num_end_date = grep("_dateFin$",names(form_query$input))
  stopifnot(length(num_end_date)==1)
  # change end date
  form_query$input[[num_end_date]] = format(end_date,"%d/%m/%Y")
  # return updated form parameters
  return(form_query)
}