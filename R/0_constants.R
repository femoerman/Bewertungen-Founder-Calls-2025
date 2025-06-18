#Variable for the deployment environment. Should be set to rstudio (ran from desktop) or posit (deployed online)
env.deploy <- "posit"
source("/secrets/api-token.R")

amounts <- read.csv("/secrets/dizh_amounts.csv", sep = ";", header = T)
colnames(amounts) <- c("ID", "kandidat_in", "Beantragte DIZH Gelder (CHF)", "Projekttitel")
