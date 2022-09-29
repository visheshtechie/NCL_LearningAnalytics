##########################################################
# Author: Chinomnso Ekwedike
# Date: 17/03/2022
# Module: Group Project - CSC8633
# Version: 1.0
##########################################################


library('ProjectTemplate')
load.project()


# load libraries
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(ggvis))
suppressPackageStartupMessages(library(plotrix))
suppressPackageStartupMessages(library(patchwork))
suppressPackageStartupMessages(library(knitr))



# load the different data sets
# load the student information data set
s_info = read_csv("data/studentInfo.csv", show_col_types = FALSE)

# load the courses data set
courses = read_csv("data/courses.csv", show_col_types = FALSE)

# load the student registration data set
student_Reg = read_csv("data/studentRegistration.csv", show_col_types = FALSE)

# load the assessments data set
assessments = read_csv("data/assessments.csv", show_col_types = FALSE)

# load the student assessment data set
student_Assessment = read_csv("data/studentAssessment.csv", show_col_types = FALSE)

# load the student VLE data set
student_Vle = read_csv("data/studentVle.csv", show_col_types = FALSE)

# load the VLE data set
vle = read_csv("data/vle.csv", show_col_types = FALSE)



##############################################################################################
### EXploratory Data Analysis

# create a list of the tables 
Datasets = c("Student_Info", "Courses", "Student_Reg", "Assessments", "Student_Assess", "Student_Vle", "Vle")

# create a list containing the number of rows contained in each table
Rows = c(nrow(s_info), nrow(courses), nrow(student_Reg), nrow(assessments), nrow(student_Assessment), nrow(student_Vle), nrow(vle))

# create a list containing the number of columns contained in each table
Columns = c(ncol(s_info), ncol(courses), ncol(student_Reg), ncol(assessments), ncol(student_Assessment), ncol(student_Vle), ncol(vle))

# create a list for missing rows/observations
Missing_rows = c(any(is.na(s_info)), any(is.na(courses)), any(is.na(student_Reg)), any(is.na(assessments)), any(is.na(student_Assessment)), any(is.na(student_Vle)), any(is.na(vle)))

# create a data frame containing the lists of values
df =  data.frame(Datasets, Rows, Columns, Missing_rows)

# display the data frame as a Knitr table
kable(df, caption = "Summary of Data Set Dimensions")




# print the first few rows of the student information data set
kable(head(s_info, 5))

# print the first few rows of the courses data set
kable(head(courses, 5))

# print the first few rows of the student information data set
kable(head(student_Reg, 5))

# print the first few rows of the student information data set
kable(head(assessments, 5))

# print the first few rows of the student information data set
kable(head(student_Assessment, 5))

# print the first few rows of the student information data set
kable(head(student_Vle, 5))

# print the first few rows of the student information data set
kable(head(vle, 5))



################################################################################
## Data Preparation

# remove the columns containing the demographic data from the student information data 
# set as they are out of scope for this project
student_Info =  s_info %>% select(everything(), -gender, -region, -highest_education, -imd_band, -age_band)



# remove any missing rows from the student information data set
st_inf = na.omit(student_Info)

# remove any missing rows from the courses data set
course = na.omit(courses)

# remove any missing rows from the student registration data set
st_reg = na.omit(student_Reg)

# remove any missing rows from the assessments data set
assess = na.omit(assessments)

# remove any missing rows from the student assessment data set
st_ass = na.omit(student_Assessment)

# remove any missing rows from the student VLE data set
st_vle = na.omit(student_Vle)

# remove any missing rows from the VLE data set
v_le = na.omit(vle)



# create a list containing the number of rows contained in each table
New_Rows = c(nrow(st_inf), nrow(course), nrow(st_reg), nrow(assess), nrow(st_ass), nrow(st_vle), nrow(v_le))

# create a list containing the number of columns contained in each table
New_Columns = c(ncol(st_inf), ncol(course), ncol(st_reg), ncol(assess), ncol(st_ass), ncol(st_vle), ncol(v_le))

# create a list for missing rows/observations
New_Missing_Rows = c(any(is.na(st_inf)), any(is.na(course)), any(is.na(st_reg)), any(is.na(assess)), any(is.na(st_ass)), any(is.na(st_vle)), any(is.na(v_le)))

# create a data frame containing the lists of values
new_df =  data.frame(Datasets, New_Rows, New_Columns, New_Missing_Rows)

# display the data frame as a Knitr table
kable(new_df, caption = "New Summary of Data Set Dimensions after Data Preparation")



# print the first few rows of the new student information data
# to confirm the removal of demographic data
kable(head(st_inf))



################################################################################

## DATA ANALYSIS SECTION

#########################
## Social Sciences vs STEM

# count the total number of students, equivalent to the number of rows
student_total = st_inf %>% count()
student_total$n

# compute the number of students in each category of the final result
student_result_number = table(st_inf$final_result)
student_result_number

# compute the percentage 
total_result_percentage = round(prop.table(table(st_inf$final_result)) * 100, 1)
cbind(Results = table(st_inf$final_result), Percentage = total_result_percentage)

# display the proportions on a pie chart
pie3D(student_result_number, labels = total_result_percentage, explode = 0.1, main = "Student Information Final Result Distribution", col = rainbow(4))
legend("topleft", c("Distinction", "Fail", "Pass", "Withdrawn"), cex = 0.8, fill = rainbow(4))

# plot a bar chart showing the different results
st_inf %>% ggvis(~final_result, fill = ~final_result) %>% layer_bars()


# select the rows with the social sciences module codes
social_sciences = st_inf %>% select(everything()) %>% filter(code_module == "AAA" | code_module == "BBB" | code_module == "GGG")

# compute the number of social science students
ss_count = social_sciences %>% count()
ss_count$n

# compute the percentage of social science students
ss_percent = round((ss_count$n / student_total$n) * 100, 1)
paste(ss_percent,"%")

# compute the number of students in each category of the final result
result = table(social_sciences$final_result)
result

# compute the percentage of students in each category of final result
soc_sci_perc = round(prop.table(table(social_sciences$final_result)) * 100, 1)
cbind(Results = table(social_sciences$final_result), Percentage = soc_sci_perc)


# display the proportions on a pie chart
pie3D(result, labels = soc_sci_perc, explode = 0.1, main = "Social Sciences Final Result Distribution", col = rainbow(4))
legend("topleft", c("Distinction", "Fail", "Pass", "Withdrawn"), cex = 0.8, fill = rainbow(4))


# plot a bar chart showing the different results
social_sciences %>% ggvis(~final_result, fill = ~final_result) %>% layer_bars()



## STEM
# extract data for the STEM students
stem = st_inf %>% select(everything()) %>% filter(code_module == "CCC" | code_module == "DDD" | code_module == "EEE" | code_module == "FFF")

# compute the total number of students in STEM
stem_count = stem %>% count()
stem_count$n

# compute the percentage
stem_percent = round((stem_count$n / student_total$n) * 100, 1)
paste(stem_percent,"%")

# compute the number of STEM students in each category of final result
stem_result = table(stem$final_result)
stem_result

# compute their percentage
stem_std_perc = round(prop.table(table(stem$final_result)) * 100, 1)
cbind(Results = table(stem$final_result), Percentage = stem_std_perc)

# display the proportions on a pie chart
pie3D(stem_result, labels = stem_std_perc, explode = 0.1, main = "Stem Final Result Distribution", col = rainbow(4))
legend("topleft", c("Distinction", "Fail", "Pass", "Withdrawn"), cex = 0.8, fill = rainbow(4))

# plot a bar chart showing the different results
stem %>% ggvis(~final_result, fill = ~final_result) %>% layer_bars()


# Create a table of summary of the findings
Modules = c("Full_Data", "Social_Sciences", "Stem")                       
Distinction = c(3024, 1117, 1907)
Fail = c(7052, 2586, 4466)
Pass = c(12361, 4682, 7679)
Withdrawn = c(10156, 2806, 7350)                      
Total = c(student_total$n, ss_count$n, stem_count$n)
Percentage_of_Total = c(100.0, 34.3, 65.7)
sum_df = data.frame(Modules, Distinction, Fail, Pass, Withdrawn, Total, Percentage_of_Total)
kable(sum_df)



################################################################################
##### B.    Social Sciences vs STEM Based on Months

# compute the number of students in each month/year presentation
full_months = table(st_inf$code_presentation)
full_months

# percentage of students in each presentation
present_perc = round(prop.table(table(st_inf$code_presentation)) * 100, 1)
cbind(Presentation = table(st_inf$code_presentation), Percentage = present_perc)

# display the proportions on a pie chart
#pie(result, col = rainbow(4))
pie3D(full_months, labels = present_perc, explode = 0.1, main = "Full Presentations Distribution", col = rainbow(4))
legend("topright", c("2013B", "2013J", "2014B", "2014J"), cex = 0.8, fill = rainbow(4))


# plot a bar chart showing the different results
st_inf %>% ggvis(~code_presentation, fill = ~code_presentation) %>% layer_bars()


# compute the number of social science student in each presentation
ss_months = table(social_sciences$code_presentation)
ss_months

# compute their percentage
total_ss_percentage = round(prop.table(table(social_sciences$code_presentation)) * 100, 1)
cbind(Presentation = table(social_sciences$code_presentation), Percentage = total_ss_percentage)


# display the proportions on a pie chart
#pie(result, col = rainbow(4))
pie3D(ss_months, labels = total_ss_percentage, explode = 0.1, main = "Presentations Distribution for Social Sciences", col = rainbow(4))
legend("topright", c("2013B", "2013J", "2014B", "2014J"), cex = 0.8, fill = rainbow(4))


# plot a bar chart showing the different results
social_sciences %>% ggvis(~code_presentation, fill = ~code_presentation) %>% layer_bars()

##############################################
## Analyse each presentation

##### Social Sciences
##### February 2013

# extract and compute the number of social science students in Feb 2013 
feb_2013 =  social_sciences %>% select(everything()) %>% filter(code_presentation == "2013B")
ss_2013B = table(feb_2013$final_result)
ss_2013B

# compute their percentage
result_2013_percentage = round(prop.table(table(feb_2013$final_result)) * 100, 1)
cbind(Presentation = table(feb_2013$final_result), Percentage = result_2013_percentage)

# display the proportions on a pie chart
pie3D(ss_2013B, labels = result_2013_percentage, explode = 0.1, main = "February 2013 Social Sciences Final Result Distribution", col = rainbow(4))
legend("topright", c("Distinction", "Fail", "Pass", "Withdrawn"), cex = 0.8, fill = rainbow(4))


# plot a bar chart showing the different results
feb_2013 %>% ggvis(~final_result, fill = ~final_result) %>% layer_bars()


##### October 2013
# extract and compute the number of students in the October 2013
oct_2013 =  social_sciences %>% select(everything()) %>% filter(code_presentation == "2013J")
count_2013J = table(oct_2013$final_result)
count_2013J

# compute their percentage
result_2013J_percentage = round(prop.table(table(oct_2013$final_result)) * 100, 1)
cbind(Presentation = table(oct_2013$final_result), Percentage = result_2013J_percentage)

# display the proportions on a pie chart
pie3D(count_2013J, labels = result_2013J_percentage, explode = 0.1, main = "October 2013 Social Sciences Final Result Distribution", col = rainbow(4))
legend("topleft", c("Distinction", "Fail", "Pass", "Withdrawn"), cex = 0.8, fill = rainbow(4))


# plot a bar chart showing the different results
oct_2013 %>% ggvis(~final_result, fill = ~final_result) %>% layer_bars()



##### February 2014
# extract and compute the number of students in February 2014
feb_2014 =  social_sciences %>% select(everything()) %>% filter(code_presentation == "2014B")
ss_2014B = table(feb_2014$final_result)
ss_2014B

# compute their percentage
total_2014B_percentage = round(prop.table(table(feb_2014$final_result)) * 100, 1)
cbind(Presentation = table(feb_2014$final_result), Percentage = total_2014B_percentage)

# display the proportions on a pie chart
pie3D(ss_2014B, labels = total_2014B_percentage, explode = 0.1, main = "February 2014 Social Sciences Final Result Distribution", col = rainbow(4))
legend("topright", c("Distinction", "Fail", "Pass", "Withdrawn"), cex = 0.8, fill = rainbow(4))

# plot a bar chart showing the different results
feb_2014 %>% ggvis(~final_result, fill = ~final_result) %>% layer_bars()



##### October 2014
# compute and extract the number of students in October 2014
oct_2014 =  social_sciences %>% select(everything()) %>% filter(code_presentation == "2014J")
ss_2014J_count = table(oct_2014$final_result)
ss_2014J_count

# compute their percentage
total_2014J_percentage_ss = round(prop.table(table(oct_2014$final_result)) * 100, 1)
cbind(Presentation = table(oct_2014$final_result), Percentage = total_2014J_percentage_ss)

# display the proportions on a pie chart
pie3D(ss_2014J_count, labels = total_2014J_percentage_ss, explode = 0.1, main = "October 2014 Social Sciences Final Result Distribution", col = rainbow(4))
legend("topleft", c("Distinction", "Fail", "Pass", "Withdrawn"), cex = 0.8, fill = rainbow(4))

# plot a bar chart showing the different results
oct_2014 %>% ggvis(~final_result, fill = ~final_result) %>% layer_bars()
#################################################################################


################################################################################
##### STEM

# extract and compute the number of STEM students in February 2013
stem_months = table(stem$code_presentation)
stem_months

# compute their percentage
total_stem_percentage = round(prop.table(table(stem$code_presentation)) * 100, 1)
cbind(Presentation = table(stem$code_presentation), Percentage = total_stem_percentage)

# display the proportions on a pie chart
pie3D(stem_months, labels = total_stem_percentage, explode = 0.1, main = "Presentations Distribution for STEM", col = rainbow(4))
legend("topright", c("2013B", "2013J", "2014B", "2014J"), cex = 0.8, fill = rainbow(4))

# plot a bar chart showing the different results
stem %>% ggvis(~code_presentation, fill = ~code_presentation) %>% layer_bars()


####### Analyse individual presentation
###### February 2013
# extract and compute the number of students in February 2013

# compute their percentage
feb_2013_stem =  stem %>% select(everything()) %>% filter(code_presentation == "2013B")
feb_stem_13 = table(feb_2013_stem$final_result)
feb_stem_13

# compute their percentage
total_result2013B_perc = round(prop.table(table(feb_2013_stem$final_result)) * 100, 1)
cbind(Presentation = table(feb_2013_stem$final_result), Percentage = total_result2013B_perc)

# display the proportions on a pie chart
pie3D(feb_stem_13, labels = total_result2013B_perc, explode = 0.1, main = "February 2013 Stem Final Result Distribution", col = rainbow(4))
legend("topleft", c("Distinction", "Fail", "Pass", "Withdrawn"), cex = 0.8, fill = rainbow(4))

# plot a bar chart showing the different results
feb_2013_stem %>% ggvis(~final_result, fill = ~final_result) %>% layer_bars()


###### October 2013
# extract and compute the number of students in October 2013
oct_2013_stem =  stem %>% select(everything()) %>% filter(code_presentation == "2013J")
stem_2013J = table(oct_2013_stem$final_result)
stem_2013J

# compute their percentage
total_stem2013J_perc = round(prop.table(table(oct_2013_stem$final_result)) * 100, 1)
cbind(Presentation = table(oct_2013_stem$final_result), Percentage = total_stem2013J_perc)

# display the proportions on a pie chart
pie3D(stem_2013J, labels = total_stem2013J_perc, explode = 0.1, main = "October 2013 Stem Final Result Distribution", col = rainbow(4))
legend("topleft", c("Distinction", "Fail", "Pass", "Withdrawn"), cex = 0.8, fill = rainbow(4))

# plot a bar chart showing the different results
oct_2013_stem %>% ggvis(~final_result, fill = ~final_result) %>% layer_bars()


###### February 2014
# extract and compute the number of students in February 2014
feb_2014_stem =  stem %>% select(everything()) %>% filter(code_presentation == "2014B")
stem_2014B = table(feb_2014_stem$final_result)
stem_2014B

# compute their percentage
total_stem2014B_perc = round(prop.table(table(feb_2014_stem$final_result)) * 100, 1)
cbind(Presentation = table(feb_2014_stem$final_result), Percentage = total_stem2014B_perc)

# display the proportions on a pie chart
pie3D(stem_2014B, labels = total_stem2014B_perc, explode = 0.1, main = "February 2014 Stem Final Result Distribution", col = rainbow(4))
legend("topleft", c("Distinction", "Fail", "Pass", "Withdrawn"), cex = 0.8, fill = rainbow(4))

# plot a bar chart showing the different results
feb_2014_stem %>% ggvis(~final_result, fill = ~final_result) %>% layer_bars()


###### October 2014
# extract and compute the number of students in October 2014
oct_2014_stem =  stem %>% select(everything()) %>% filter(code_presentation == "2014J")
stem_2014J = table(oct_2014_stem$final_result)
stem_2014J

# compute their percentage
total_stem2014J_perc = round(prop.table(table(oct_2014_stem$final_result)) * 100, 1)
cbind(Presentation = table(oct_2014_stem$final_result), Percentage = total_stem2014J_perc)

# display the proportions on a pie chart
pie3D(stem_2014J, labels = total_stem2014J_perc, explode = 0.1, main = "October 2014 Stem Final Result Distribution", col = rainbow(4))
legend("topleft", c("Distinction", "Fail", "Pass", "Withdrawn"), cex = 0.8, fill = rainbow(4))

# plot a bar chart showing the different results
oct_2014_stem %>% ggvis(~final_result, fill = ~final_result) %>% layer_bars()


## summarise the analysis for both social sciences and stem
SS_Month_Yr = c("February-2013", "October-2013", "February-2014", "October-2014")
Id = c("2013B",  "2013J",  "2014B", "2014J")
SS_Distiction = c(155, 337, 294, 331)
SS_Fail = c(459, 860, 651, 616)
SS_Pass = c(648, 1650, 911, 1518)
SS_Withdrawn = c(505, 770, 590, 941)
Stem_Distinction = c(172, 412, 490, 833)
Stem_Fail = c(782, 1141, 1182, 1361)
Stem_Pass = c(1120, 2121, 1663, 2775)
Stem_Withdrawn = c(843, 1599, 2023, 2885)

# create a data frame containing the lists
month_yr_summary = data.frame(SS_Month_Yr, Id, SS_Distiction, SS_Fail, SS_Pass, SS_Withdrawn, Stem_Distinction, Stem_Fail, Stem_Pass, Stem_Withdrawn)
kable(month_yr_summary, caption = "Summary of the students attainment in each module based on month and year")


## summarise the overall data analysis
Month_Year = c("February-2013", "October-2013", "February-2014", "October-2014")
Id = c("2013B",  "2013J",  "2014B", "2014J")
Full_Data = c(4684, 8845, 7804, 11260)
Social_Sciences = c(1767, 3572, 2446, 3406)
Stem = c(2917, 5273, 5358, 7854)
m_df = data.frame(Month_Year, Id, Full_Data, Social_Sciences, Stem)

# add percentage for each month
months_df = m_df %>% select(everything()) %>% mutate(Soc_Sci_Perc = round((Social_Sciences / Full_Data) * 100, 1), Stem_Perc = round((Stem / Full_Data) * 100, 1))
kable(months_df)



########################################################################################
##### C.    Social Sciences vs Stem based on Average Module Presentation Length

#Compute the average length of the individual modules contained in both the Social Sciences and STEM.
ss_courses = course %>% select(code_module, module_presentation_length) %>% group_by(code_module) %>% summarise(Average_Module_Length = round(mean(module_presentation_length)))
kable(ss_courses, caption = "Average Presentation Length of Each Module")

# plot a bar chart showing the different results
ss_courses %>% ggvis(~code_module, ~Average_Module_Length, fill = ~code_module) %>% layer_bars()


### Compute the average length of the module for Social Sciences
ss_mod_length = ss_courses %>% select(everything()) %>% filter(code_module == "AAA" | code_module == "BBB" | code_module == "GGG")

# compute the average
round(mean(ss_mod_length$Average_Module_Length))



### Compute the average length of the module for STEM
stem_mod_length = ss_courses %>% select(everything()) %>% filter(code_module == "CCC" | code_module == "DDD" | code_module == "EEE" | code_module == "FFF")

# compute the average
round(mean(stem_mod_length$Average_Module_Length))


# Compute the average module presentation length of the Social Sciences 
#based on the individual models and the code presentation (months and years).
ss_cours = course %>% select(everything()) %>% group_by(code_module, code_presentation) %>% summarise(Average_Module_Length = round(mean(module_presentation_length)))
kable(ss_cours, caption = "Average Presentation Length of Each Module")



################################################################################

#### __D.   Social Sciences vs Stem Based on Student VLE__
#Group the student VLE data by the module codes and add up the number of clicks for each module code.
stdt_vle = st_vle %>% select(code_module, sum_click) %>% group_by(code_module) %>% summarise(sum_of_clicks = sum(sum_click))

# display the table containing the aggregate data
kable(stdt_vle, caption = "Aggregate of the Modules and the sum of clicks for each module")


# plot a bar chart showing the different results
stdt_vle %>% ggvis(~code_module, ~sum_of_clicks, fill = ~code_module) %>% layer_bars()



#### Compute the total number of clicks for Social Sciences
ss_clicks =  stdt_vle %>% select(everything()) %>% filter(code_module == "AAA" | code_module == "BBB" | code_module == "GGG") %>% summarise(Total_Clicks_for_Social_Sciences = sum(sum_of_clicks))
kable(ss_clicks)

# Compute the total number of clicks for STEM
stem_clicks =  stdt_vle %>% select(everything()) %>% filter(code_module == "CCC" | code_module == "DDD" | code_module == "EEE" | code_module == "FFF") %>% summarise(Total_Clicks_for_STEM = sum(sum_of_clicks))
kable(stem_clicks)





