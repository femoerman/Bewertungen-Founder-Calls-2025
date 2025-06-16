#' run this config script to set the secrets as environment variables
#' run this as well if you are not starting the shiny app, so that all files
#' from the R folder are sourced

CONFIG_SUCCESS <- FALSE
source("secret_keys.R")
scripts <- paste0("R/", list.files("R/", recursive = FALSE))
source("install.R")
lapply(scripts, source)


# LOAD FUNCTIONS FOR TOKENS ----------------------------------------------------
# create a file "secret_keys.R with a function for each of your token,
# at least three: artenliste, daecher, bugs/heuschrecken, etc.
# get_token_<projectname/short> <- function() {
#   api_token <- "your token, REDCap project specific"
#   return(api_token)
# }
#
# seems complicated? These functions hide the way of storing the tokens from
# the rest of your code. If you decide to use an external tool, or Renviron
# you only need to change these functions, and not any other places in your code
# source("secret_token.R")


# SUCCESSFULLY LOADED THE CONFIG -----------------------------------------------
CONFIG_SUCCESS <- TRUE
