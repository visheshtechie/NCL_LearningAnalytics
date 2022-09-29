library(tidyverse)
library(ggplot2)


#AAAmodel test
#
#df_studentvle_AAA <- studentVle%>%filter(code_module == "AAA")%>%left_join(vle[,1:4],by=c("id_site","code_module","code_presentation"))
#df_studentvle_AAA <- df_studentvle_AAA%>%left_join(studentInfo[,c(1,2,3,12)],by=c("id_student","code_module","code_presentation"))
studentVle<-read.csv("data/studentVle.csv")
vle<-read.csv("data/vle.csv")
studentInfo<-read.csv("data/studentInfo.csv")
#combine studentVle,Vle and studentInfo to 
df_studentVle_Allmodule <- studentVle%>%left_join(vle[,1:4],by=c("id_site","code_module","code_presentation"))
df_studentVle_Allmodule <- df_studentVle_Allmodule%>%left_join(studentInfo[,c(1,2,3,12)],by=c("id_student","code_module","code_presentation"))

#add new column :pass&Distinction=1
df_studentVle_Allmodule$Pass = df_studentVle_Allmodule$final_result

df_studentVle_Allmodule$Pass[which(df_studentVle_Allmodule$Pass=='Pass' | df_studentVle_Allmodule$Pass=='Distinction')] = '1'
df_studentVle_Allmodule$Pass[which(df_studentVle_Allmodule$Pass=='Fail' | df_studentVle_Allmodule$Pass== 'Withdrawn')] = '0'

#write.csv(df_studentVle_Allmodule,file = "/Users/yingxiwang/Desktop/semester2/Group8_project/GitHub/EDA_Claire/df_allmodule_activity_num.csv")

#Create id_pres column
df_studentVle_Allmodule$pres_specific<-paste(df_studentVle_Allmodule$code_module,df_studentVle_Allmodule$code_presentation, sep="-")
#group by id_pres and activity_type
df_studentVle_Allmodule_grouped<-group_by(df_studentVle_Allmodule, id_pres, activity_type,id_student,code_presentation, code_module, final_result)%>% summarise(clicks_by_activity=sum(sum_click))

write.csv(df_studentVle_Allmodule_grouped, "data/student_activity.csv")

#plot AAA module
df_studentVle_Allmodule_A <- df_studentVle_Allmodule%>%filter(code_module == "AAA")
df_studentVle_Allmodule_A <- group_by(df_studentVle_Allmodule_A,activity_type)
#df_studentvle_A_ms<-group_by(df_studentvle_A,date)
 # df_studentvle_A_ms<- summarise(df_studentvle_A_ms,
                            #     code_module = "AAA",
                            #    clicksum=sum(sum_click))
#plot(df_studentVle_Allmodule_A,aes(x=activity_type,fill=factor(Pass)))+geom_bar()
  

## Plot distribution of activity types,pass or not

df_AAA2013J = df_studentVle_Allmodule %>% filter(code_module=='AAA' & code_presentation=='2013J') %>%
  group_by(activity_type, Pass) %>% summarise(sum_all_click = sum(sum_click))
df_AAA2013J_barplot = ggplot(df_AAA2013J, aes(x=activity_type, y=sum_all_click, fill=Pass)) + geom_bar(position = "stack", stat = "identity", alpha=1)

df_AAA2014J = df_studentVle_Allmodule %>% filter(code_module=='AAA' & code_presentation=='2014J') %>%
  group_by(activity_type, Pass) %>% summarise(sum_all_click = sum(sum_click))
df_AAA2014J_barplot = ggplot(df_AAA2014J, aes(x=activity_type, y=sum_all_click, fill=Pass)) + geom_bar(position = "stack", stat = "identity", alpha=1)

grid.arrange(df_AAA2013J_barplot, df_AAA2014J_barplot)

## Plot distribution of activity types

df_AAA2013J_1 = df_studentVle_Allmodule %>% filter(code_module=='AAA' & code_presentation=='2013J') %>%
  group_by(activity_type, final_result) %>% summarise(sum_all_click = sum(sum_click))
df_AAA2013J_barplot_1 = ggplot(df_AAA2013J_1, aes(x=activity_type, y=sum_all_click, fill=final_result)) + geom_bar(position = "stack", stat = "identity", alpha=1)

df_AAA2014J_1 = df_studentVle_Allmodule %>% filter(code_module=='AAA' & code_presentation=='2014J') %>%
  group_by(activity_type, final_result) %>% summarise(sum_all_click = sum(sum_click))
df_AAA2014J_barplot_1 = ggplot(df_AAA2014J_1, aes(x=activity_type, y=sum_all_click, fill=final_result)) + geom_bar(position = "stack", stat = "identity", alpha=1)

grid.arrange(df_AAA2013J_barplot_1, df_AAA2014J_barplot_1)



