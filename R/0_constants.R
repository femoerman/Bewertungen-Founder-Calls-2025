#Variable for the deployment environment. Should be set to rstudio (ran from desktop) or posit (deployed online)
env.deploy <- "Renku"
redcap_url <- "https://redcap.zhaw.ch/api/"
redcap_token = "4797CC2DED381C6CDBA9E560483A7622"

amounts <- read.csv("data/dizh_amounts.csv", sep = ";", header = T)
colnames(amounts) <- c("ID", "kandidat_in", "Beantragte DIZH Gelder (CHF)", "Projekttitel")
