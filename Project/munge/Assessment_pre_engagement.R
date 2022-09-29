#lead up to engagement stats
#REMOVE ANY LIBRARY CALLS AND PUT THEM INTO CONFIG
#library(dplyr)
#library(hash)
#read in student assessment results
student_res<-read.csv("data/studentAssessment.csv")
#removed students using banked results
student_res<-student_res %>% filter(is_banked==0)
#get assessments file
assessments_file<-read.csv("data/assessments.csv")
assessments_file <- assessments_file %>% select(id_assessment, assessment_type)
student_res<-left_join(student_res, assessments_file, by=c("id_assessment"))%>%
  
  filter(assessment_type=="Exam")%>%
  select(id_student, id_assessment, date_submitted, score)

#read in studentVle info
student_vle<-read.csv("data/studentVle.csv")
#add a week before column
student_res<-mutate(student_res, week_before=date_submitted-7)
#select only these columns
student_res<-select(student_res, id_student, week_before, score, id_assessment)
#empty vectors initialised
days<-vector()
sums<-vector()
score<-vector()
student_id_vec<-vector()
assessment_vec<-vector()
#for loop
for (ii in seq(1, nrow(student_res))){
  #for back compatibility reasons we add this line here
  i<-student_res$id_student[ii]
  #just the student id we are interested in
  temp<-filter(student_vle, id_student==i)
  #again but for student results
  temp2<-filter(student_res, id_student==i)
  #for loop again
  for (j in seq(1,nrow(temp2))){
    #get the week before the exam
    week_num<-temp2[j,]$week_before
    #get the exam date
    week_num_seven<-week_num+7
    #get the assessement id
    assessment_name<-temp2[j,]$id_assessment
    #get the score for that student
    score_recorded<-temp2[j,]$score
    #Only look at engagement a week before the exam
    temp3<-filter(temp, date>week_num & date<=week_num_seven)
    #the number of unique days the student engaged
    days<-append(days,length(unique(temp3$date)))
    #the total number of clicks in that period
    sums<-append(sums,sum(temp3$sum_click))
    #the score that student got
    score<-append(score, score_recorded)
    #append the student id
    student_id_vec<-append(student_id_vec, i)
    #append the assessment id
    assessment_vec<-append(assessment_vec, assessment_name)
  }
}
#make a dataframe 
engagement_exam<-data.frame(student_id_vec,assessment_vec,days, sums, score)
#remove duplicate rows
engagement_exam<-unique(engagement_exam)
#write to csv
write.csv(engagement_exam,"data/engagement_before_exam.csv")
engagement_exam<-read.csv("data/engagement_before_exam.csv")
