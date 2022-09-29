library('ProjectTemplate')
load.project()


library(tidyverse)
marks=read_csv("D:/Documents/Newcaslte University/Group Project/student_data_1.csv")
#view(marks)
top20_students=group_by(marks,id_student)%>%
  summarise(score=mean(percentage_score))%>%
  filter(score>80) #THRESHOLD FOR TOP STUDENTS
#view(top20_students)

clicks=read_csv("D:/Documents/Newcaslte University/Group Project/studentVle.csv")
top20_clicks=left_join(top20_students,clicks,by='id_student')
colnames(top20_clicks)
#view(top20_clicks)

top20_clicks=top20_clicks[c('code_module','code_presentation','id_student','id_site','sum_click','score')]

activity=read_csv("D:/Documents/Newcaslte University/Group Project/vle.csv")
#view(activity)
top20_activity=left_join(top20_clicks,activity,by='id_site')
view(top20_activity)
top20_activity=top20_activity[c('code_module','code_presentation','id_student','id_site','sum_click','score','activity_type')]

rewarding_activities=top20_activity%>%group_by(code_module.x,code_presentation.x,activity_type)%>%summarise(clicksum=sum(sum_click))
#view(rewarding_activities)
write_csv(rewarding_activities,"D:/Documents/Newcaslte University/Group Project/rewarding_activites.csv")
