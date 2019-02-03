#' Enedis URL
#'
#' Uniform Ressource Locator for Enedis login dialog
#'
#' @format A character string with the url
#' \describe{
#'   \item{protocol}{https}
#'   \item{site}{espace-client-connexion.enedis.fr}
#'   \item{path}{/auth/UI/Login}
#' }
#' @source \url{https://espace-client-connexion.enedis.fr/auth/UI/Login}
"enedis_url"
#' Enedis connected mode URL
#'
#' Uniform Ressource Locator for Enedis connected mode welcome screen
#'
#' @format A character string with the url
#' \describe{
#'   \item{protocol}{https}
#'   \item{site}{espace-client-particuliers.enedis.fr}
#'   \item{path}{/group/espace-particuliers/accueil}
#' }
#' @source \url{https://espace-client-particuliers.enedis.fr/group/espace-particuliers/accueil}
"enedis_accueil"
#' Enedis disconnect URL
#'
#' Uniform Ressource Locator for Enedis disconnection
#'
#' @format A character string with the url
#' \describe{
#'   \item{protocol}{https}
#'   \item{site}{espace-client-particuliers.enedis.fr}
#'   \item{path}{/c/portal/logout}
#' }
#' @source \url{https://espace-client-particuliers.enedis.fr/c/portal/logout}
"enedis_url_logout"
#' Daily month
#' 
#' Sample content of a form to get daily data for one month
#'
#' @format A list with 3 elements
#' \describe{
#'   \item{url}{url that will receive the POST command: 
#'   
#'   https://espace-client-particuliers.enedis.fr/group/espace-particuliers/suivi-de-consommation}
#'   \item{query}{A list of query parameters for the POST command, like:
#'   \tabular{ll}{
#'   p_p_id: \tab "lincspartdisplaycdc_WAR_lincspartcdcportlet", \cr
#'   p_p_lifecycle: \tab 2, \cr
#'   p_p_state: \tab "normal", \cr
#'   p_p_mode: \tab "view", \cr
#'   p_p_resource_id: \tab "urlCdcJour", \cr
#'   p_p_cacheability: \tab "cacheLevelPage", \cr
#'   p_p_col_id: \tab "column-1", \cr
#'   p_p_col_count: \tab 2}}
#'   \item{input}{A list of input parameters for the POST command, useful to change the 
#'   start and end of the month requested, like
#'   \tabular{ll}{
#'   _lincspartdisplaycdc_WAR_lincspartcdcportlet_dateDebut: \tab "06/12/2018", \cr
#'   _lincspartdisplaycdc_WAR_lincspartcdcportlet_dateFin: \tab "05/01/2019"
#'   }}
#' }
#' @seealso \code{\link{change_dates}}
"daily_month"
