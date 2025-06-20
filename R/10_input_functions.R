#' read_data_redcap
#' define here your way to read in the main dataset that you want to display
#' attention: don't put any credentials in the code that you add to git
#' this implementation requires the environment variables redcap_url and redcap_api_token
#'
#' @return the dataset as read from REDCap
#' @export
#'
#' @examples
read_data_redcap <- function() {
  # example: reading from REDCap
  df <- NULL
  print(Sys.getenv("redcap_url", unset = NA))
  df <- read_from_redcap(Sys.getenv("redcap_url", unset = NA), Sys.getenv("redcap_api_token", unset = NA))
  return(df)
}

#' read_data_csv
#' sample definition of a function that reads a specific csv file from the data folder
#'
#' @return the dataframe
#' @export
#'
#' @examples
read_data_csv <- function() {
  df <- read.csv2("data/DFFShinyDemoBigFiveI_DATA.csv", sep=",")
  return(df)
}

#' read_data_xlsx
#' sample definition of a function that reads a xlsx file from the data folder
#'
#' @param filename filename including path of the excell file to readin
#' @param sheet number or name of the sheet to read in
#'
#' @return the dataframe
#' @export
#'
#' @examples
read_data_xlsx <- function(filename, sheet) {
  df <- readxl::read_excel(filename, sheet=sheet)
  return(df)
}


#' get the id from the URL
#' such parameters are found in the URL after the ?
#' for example: https://url-to-shiny-app.ch/?id=42
#'
#' @param session 
#'
#' @return return the id, for the purpose of this sample app, if no parameter is found a fixed value is returned
#' @export
#'
#' @examples
get_id <- function(session){
  query <- parseQueryString(session$clientData$url_search)
  if (!is.null(query[['id']])) {
    return(query[['id']])
  } else {
    return(0)
    #return(0)
  }
}

import_redcap_bewertungen <- function(env.deploy="rstudio"){
  #1) Read in the data from the REDCap repository. This only happens once
  if(env.deploy!="posit"){
    data <- read_from_redcap(redcap_url , redcap_token)
  } else {
    data <- read_from_redcap(Sys.getenv("redcap_url", unset=NA) , Sys.getenv("redcap_api_token", unset=NA))
  }
  
  if(nrow(data)==0){
    data<- data.frame(record_id=character(), kandidat_in=character(), fachexpert_in=character(), fachexpert_in_andere=character(), 
                      impact=numeric(), impact_information = character(),
                      qualitat=numeric(), qualitat_information = character(),
                      erfindersgeist=numeric(), erfindersgeist_information = character(),
                      kooperation=numeric(),kooperation_information = character(),
                      unternehmerisch=numeric(), unternehmerisch_information = character(),
                      information=character(),
                      bewertungen_complete=character())
  }
  
  #Return the dataset
  return(data)
}

