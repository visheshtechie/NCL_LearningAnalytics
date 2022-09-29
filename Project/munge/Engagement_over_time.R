library(dplyr)
library(ggplot2)

vle <- read.csv("data/vle.csv")
studentVle <- read.csv("data/studentVle.csv")
Student_data_1 <- read.csv("data/Student_data_1.csv")

# First we need to join the student vl and vle dataset by id site 


# THIS IS THE IMPORTANT PART 
join_by_id_site = left_join(studentVle, vle[,c("id_site", "activity_type")], by = "id_site")
join_by_id_site = join_by_id_site[, -7]
View(join_by_id_site)

write.csv(join_by_id_site, file = "C:/Users/irrro/OneDrive/Documents/Documents/iro/uni/group_project/git_rep/Project/data\\Engagement_over_time_data.csv")

# Engagement vs credits  (if # of clicks goes down with # of credits )

studentInfo <- read.csv("data/studentInfo.csv")

studentInfo = studentInfo[, c("id_student", "studied_credits")]

# join the credits studied with each student 
credits_and_clicks = left_join(Student_data_1, studentInfo, by = "id_student")

View(credits_and_clicks)


# Group by students in each module and caluclate the number of credits and then take the SUM number of clicks 

mean_num_clicks_per_credits = credits_and_clicks %>% group_by(id_student, code_module, code_presentation, pres_specific) %>% summarise(mean_num_clicks = mean(total_clicks), studied_credits=sum(studied_credits))

mean_num_clicks_per_credits <- mutate(mean_num_clicks_per_credits, id_pres=paste(id_student, code_presentation, code_module, sep="-"))

#Removed A LINE
#plot(mean_num_clicks_per_credits$studied_credits, mean_num_clicks_per_credits$mean_num_clicks)


#ggplot(mean_num_clicks_per_credits, aes(x=studied_credits, y=mean_num_clicks,color=code_module)) +
#  geom_point() + geom_smooth(method=lm, se=FALSE, fullrange=TRUE)

write.csv(mean_num_clicks_per_credits, file = "data/mean_num_clicks_per_credits.csv")

 
# ENGAGEMENT OVER TIME FOR EACH MODULE 

View(Student_data_1)

# find the number of students in each module 
numb_students = Student_data_1 %>% group_by(code_presentation, code_module, pres_specific) %>% summarise(count = length(id_student))
numb_students = numb_students[,c("pres_specific", "count")]

View(numb_students)

student_vle_new = studentVle %>% group_by(code_module, code_presentation, date, id_student) %>% summarise(sum_of_clicks = sum(sum_click))

student_vle_new = mutate(student_vle_new, pres_specific=paste(code_module, code_presentation, sep="-"))

student_vle_new = mutate(student_vle_new, id_pres=paste(id_student, code_presentation, code_module, sep="-"))

student_vle_new = left_join(student_vle_new, numb_students, by = "pres_specific")

# finding the number of clicks per day relative to the number of students on the course 

student_vle_new = mutate(student_vle_new, percentage_sum_clicks = sum_of_clicks/count)

View(student_vle_new)

ggplot(student_vle_new, aes(x=date, y=percentage_sum_clicks,color=code_module)) +
  geom_point() + geom_line()


write.csv(student_vle_new, file = "data/Engagement_per_module_over_time_data.csv")


# SURVIVAL ANALISIS 

library(tidyr)
library(readr)
studentRegistration <- read_csv("data/studentRegistration.csv")



View(studentRegistration)

#for (k in 1:nrow(studentRegistration)){
#  if(studentRegistration$date_registration[k] < 0){
#    studentRegistration$date_registration[k] = 0
#  }
#  else{
#    studentRegistration$date_registration[k] = studentRegistration$date_registration[k]
#  }
#}

studentRegistration = mutate(studentRegistration, time_on_course = abs(date_registration - date_unregistration))

View(studentRegistration)

View(Student_data_1)

# create the survival data set 

Student_data_survival = Student_data_1[, c("id_student","module_presentation_length", "final_result")]
View(Student_data_survival)

# Find the time on the course for each student and if NA replace unresigtration datw with course 
# length 

# first compute the pres specifc column 
studentRegistration = mutate(studentRegistration,pres_specific=paste(code_module, code_presentation, sep="-") )
View(studentRegistration)

# Map this data set with the student data 1 to get the registration and unregistration days
Student_data_2 = Student_data_1[,c("module_presentation_length", "final_result","id_student")]

studentRegistration1 = left_join(studentRegistration,Student_data_2, by = "id_student")
View(studentRegistration1)

# for people that have NA in uregistration date, replece that with the module length 

studentRegistration1$time_on_course_1<-0


for (i in 1:nrow(studentRegistration1)){
  if (is.na(studentRegistration1$date_unregistration[i])){
    studentRegistration1$time_on_course_1[i] = studentRegistration1$module_presentation_length[i]
  }
  else{
    studentRegistration1$time_on_course_1[i] = studentRegistration1$time_on_course[i]
    
  }
}

View(studentRegistration1)

# creating the indicator column 

studentRegistration1$indicator<-0
for (i in 1:nrow(studentRegistration1)){
  if (is.na(studentRegistration1$final_result[i])){
    studentRegistration1$indicator[i] = 1
  }
  else if (studentRegistration1$final_result[i] == "Withdrawn"){
    studentRegistration1$indicator[i] = 1
  }
  else{
    studentRegistration1$indicator[i] = 0
  }
}

View(studentRegistration1)

library(survival)

fit=survfit(Surv(time_on_course_1,indicator)~1,data = studentRegistration1)
summary(fit)
plot(fit,col=6,lwd=1.5)
plot(fit,col=6,lwd=1.5, conf.int = TRUE, lty = 1, xlab = "Time in Days", ylab = "Survival", 
     main = "Kaplan-Meier estimate of students survival on the courses with 95% confidence interval", cex.main = 1)
