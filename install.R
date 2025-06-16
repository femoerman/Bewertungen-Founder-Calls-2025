# This file contains packages which should be added to the notebook
# during the build process. It is standard R code which is run during
# the build process and typically comprises a set of `install.packages()`
# commands.
#
# For example, remove the comment from the line below if you wish to
# install the `ggplot2` package.
#
# install.packages('ggplot2')
if (!require(tidyverse)) install.packages('tidyverse')
if (!require(shiny)) install.packages('shiny')
if (!require(ggpubr)) install.packages('ggpubr')
if (!require(RColorBrewer)) install.packages('RColorBrewer')
if (!require(REDCapR)) install.packages('REDCapR')
if (!require(wesanderson)) install.packages('wesanderson')
# install.packages("tidyverse") # the tidyverse: dplyr, ggplot,...
# install.packages("shiny") # shiny core
# install.packages("ggpubr") # ggpubr to combine plots
# install.packages("RColorBrewer") #Colorbrewer to make custom color palettes
# install.packages("REDCapR")
# install.packages("wesanderson")