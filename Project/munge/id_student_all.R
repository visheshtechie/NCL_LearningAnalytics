library(tidyverse)
#create df_studentVle_Allmodule which is the combine of  studentVle,vle and studentInfo
df_studentVle_Allmodule <- studentVle%>%left_join(vle[,1:4],by=c("id_site","code_module","code_presentation"))
df_studentVle_Allmodule <- df_studentVle_Allmodule%>%left_join(studentInfo[,c(1,2,3,12)],by=c("id_student","code_module","code_presentation"))

#add new column :pass&Distinction=1
df_studentVle_Allmodule$Pass = df_studentVle_Allmodule$final_result

df_studentVle_Allmodule$Pass[which(df_studentVle_Allmodule$Pass=='Pass' | df_studentVle_Allmodule$Pass=='Distinction')] = '1'
df_studentVle_Allmodule$Pass[which(df_studentVle_Allmodule$Pass=='Fail' | df_studentVle_Allmodule$Pass== 'Withdrawn')] = '0'

#Create id_pres column
df_studentVle_Allmodule$pres_specific<-paste(df_studentVle_Allmodule$code_module,df_studentVle_Allmodule$code_presentation, sep="-")
df_studentVle_Allmodule<- mutate(df_studentVle_Allmodule, id_pres= paste(id_student, code_presentation,code_module,sep="-"))


#create the final_result column
df_studentInfo <- studentInfo[,-4:-11]
df_studentInfo$pres_specific<-paste(df_studentInfo$code_module,df_studentInfo$code_presentation, sep="-")
df_studentInfo<- mutate(df_studentInfo, id_pres= paste(id_student, code_presentation,code_module,sep="-"))

#create the sum of click in different activities
id_student_column <- df_studentVle_Allmodule
id_student_column1 <- id_student_column%>%group_by(pres_specific,id_student,activity_type)%>%summarise(sum_click=sum(sum_click))%>%pivot_wider(names_from = activity_type, values_from = sum_click)
id_student_column <- id_student_column1%>%left_join(df_studentInfo,by=c("pres_specific","id_student"))
id_student_column$Pass[which(id_student_column$final_result=='Pass' | id_student_column$final_result=='Distinction')] = '1'
id_student_column$Pass[which(id_student_column$final_result=='Fail' | id_student_column$final_result== 'Withdrawn')] = '0'

#read in student vle data
student_vle<-studentVle
#create id_pres
student_vle<-mutate(student_vle, id_pres=paste(id_student, code_presentation,code_module,sep="-"))
#group by id_pres and give us date as well 
student_vle_grouped<-group_by(student_vle, id_pres, date) %>% summarise(clicks=sum(sum_click))
#group by id_pres and count the number of dates to give the number of days the student was active
student_vle_grouped<-group_by(student_vle_grouped, id_pres) %>% summarise(days=length(date))
id_student_column <- id_student_column%>%left_join(student_vle_grouped,by="id_pres")
write.csv(id_student_column,file = "/Users/yingxiwang/Desktop/semester2/Group8_project/GitHub/EDA_Claire/id_student_column.csv") 
