#library(dplyr)

#Remember to remove the above

student_vle_1<-read.csv("data/studentVle.csv")

student_vle_1 = student_vle_1[c("code_module","code_presentation","id_student","date", "sum_click")]

gc()
#head(student_vle_1)
#group by student id and code presentation which is pasted together
df <- student_vle_1 %>% group_by(id_pres=paste(id_student, code_presentation,code_module, sep="-")) %>% summarise(total_clicks = sum(sum_click))


#unpaste the code presentation and student id 
hold<-sapply(df$id_pres, function(x){strsplit(x, "-")})
#set up empty vectors 
student_ids<-vector()
code_pres<-vector()
module_code<-vector()

#for loop
for (i in hold){
  #add the student ids to this vector
  student_ids<-append(student_ids,i[1])
  #add the presentation code to the other vector
  code_pres<-append(code_pres,i[2])
  #add the presentation code to the other vector
  module_code<-append(module_code, i[3])
  }

#add the vectors into the data frame
df$id_student<-as.numeric(student_ids)
df$code_presentation<-code_pres
df$code_module<-module_code

#create a module and presentation specific code
df$pres_specific<-paste(df$code_module,df$code_presentation, sep="-")

#read in the courses dataset
course_key<-read.csv("data/courses.csv")

#create a module and presentation specific code
course_key$pres_specific<- paste(course_key$code_module,course_key$code_presentation, sep="-")

#join to df so that we have the module lengths
df<-left_join(df,course_key, by=c("pres_specific"))

#add average number of clicks over length of module presentation
df<-mutate(df, average_click_number_per_day=total_clicks/module_presentation_length)

#Remove redundant columns
df<-df[,!colnames(df) %in% c("code_module.y", "code_presentation.y")]

student_assesment_1<-read.csv("data/studentAssessment.csv")
assessments_1<-read.csv("data/assessments.csv")
student_assesment_1 = student_assesment_1[c("id_assessment","id_student", "score")]


head(student_assesment_1)

head(assessments_1)

student_assesments= left_join(x=assessments_1,y=student_assesment_1,by="id_assessment")

student_assesments_mutated = mutate(student_assesments, id_pres=paste(id_student, code_presentation,code_module, sep="-"))


student_assesments_mutated$score = student_assesments_mutated$score/100

student_assesments_mutated = mutate(student_assesments_mutated, weighted_score = score*weight)

# group by id_pres 

student_assesments_grouped = student_assesments_mutated %>% group_by(id_pres) %>% summarise(sum_score=sum(weighted_score), total_weights=sum(weight))


# complete the df 

complete_df = left_join(df, student_assesments_grouped, by = "id_pres")
View(complete_df)


# Finding the maximum number of marks for each presentation 


assessement_grouped = assessments_1 %>% group_by(code_module,code_presentation) %>% summarise(total = sum(weight))
assessement_grouped

# create a id_pres column 

assessement_grouped_pres_specific = mutate(assessement_grouped, pres_specific=paste(code_module, code_presentation, sep="-"))
view(assessement_grouped_pres_specific)

# join the data sets to match total number of marks for each module 

complete_df_1 = left_join(complete_df, assessement_grouped_pres_specific[,c("total","pres_specific")], by = "pres_specific")

view(complete_df_1)

# First filter our the students that have completed less than 40% of the module 

# create a new column with the percentage of the course completed 

complete_df_2 = mutate(complete_df_1, perc_course_completed = complete_df_1$total_weights/complete_df_1$total)
view(complete_df_2)

complete_df_2 = complete_df_2[complete_df_2$perc_course_completed >= 0.4,]
view(complete_df_2)


# Find the total percent score 

complete_df_scores_1 = mutate(complete_df_1, percentage_score = (sum_score/total)*100)


View(complete_df_scores_1)

#student info csv read in
student_info<-read.csv("data/studentInfo.csv")

#add id_pres column
student_info$id_pres<-paste(student_info$id_student,student_info$code_presentation, student_info$code_module, sep="-")
#select only those two columns
student_info<-student_info %>% select(id_pres, final_result)
#left join
complete_df_scores_1<-left_join(complete_df_scores_1, student_info, by="id_pres")
names<-colnames(complete_df_scores_1)
names[4]<-"code_presentation"
names[5]<-"code_module"
colnames(complete_df_scores_1)<-names
write.csv(complete_df_scores_1, file = "data/Student_data_1.csv")




