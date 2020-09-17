if(!require(pacman)) install.packages("pacman")
pacman::p_load("NCmisc")

# parse all functions called by an R script
# lists them by package

list.functions.in.file('Classification_ML_Workflow.R', alphabetic = TRUE)

list.functions.in.file('Regression_ML_Workflow.R', alphabetic = TRUE)