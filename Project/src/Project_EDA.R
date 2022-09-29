##########################################################
# Author: Chinomnso Ekwedike
# Date: 23/03/2022
# Module: Group Project - CSC8633
# Version: 1.0
##########################################################


library('ProjectTemplate')
load.project()


# load libraries
# suppress the package start up messages
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(ggvis))
suppressPackageStartupMessages(library(treemapify))
suppressPackageStartupMessages(library(plotrix))
suppressPackageStartupMessages(library(patchwork))
suppressPackageStartupMessages(library(knitr))
suppressPackageStartupMessages(library(psych))
suppressPackageStartupMessages(library(plyr))
suppressPackageStartupMessages(library(DataExplorer))



# load the data sets
s_info = read_csv("data/studentInfo.csv", show_col_types = FALSE)

courses = read_csv("data/courses.csv", show_col_types = FALSE)

student_Reg = read_csv("data/studentRegistration.csv", show_col_types = FALSE)

assessments = read_csv("data/assessments.csv", show_col_types = FALSE)

student_Assessment = read_csv("data/studentAssessment.csv", show_col_types = FALSE)

student_Vle = read_csv("data/studentVle.csv", show_col_types = FALSE)

vle = read_csv("data/vle.csv", show_col_types = FALSE)





##################################################################################
#####   Student Information EDA   #####

# summarise the data set
summary(s_info)

# structure of the data set
str(s_info)

# check the column names of the data set
colnames(s_info)

# check the dimension of the data set
dim(s_info)

# check for missing rows 
any(is.na(s_info))


# print the first and last few rows of the new_assessments data frame
psych::headTail(s_info, top = 5, bottom = 5, ellipsis = TRUE)


# remove demographic data
student_Info =  s_info %>% select(everything(), -gender, -region, -highest_education, -imd_band, -age_band)

# confirm the removal of the columns
colnames(student_Info)

# print the first and last few rows of the new_assessments data frame
psych::headTail(student_Info, top = 5, bottom = 5, ellipsis = TRUE)

# check the dimension of the data set
dim(student_Info)

# check for missing rows 
any(is.na(student_Info))


# compute the number of unique student ids
unique_ids = plyr::count(unique(student_Info$id_student)) 
total_unique_ids = sum(unique_ids$freq)
total_unique_ids


# find the range of the number of previous attempts
unique_number_prev_attempts = sort(unique(student_Info$num_of_prev_attempts))
unique_number_prev_attempts


# compute the number of students
student_population = nrow(student_Info)
student_population


# compute the number of students with previous attempts and their percentage
prev_attempts_df = data.frame(table(student_Info$num_of_prev_attempts)) %>%
  rename(Num_of_Prev_Attempts = Var1, 
         Num_of_Students = Freq) %>% 
  mutate(Percentage_of_Population = round(100 * Num_of_Students / student_population, 1))
prev_attempts_df


# plot a bar chart showing the different results
prev_attempts_df %>% 
  ggvis(~Num_of_Prev_Attempts, ~Num_of_Students, fill = ~Num_of_Prev_Attempts) %>% 
  layer_bars() %>% 
  add_axis("x", 
           title = "Number of Previous Attempts", 
           properties = axis_props(labels = list(fontSize = 10))) %>% 
  add_axis("y", 
           title = "Number of Students", 
           title_offset = 60)


# find the different number of credits studied by students
unique_credits = sort(unique(student_Info$studied_credits))
unique_credits


# compute number of students per credits
# and their percentage
pop_per_credit = data.frame(table(student_Info$studied_credits)) %>%
        rename(Number_of_Credits = Var1, 
               Number_of_Students = Freq) %>%
        mutate(Percentage_of_Students = round(100 * Number_of_Students / student_population,1))
pop_per_credit


# display the results on a tree map
# this provides an alternative to pie chart
ggplot(pop_per_credit, aes(area = Percentage_of_Students, fill = Number_of_Credits, label = paste(Number_of_Credits, "\n", Number_of_Students, "\n", Percentage_of_Students, "%"))) + 
  geom_treemap() +
  geom_treemap_text(colour = "white",
                    place = "centre",
                    size = 10) + 
  theme(legend.position = "none")


# compute the number of students with disability and their percentage
student_disability = data.frame(table(student_Info$disability)) %>% 
  rename(Disability = Var1, Number_of_Students = Freq) %>%
  mutate(Percentage = round(100 * Number_of_Students/ student_population, 1))
student_disability



# plot a bar chart showing the different results
student_disability %>% 
  ggvis(~Disability, ~Number_of_Students, fill = ~Disability) %>% 
  layer_bars() %>% 
  add_axis("x", 
           title = "Disability", 
           properties = axis_props(labels = list(fontSize = 12))) %>% 
  add_axis("y", 
           title = "Number of Students", 
           title_offset = 60)


# compute the number of students per final result and their percentage
student_final_result = data.frame(table(student_Info$final_result)) %>% 
  rename(Final_Result = Var1, Number_of_Students = Freq) %>%
  mutate(Percentage = round(100 * Number_of_Students/ student_population, 1))
student_final_result


# plot a bar chart showing the different results
student_final_result %>% 
  ggvis(~Final_Result, ~Number_of_Students, fill = ~Final_Result) %>% 
  layer_bars() %>% 
  add_axis("x", 
           title = "Final Result", 
           properties = axis_props(labels = list(fontSize = 12))) %>% 
  add_axis("y", 
           title = "Number of Students", 
           title_offset = 60)


# compute the number of students per final result and their percentage
mode_presentation = data.frame(table(student_Info$code_presentation)) %>% 
  rename(Presentation = Var1, Number_of_Students = Freq) %>%
  mutate(Percentage = round(100 * Number_of_Students/ student_population, 1))
mode_presentation


# plot a bar chart showing the different results
mode_presentation %>% 
  ggvis(~Presentation, ~Number_of_Students, fill = ~Presentation) %>% 
  layer_bars() %>% 
  add_axis("x", 
           title = "Presentation", 
           properties = axis_props(labels = list(fontSize = 12))) %>% 
  add_axis("y", 
           title = "Number of Students", 
           title_offset = 60)



##################################################################################
#####   Student Registration EDA   #####

# summarise the data set
summary(student_Reg)

# structure of the data set
str(student_Reg)

# check the column names of the data set
colnames(student_Reg)

# check the dimension of the data set
dim(student_Reg)

# check for missing rows 
any(is.na(student_Reg))


# print the first and last few rows of the new_assessments data frame
psych::headTail(student_Reg, top = 5, bottom = 5, ellipsis = TRUE)


# compute the number of registered students
registered_students = nrow(student_Reg)
registered_students


# find the different dates of registration 
# convert them to absolute values
# extract the absolute date
absolute_reg_date = student_Reg %>% 
  mutate(new_reg_date = abs(date_registration)) %>%
  select(new_reg_date)
absolute_reg_date


# highest number of days before start date
# remove the missing rows to avoid the max() function returning a NULL value by
# setting the na.rm to TRUE
max(absolute_reg_date, na.rm = TRUE)


# lowest number of days before start date
# remove the missing rows to avoid the min() function returning a NULL value by
# setting the na.rm to TRUE
min(absolute_reg_date, na.rm = TRUE)


# find the different dates of "unregistration"
# extract the dates where students unregistered before the start date
# convert them to absolute values
# extract the absolute date
new_date_absolute_unregistration = student_Reg %>% select(date_unregistration) %>% filter(date_unregistration < 0) %>% mutate(new_unreg_date = abs(date_unregistration)) %>% select(new_unreg_date)

new_date_absolute_unregistration



# highest number of days of "unregistration" before start date
# remove the missing rows to avoid the max() function returning a NULL value by
# setting the na.rm to TRUE
max(new_date_absolute_unregistration, na.rm = TRUE)



# lowest number of days of "unregistration" before start date
# remove the missing rows to avoid the min() function returning a NULL value by
# setting the na.rm to TRUE
min(new_date_absolute_unregistration, na.rm = TRUE)


# extract the date of "unregistration" after the start date
unreg_after_start = student_Reg %>% select(date_unregistration) %>% filter(date_unregistration > 0)

unreg_after_start


# highest number of days of "unregistration" after start date
# remove the missing rows to avoid the max() function returning a NULL value by
# setting the na.rm to TRUE
max(unreg_after_start, na.rm = TRUE)


# lowest number of days of "unregistration" after start date
# remove the missing rows to avoid the min() function returning a NULL value by
# setting the na.rm to TRUE
min(unreg_after_start, na.rm = TRUE)


# extract the date of "unregistration" on the start date
unreg_on_start = student_Reg %>% select(date_unregistration) %>% filter(date_unregistration == 0)
unreg_on_start





##################################################################################
#####   Student Assessment EDA   #####

# summarise the data set
summary(student_Assessment)

# structure of the data set
str(student_Assessment)

# check the column names of the data set
colnames(student_Assessment)

# check the dimension of the data set
dim(student_Assessment)

# check for missing rows 
any(is.na(student_Assessment))


# print the first and last few rows of the new_assessments data frame
psych::headTail(student_Assessment, top = 5, bottom = 5, ellipsis = TRUE)


# compute the number of students whose assessments where recorded
student_assess_population = nrow(student_Assessment)
student_assess_population


# find the unique scores of students
unique_score =  sort(unique(student_Assessment$score))
unique_score


# create a new column for whether the student passed or failed
pass_or_fail = student_Assessment %>%
  mutate(Pass_or_Fail = ifelse(score >= 40, "Pass", "Fail"))


# compute the number of students that passed or failed 
# and their percentage
new_pass_or_fail = data.frame(table(pass_or_fail$Pass_or_Fail)) %>%
  rename(Result = Var1, 
         Num_of_Students = Freq) %>% 
  mutate(Percentage_of_Students = round(100 * Num_of_Students / student_assess_population, 1))

new_pass_or_fail


# plot a bar chart showing the different results
new_pass_or_fail %>% 
  ggvis(~Result, ~Num_of_Students, fill = ~Result) %>% 
  layer_bars() %>% 
  add_axis("x", 
           title = "Result", 
           properties = axis_props(labels = list(fontSize = 10))) %>% 
  add_axis("y", 
           title = "Number of Students", 
           title_offset = 60)


# compute the number of students that have their scores banked
# and their percentage
banked = data.frame(table(student_Assessment$is_banked)) %>%
  rename(Banked = Var1, 
         Num_of_Students = Freq) %>% 
  mutate(Percentage_of_Students = round(100 * Num_of_Students / student_assess_population, 1))

banked


# plot a bar chart showing the different results
banked %>% 
  ggvis(~Banked, ~Num_of_Students, fill = ~Banked) %>% 
  layer_bars() %>% 
  add_axis("x", 
           title = "Banked", 
           properties = axis_props(labels = list(fontSize = 10))) %>% 
  add_axis("y", 
           title = "Number of Students", 
           title_offset = 60)




##################################################################################
#####   Assessment EDA   #####

# summarise the data set
summary(assessments)

# structure of the data set
str(assessments)

# check the column names of the data set
colnames(assessments)

# check the dimension of the data set
dim(assessments)


# check for missing rows 
any(is.na(assessments))


# print the first and last few rows of the new_assessments data frame
psych::headTail(assessments, top = 5, bottom = 5, ellipsis = TRUE)


#display the types of assessments
assessment_types = sort(unique(assessments$assessment_type))
assessment_types


# extract the unique weights of the assessments
assessment_weights = sort(unique(assessments$weight))
assessment_weights

# compute the average weight of each type of assessment
average_assessment_weight = assessments %>% 
  select(assessment_type, weight) %>%
  group_by(assessment_type) %>%
  summarise(Average_Assessment_Weight = round(mean(weight)))

average_assessment_weight


# display the result on a bar chart
average_assessment_weight %>% 
  ggvis(~assessment_type, ~Average_Assessment_Weight, fill = ~assessment_type) %>% 
  layer_bars() %>% 
  add_axis("x", title = "Type of Assessment")




##################################################################################
#####   Student VLE EDA   #####

# summarise the data set
summary(student_Vle)

# structure of the data set
str(student_Vle)

# check the column names of the data set
colnames(student_Vle)

# check the dimension of the data set
dim(student_Vle)


# check for missing rows 
any(is.na(student_Vle))


# print the first and last few rows of the new_assessments data frame
psych::headTail(student_Vle, top = 5, bottom = 5, ellipsis = TRUE)


# compute number of clicks
total_clicks = sum(student_Vle$sum_click)
total_clicks


# compute the total number of clicks per module
total_clicks_per_module = student_Vle %>% 
  select(code_module, sum_click) %>% 
  group_by(code_module) %>% 
  summarise(sum_of_clicks = sum(sum_click))

total_clicks_per_module


# plot a bar chart showing the different results
total_clicks_per_module %>% 
  ggvis(~code_module, ~sum_of_clicks, fill = ~code_module) %>% 
  layer_bars() %>% 
  add_axis("x", 
           title = "Module Code", 
           title_offset = 50, 
           tick_padding = 3, 
           properties = axis_props(labels = list(angle = -70, align = "right", fontSize = 10))) %>% 
  add_axis("y", 
           title = "Total Number of Clicks per Module", 
           title_offset = 80)


# compute total number of clicks for Social Sciences
ss_clicks =  total_clicks_per_module %>% 
        select(everything()) %>% 
        filter(code_module == "AAA" | code_module == "BBB" | code_module == "GGG") %>% 
        summarise(Total_Clicks_for_Social_Sciences = sum(sum_of_clicks))

ss_clicks


# compute total number of clicks for STEM
stem_clicks =  total_clicks_per_module %>% 
      select(everything()) %>% 
      filter(code_module == "CCC" | code_module == "DDD" | code_module == "EEE" | code_module == "FFF") %>% 
      summarise(Total_Clicks_for_STEM = sum(sum_of_clicks))

stem_clicks


# compute total number of clicks for STEM
stem_clicks =  total_clicks_per_module %>% 
  select(everything()) %>% 
  filter(code_module == "CCC" | code_module == "DDD" | code_module == "EEE" | code_module == "FFF") %>% 
  summarise(Total_Clicks_for_STEM = sum(sum_of_clicks))

stem_clicks


# compute the percentage of student engagement within each course
# percentage Social Science
ss_percent = round(100 * ss_clicks$Total_Clicks_for_Social_Sciences / total_clicks)
ss_percent


# percentage STEM
stem_percent = round(100 * stem_clicks$Total_Clicks_for_STEM / total_clicks)
stem_percent


# create a data frame for the percentages
Courses = c("Social Sciences", "STEM")
Total_Clicks = c(ss_clicks$Total_Clicks_for_Social_Sciences, stem_clicks$Total_Clicks_for_STEM)
Percentage_of_Clicks = c(ss_percent, stem_percent)

clicks_df = data.frame(Courses, Total_Clicks, Percentage_of_Clicks)
clicks_df


# plot a bar chart showing the different results
clicks_df %>% 
  ggvis(~Courses, ~Percentage_of_Clicks, fill = ~Courses) %>% 
  layer_bars() %>% 
  add_axis("x", 
           title = "Courses", 
           properties = axis_props(labels = list(fontSize = 10))) %>% 
  add_axis("y", 
           title = "Percentage of Total Clicks")





##################################################################################
#####   VLE EDA   #####

# summarise the data set
summary(vle)

# structure of the data set
str(vle)

# check the column names of the data set
colnames(vle)

# check the dimension of the data set
dim(vle)


# check for missing rows 
any(is.na(vle))


# print the first and last few rows of the new_assessments data frame
psych::headTail(vle, top = 5, bottom = 5, ellipsis = TRUE)


# get the distinct types of activities 
# sort them alphabetically
# display the sorted activity
sorted_activity = sort(unique(vle$activity_type))
sorted_activity


# compute the length
length(sorted_activity)


# display the number of student engagement (clicks) for each activity
act_clicks = table(vle$activity_type)
act_clicks


# convert to a data frame
# rename the columns
activity_engagement = data.frame(act_clicks) %>% rename(Activity_Type = Var1, Number_of_Clicks = Freq)


# display student engagement with activity on a graph
activity_engagement %>% ggvis(~Activity_Type, ~Number_of_Clicks, fill = ~Activity_Type) %>% 
  layer_bars() %>% 
  add_axis("x", title = "Type of Activity", 
           title_offset = 80, 
           tick_padding = 3, 
           properties = axis_props(labels = list(angle = -70, align = "right", fontSize = 10))) %>% 
  add_axis("y", 
           title = "Student Engagement based on Number of Clicks", 
           title_offset = 50)




##################################################################################
#####   Courses EDA   #####

# summarise the data set
summary(courses)

# structure of the data set
str(courses)

# check the column names of the data set
colnames(courses)

# check the dimension of the data set
dim(courses)


# check for missing rows 
any(is.na(courses))

# longest module presentation length
max(courses$module_presentation_length)


# shortest module presentation length
min(courses$module_presentation_length)


# compute average length of each module
all_modules = courses %>% select(code_module, module_presentation_length) %>% 
                group_by(code_module) %>% 
                summarise(Average_Module_Length = round(mean(module_presentation_length)))

# display the data frame
all_modules

# display on a bar chart
# plot a bar chart showing the different results
all_modules %>% 
  ggvis(~code_module, ~Average_Module_Length, fill = ~code_module) %>% 
  layer_bars()


# Average module presentation length for Social Sciences
ss_mod_length = all_modules %>% 
          select(everything()) %>% 
          filter(code_module == "AAA" | code_module == "BBB" | code_module == "GGG")

# compute the average
round(mean(ss_mod_length$Average_Module_Length))


# Average module presentation length for STEM
stem_mod_length = all_modules %>% 
            select(everything()) %>% 
            filter(code_module == "CCC" | code_module == "DDD" | code_module == "EEE" | code_module == "FFF")

# compute the average
round(mean(stem_mod_length$Average_Module_Length))


# compute the average presentation length of all the modules and their presentation
# create a new column to combine the code_module and code_presentation
# group them by the new column
# compute the average presentation length within each group
all_module_presentation = courses %>% select(everything()) %>% 
  mutate(module_presentation = paste(code_module, code_presentation, sep = "-")) %>%
  group_by(module_presentation) %>% 
  summarise(Average_Module_Length = round(mean(module_presentation_length)))


# plot a bar chart showing the different results
all_module_presentation %>% 
  ggvis(~module_presentation, ~Average_Module_Length, fill = ~module_presentation) %>% 
  layer_bars() %>% 
  add_axis("x", 
           title = "Module Code and Presentation", 
           title_offset = 80, tick_padding = 3, 
           properties = axis_props(labels = list(angle = -70, align = "right", fontSize = 10))) %>% 
  add_axis("y", 
           title = "Module Presentation Length", 
           title_offset = 50)




########################################################################################################
########################################################################################################
#####   CREATE DATA PROFILING REPORT FOR ALL THE DATA SETS    #####


# Run the codes below only if you want to generate the data profiling report using the `DataExplorer`
# package. The output will be an automatically generated HTML file with the name specified in the 
# `output_file` parameter once the corresponding code is executed.


# create report for the new student information data set without the demographic data
create_report(student_Info, output_file = "modifiedstudentInfo.html")


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









####################################################################################################
#####   ERROR   #####

# This error message was encountered during the creation of data profiling report 
# for Student VLE data set. So the only possible solution was to exclude the 
# Principal Component Analysis  computation and component from the process profiling
# process


# create report for the assessments data set 
# with PCA
#create_report(student_Vle, output_file = "studentVle2.html")

#Error message from computation of PCA for studentVle
#Quitting from lines 205-218 (report.rmd) 
#Error in `[.data.table`(data.table(pca$rotation), , seq.int(nrow(pc_var2)),  : 
#Item 1 of j is 1 which is outside the column number range [1,ncol=0]