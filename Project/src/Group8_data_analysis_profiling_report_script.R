##########################################################
# Author: Chinomnso Ekwedike
# Date: 17/03/2022
# Module: Group Project - CSC8633
# Version: 1.0
##########################################################


library('ProjectTemplate')
load.project()


# load the libraries
# suppress the package start up messages
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(DataExplorer))



# load the data sets into RStudio
s_info = read_csv("data/studentInfo.csv", show_col_types = FALSE)

courses = read_csv("data/courses.csv", show_col_types = FALSE)

student_Reg = read_csv("data/studentRegistration.csv", show_col_types = FALSE)

assessments = read_csv("data/assessments.csv", show_col_types = FALSE)

student_Assessment = read_csv("data/studentAssessment.csv", show_col_types = FALSE)

student_Vle = read_csv("data/studentVle.csv", show_col_types = FALSE)

vle = read_csv("data/vle.csv", show_col_types = FALSE)

student_data = read_csv("data/Student_data.csv", show_col_types = FALSE)



# remove the demographic data contained in the data set
student_Info =  s_info %>% select(everything(), -gender, -region, -highest_education, -imd_band, -age_band)


# confirm the columns have been removed
colnames(student_Info)


# create report for the new student information data set without the demographic data
create_report(student_Info, output_file = "modifiedStudentInfo.html")


# create report for the courses data set
create_report(courses, output_file = "courses.html")


# create report for the student registration data set
create_report(student_Reg, output_file = "studentRegistration.html")


# create report for the assessments data set
create_report(assessments, output_file = "assessments.html")


# create report for the assessments data set
create_report(student_Assessment, output_file = "studentAssessment.html")


# create report for the assessments data set
# without principal component analysis (due to error in its compilation)
create_report(student_Vle, output_file = "studentVle.html", config = configure_report(add_plot_prcomp = FALSE))


# create report for the assessments data set
create_report(vle, output_file = "vle.html")


# create report for the newly created student data set
create_report(student_data, output_file = "studentData.html")







####################################################################################################
#####   ERROR   #####

# create report for the assessments data set 
# with PCA
#create_report(student_Vle, output_file = "studentVle2.html")

#Error message from computation of PCA for studentVle
#Quitting from lines 205-218 (report.rmd) 
#Error in `[.data.table`(data.table(pca$rotation), , seq.int(nrow(pc_var2)),  : 
#Item 1 of j is 1 which is outside the column number range [1,ncol=0]
