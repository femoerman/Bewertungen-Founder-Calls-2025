#This script contains functions that can be used to display specific plots. This can be used to store the 
#code for specific figure formats, that may repeatedly be created in the shiny app.
#Currently, a function is included to generate standardized vertical plots

# parallelplot_id <- function(df, the_id) {
#   other_text <- ifelse(the_id == 0, "all", "the others")
#    df %>%
#     select(id, happiness, activity) %>%
#     pivot_longer(!id, names_to = "variable") %>%
#     mutate(Legend = factor(ifelse(id == the_id, "you", other_text))) %>%
#     #mutate(is_id = factor(ifelse(id == the_id), "YOU", "others")) %>%
#     ggplot(aes(x=variable, y=value, colour=Legend, group=factor(id))) +
#     geom_path(position = "identity") +
#     geom_point()
# }
# 
# 
# create_overview_plot <- function(df) {
#   df %>%
#     select(happiness, activity) %>%
#     pivot_longer(everything(), names_to = "variable") %>%
#     ggplot(aes(x=variable, y=value)) + 
#     geom_boxplot()
# }


  

create_standardized_vertical_plot <- function(standardized_scales){
  g <- ggplot(data=standardized_scales) + 
    geom_path(aes(y=20:1, x=value))+
    geom_point(aes(x=value, y=scale), stat = "identity")+ 
    scale_y_discrete(limits=rev, name="Facets")+
    annotate("rect", xmin=-1,xmax=1, ymin=0, ymax=21, alpha=0.3, fill="grey80") 
  
  return(g)
}


#Create a barplot with the scores
create_barplot <- function(df){
  pal <- wes_palette("Zissou1", 100, type = "continuous")
  if(nrow(df)==0){
    plot_out <- ggplot() + theme_void()
  } else {
    plot_out <- ggplot(df, aes(x=reorder(`Kandidat:in (Hauptantragsteller:in)`, Rang), y=`Gesamtscore (% theoretischer Maximalscore)`), colour="grey", fill="grey") + 
      geom_bar(stat="identity") + xlab("Kandidat:in (Hauptantragsteller:in)") +
      geom_line(inherit.aes = F, data=df, mapping = aes(x=reorder(`Kandidat:in (Hauptantragsteller:in)`, Rang), y=`Gesamtscore (% theoretischer Maximalscore)`, group=1), size=3, colour="Black") + 
      theme_bw() + 
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank(), axis.line = element_line(colour = "black"),
            axis.text.x = element_text(size=12, angle = 45, hjust = 1), axis.title = element_text(size=15),
            axis.text.y = element_text(size=12), legend.position = "none") 
  } 
  
  return(plot_out)
    
}

#Create a barplot for all the criteria
create_barplot_criteria <- function(df){
  if(nrow(df)==0){
    plot_out <- ggplot() + theme_void()
  } else {
    df_plot <- gather(df, key="Criterion", value = "Gesamtscore (% theoretischer Maximalscore)", `Impact: \n Gesamtscore (% theoretischer Maximalscore)`,
                      `Fachliche Qualität: \n Gesamtscore (% theoretischer Maximalscore)`, `Erfindergeist und Risikobereitschaft: \n Gesamtscore (% theoretischer Maximalscore)`,
                      `Kooperation und disziplinärer Dialog: \n Gesamtscore (% theoretischer Maximalscore)`, `Unternehmerisches Mindset: \n Gesamtscore (% theoretischer Maximalscore)`)
    plot_out <- ggplot(df_plot, aes(x=`Kandidat:in (Hauptantragsteller:in)`, y=`Gesamtscore (% theoretischer Maximalscore)`), colour="grey", fill="grey") +
      facet_wrap(~Criterion, ncol=2, ) + 
      geom_bar(stat="identity", position=position_dodge()) + 
      guides(fill=guide_legend(ncol=2), colour=guide_legend(ncol=2)) + 
      theme_bw() + 
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank(), axis.line = element_line(colour = "black"),
            axis.text.x = element_text(size=12, angle = 45, hjust = 1), axis.title = element_text(size=15),
            axis.text.y = element_text(size=12), strip.text = element_text(size=10), legend.position = "bottom") 
  } 
  return(plot_out)
}
