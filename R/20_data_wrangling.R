# put here functions that transform your data

# examples are

#' add_id_to_df
#'
#' @param df dataframe with columns key and record_id
#'
#' @return dataframe with additional id column
#' @export
#'
#' @examples
add_id_to_df <- function(df) {
  df <- df %>%
    mutate(id = create_id(key, record_id))
  return(df)
}

#' clean_columns
#' transform numeric columns to integer columns
#'
#' @param df dataframe
#'
#' @return dataframe with all numeric columns converted to integer columns
#' @export
#'
#' @examples
clean_columns <- function(df) {
  df <- df %>%
    mutate_if(is.numeric, as.integer)
  return(df)
}

#' get_data_for_id
#' filter for a specific id
#'
#' @param df dataframe with id column
#' @param the_id the id to filter for
#'
#' @return
#' @export
#'
#' @examples
get_data_for_id <- function(df, the_id) {
  if (the_id == 0)
    return(df)
  
  df <- df %>% 
    filter(id == the_id)
  return(df)
}

reverse_items_in_df <- function(df, reversed_items, max_value){
  # x <- matrix(ncol = length(reversed_items), nrow= 1)
  # colnames(x) <- reversed_items
  # df_bfi <- cbind(df_bfi, x)
  # for (i in 1:length(reversed_items)){
  #   df_bfi[,reversed_items[i]] <- max_value- df_bfi[,original_to_reverse[i]]
  # }
  
  # tidyverse version
  df_res <- df %>%
    mutate_at(reversed_items, reverse_item, max_value)
  
  return(df_res)
}


process_data_bewertungen <- function(df){
  
 df_by_kan_exp <- df %>% filter(bewertungen_complete=="Complete") %>% rowwise() %>% 
   mutate(sum_by_expert=sum(impact, qualitat, erfindersgeist, kooperation, unternehmerisch, na.rm=T),
          bewertungen=sum(is.na(impact), is.na(qualitat), is.na(erfindersgeist), is.na(kooperation), is.na(unternehmerisch)),
          mean_by_expert=sum_by_expert/(5-bewertungen))
 
 df_by_kan <- df_by_kan_exp %>% group_by(kandidat_in) %>% 
   summarize(sum_impact=sum(impact, na.rm=T), mean_impact=mean(impact, na.rm=T),
             sum_qualitat=sum(qualitat, na.rm=T), mean_qualitat=mean(qualitat, na.rm=T),
             sum_erfindersgeist=sum(erfindersgeist, na.rm=T), mean_erfindersgeist=mean(erfindersgeist, na.rm=T),
             sum_kooperation=sum(kooperation, na.rm=T), mean_kooperation=mean(kooperation, na.rm=T),
             sum_unternehmerisch=sum(unternehmerisch, na.rm=T), mean_unternehmerisch=mean(unternehmerisch, na.rm=T),
             sum_total=sum(sum_by_expert, na.rm=T), mean_total=mean(mean_by_expert, na.rm=T), evaluations=n(),
             percentage_score = mean_total/7*100)
 df_by_kan[is.na(df_by_kan)] <- NA
 df_by_kan[df_by_kan==0] <- NA
 
 # Mutate the amounts, so that the project name is added to the canidate name
 amounts2 = amounts %>% mutate(kandidat_in = paste0(kandidat_in, " (", Projekttitel, ")"))
 
 df_by_kan <- left_join(df_by_kan, amounts2, by="kandidat_in") %>% mutate(kandidat_in = paste0("ID ", ID, ": ", kandidat_in)) %>% select(-ID)
 return(df_by_kan)
}

#Function to create a dataframe with the represented results
process_results <- function(df){
  df_out <- df %>% arrange(desc(percentage_score)) %>% mutate(Rang=dense_rank(desc(percentage_score)), percentage_score=round(percentage_score, digits=2)) %>% 
    mutate(`Kumulierter angeforderter Betrag (CHF)`=cumsum(`Beantragte DIZH Gelder (CHF)`))%>% 
    select(Rang, kandidat_in, percentage_score, evaluations, Projekttitel, `Beantragte DIZH Gelder (CHF)`, `Kumulierter angeforderter Betrag (CHF)`) 
  colnames(df_out) <- c("Rang", "Kandidat:in (Hauptantragsteller:in)", "Gesamtscore (% theoretischer Maximalscore)", "Anzahl erhaltene Bewertungen", "Projekttitel", "Beantragte DIZH Gelder (CHF)", "Kumulierter angeforderter Betrag (CHF)") 
  df_out <- df_out %>%
    select(Rang, `Kandidat:in (Hauptantragsteller:in)`, Projekttitel, `Anzahl erhaltene Bewertungen`, `Gesamtscore (% theoretischer Maximalscore)`, `Beantragte DIZH Gelder (CHF)`, `Kumulierter angeforderter Betrag (CHF)`)
  
  return(df_out)
}

#Function to create a table by person by score
process_results_by_criterion <- function(df){
  df2 <- df %>% select(kandidat_in, mean_impact, mean_qualitat, mean_erfindersgeist, 
                mean_kooperation, mean_unternehmerisch, evaluations) %>% 
    mutate(impact=round(mean_impact*100/7, digits=2), qualitat=round(mean_qualitat*100/7, digits=2),
           erfindersgeist=round(mean_erfindersgeist*100/7, digits=2), kooperation=round(mean_kooperation*100/7, digits=2), unternehmerisch=round(mean_unternehmerisch*100/7, digits=2)) %>%
    select(kandidat_in, evaluations, impact, qualitat, erfindersgeist, kooperation, unternehmerisch)
  colnames(df2) <- c( "Kandidat:in (Hauptantragsteller:in)", "Anzahl erhaltene Bewertungen", "Impact: \n Gesamtscore (% theoretischer Maximalscore)",
                      "Fachliche Qualität: \n Gesamtscore (% theoretischer Maximalscore)", "Erfindergeist und Risikobereitschaft: \n Gesamtscore (% theoretischer Maximalscore)",
                      "Kooperation und disziplinärer Dialog: \n Gesamtscore (% theoretischer Maximalscore)", "Unternehmerisches Mindset: \n Gesamtscore (% theoretischer Maximalscore)")
  return(df2)
}
