##########################################################
# Author: Chinomnso Ekwedike
# Date: 20/03/2022
# Module: Group Project - CSC8633
# Version: 1.0
##########################################################


# load libraries
#library(dplyr)
#library(readr)


# This analysis creates a new data frame containing four columns of the original dataset
# which include `code_module`, `code_presentation`, `id_assessment` and `date` and a 
# newly created column named `pres_specific`, which id derived from a combination of 
# `code_module` and `code_presentation`.


assessment = read.csv("data/assessments.csv")


# Simple EDA
colnames(assessment)

# check the dimension of the data set
dim(assessment)



# select the needed columns
# create the pre_specific column based on code_module and code_presentation
# rearrange the columns
new_assessments = assessment %>% select(everything(), -weight, -assessment_type) %>% 
                  mutate(pres_specific = paste(code_module, code_presentation, sep = "-")) %>%
                  select(code_module, code_presentation, pres_specific, id_assessment, date)



# confirm the modifications have been made
# print the first and last few rows of the new_assessments data frame
psych::headTail(new_assessments, top = 5, bottom = 5, ellipsis = TRUE)


# View the entire data set
View(new_assessments)



# write the data frame to a csv file
write_csv(new_assessments, "data/pres_specific_assessments_dates.csv")
