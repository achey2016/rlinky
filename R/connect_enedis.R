#' access_enedis
#' 
#' Access Enedis website and check we can reach it.
#' 
#' Accède au site d'Enedis et vérifie qu'on peut l'atteindre.
#'
#' @param url Enedis URL for login
#' It defaults to \url{"https://espace-client-connexion.enedis.fr/auth/UI/Login"}
#' but other values may be useful for unit tests
#' @param realm passed as a query to enedis website. 
#' Only tested with "particuliers"
#' @param goto passed as a query to enedis website. 
#' Usually \url{"https://espace-client-particuliers.enedis.fr/group/espace-particuliers/accueil"}
#'
#' @return the result of httr::GET query
#' @importFrom httr GET
#' @importFrom httr status_code
#' @importFrom httr http_status
#' 
#' @export
#' @seealso \code{\link{connect_enedis}}, \code{\link{disconnect_enedis}}
#'
#' @examples
#' access_enedis()
access_enedis <- function(url,
                          realm = "particuliers",
                          goto) {
  if (missing(url)) {
    url <- rlinky::enedis_url;
  }
  if (missing(goto)) {
    goto <- rlinky::enedis_accueil;
  }
  # Page accueil Enedis
  r2 <- GET(url = url,
            query = list(realm = realm,
                         goto = goto))
  # Cette requete devrait aboutir a un statut 200 (HTTP_OK) ou au moins < 300
  if (status_code(r2) >= 300) {
    stop(paste(url,
               "indique une erreur HTTP",
               status_code(r2),
               " : ",
               http_status(r2)$message,
               "\n"))
  }
  return(r2)
}

#' connect_enedis
#' 
#' Connection au site d'enedis. Cette fonction suppose au prealable d'avoir cree
#' un fichier "secretfile" au format json qui contient ses identifiants. 
#' 
#' Le fichier secretfile peut contenir quelque chose comme:
#' 
#' \preformatted{
#' \{   
#'   "IDToken1": ["mon.mail@connu.d.enedis"],   
#'   "IDToken2": ["mon.mot.de.passe.pour.enedis"]   
#' \}   
#' }
#' 
#' @param url defaults to "https://espace-client-connexion.enedis.fr/auth/UI/Login"
#' @param realm defaults to "particuliers"
#' @param goto defaults to "https://espace-client-particuliers.enedis.fr/group/espace-particuliers/accueil"
#' @param secretfile path to your secretfile in json format. chemin d'accès à secretfile.
#'
#' @return the result of httr::GET or httr::POST query
#' 
#' @importFrom httr POST
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
#' @importFrom xml2 xml_attr
#' @importFrom xml2 xml_find_all
#' 
#' @export
#' @seealso \code{\link{disconnect_enedis}}
#' 
#' @examples
#' connect_enedis(secretfile = "~/.secret_enedis_json")
connect_enedis <- function(url,
  realm = "particuliers",
  goto,
  secretfile = "~/.secret_enedis_json") {
  
  if (missing(url)) {
    url <- rlinky::enedis_url;
  }
  if (missing(goto)) {
    goto <- rlinky::enedis_accueil;
  }
  # 1) Lire le contenu de la page d'enedis
  r2 <- access_enedis(url, realm, goto)
  # 2) si je suis encore connecte inutile de faire l'etape login
  if (!grepl("MODE CONNECTE", content(r2, "text"))) {
    # 3) Recup infos formulaire login
    login_form2 <- xml_find_all(content(r2), ".//form")
    login_form2 <- login_form2[which(xml_attr(login_form2, "name") == "Login")]
    if (length(login_form2) != 1) {
      stop("Absence de formulaire Login sur cette page")
    }
    # 4) Dans ce formulaire on veut les input
    input2 <- xml_find_all(login_form2, ".//input")
    # Supprimer le bouton submit
    if (any(xml_attr(input2, "type") == "submit")) {
      input2 <- input2[-which(xml_attr(input2, "type") == "submit")]
    }
    # 5) Placer les valeurs de ces input dans une liste
    list2 <- as.list(xml_attr(input2, "value"))
    names(list2) <- xml_attr(input2, "name")

    # 6) Recuperer mes identifiants pour me connecter sur le site d'enedis
    infos_connect <- fromJSON(file(secretfile))
    list2$IDToken1 <- infos_connect$IDToken1
    list2$IDToken2 <- infos_connect$IDToken2

    # 7) Poster ces information pour me connecter
    r3 <- POST(url = url,
               body = list2,
               encode = "form")
    stopifnot(grepl("Suivre ma consommation", content(r3, "text")))
  } else {
    cat("Reprise de la connection en cours\n")
    r3 <- r2;
  }
  return(r3)
}

#' disconnect_enedis
#' 
#' Disconnect from enedis website
#'
#' @param url Enedis url used to log in
#' @param url_logout Enedis url to be fetched for logout
#'
#' @return the result of httr::GET query
#' @importFrom httr GET
#' @importFrom httr handle_find
#' @export
#' @seealso \code{\link{connect_enedis}}
#' @examples
#' disconnect_enedis()
disconnect_enedis <- function(url, url_logout) {
  if (missing(url)) {
    url <- rlinky::enedis_url;
  }
  if (missing(url_logout)) {
    url_logout <- rlinky::enedis_url_logout;
  }
  r5 <- GET(url = url_logout,
            handle = handle_find(url))
  return(r5)
}