#' access_enedis
#' 
#' Access Enedis website and check we can reach it.
#' 
#' Accède au site d'Enedis et vérifie qu'on peut l'atteindre.
#'
#' @param enedis_url defaults to "https://espace-client-connexion.enedis.fr/auth/UI/Login"
#' @param realm defaults to "particuliers"
#' @param goto defaults to "https://espace-client-particuliers.enedis.fr/group/espace-particuliers/accueil"
#'
#' @return the result of httr::GET query
#' @importFrom httr GET
#' @importFrom httr status_code
#' @importFrom httr http_status
#' @export
#'
#' @examples
#' access_enedis()
access_enedis <- function(enedis_url = paste(
  "https://espace-client-connexion.enedis.fr",
  "auth/UI/Login", sep = "/"),
                           realm = "particuliers",
                           goto = paste(
                             "https://espace-client-particuliers.enedis.fr",
                             "group/espace-particuliers/accueil",
                             sep = "/")) {
  # Page accueil Enedis
  r2 <- GET(url = enedis_url,
            query = list(realm = realm,
                         goto = goto))
  # Cette requete devrait aboutir a un statut 200 (HTTP_OK) ou au moins < 300
  if (status_code(r2) >= 300) {
    stop(paste(enedis_url,
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
#' un fichier "secretfile" au format json qui contient ses identifiants. Ce fichier
#' peut contenir quelque chose comme:
#' {
#'   "IDToken1": ["mon.mail@pour.enedis"],
#'   "IDToken2": ["mon.mot.de.passe.pour.enedis"]
#' }
#'
#' @param enedis_url defaults to "https://espace-client-connexion.enedis.fr/auth/UI/Login"
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
#'
#' @examples
#' connect_enedis(secretfile = "~/.secret_enedis_json")
connect_enedis <- function(enedis_url = paste(
  "https://espace-client-connexion.enedis.fr",
  "auth/UI/Login", sep = "/"),
  realm = "particuliers",
  goto = paste(
    "https://espace-client-particuliers.enedis.fr",
    "group/espace-particuliers/accueil",
    sep = "/"),
  secretfile = ".secret_enedis_json") {
  
  # 1) Lire le contenu de la page d'enedis
  r2 = access_enedis(enedis_url,realm,goto)
  # 2) si je suis encore connecte inutile de faire l'etape login
  if (!grepl("MODE CONNECTE", content(r2,"text"))) {
    # 3) Recup infos formulaire login
    loginForm2 <- xml_find_all(content(r2), ".//form")
    loginForm2 <- loginForm2[which(xml_attr(loginForm2, "name") == "Login")]
    if(length(loginForm2) != 1) {
      stop("Absence de formulaire Login sur cette page")
    }
    # 4) Dans ce formulaire on veut les input
    input2 <- xml_find_all(loginForm2,".//input")
    # Supprimer le bouton submit
    if (any(xml_attr(input2,"type")=="submit")) {
      input2 <- input2[-which(xml_attr(input2,"type") == "submit")]
    }
    # 5) Placer les valeurs de ces input dans une liste
    list2 <- as.list(xml_attr(input2,"value"))
    names(list2) <- xml_attr(input2,"name")
    
    # 6) Recuperer mes identifiants pour me connecter sur le site d'enedis
    infosConnect = fromJSON(file(secretfile))
    list2$IDToken1 = infosConnect$IDToken1
    list2$IDToken2 = infosConnect$IDToken2
    
    # 7) Poster ces information pour me connecter
    r3 <- POST(url = enedis_url,
               body = list2,
               encode="form") 
    stopifnot(grepl("Suivre ma consommation",content(r3,"text")))
  } else {
    cat("Reprise de la connection en cours\n")
    r3 = r2;
  }
  return(r3)
}

