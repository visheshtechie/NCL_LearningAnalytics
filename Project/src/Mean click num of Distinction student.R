
library('ProjectTemplate')
load.project()



#combine studentVle,Vle and studentInfo to 
df_studentVle_Allmodule <- studentVle%>%left_join(vle[,1:4],by=c("id_site","code_module","code_presentation"))
df_studentVle_Allmodule <- df_studentVle_Allmodule%>%left_join(studentInfo[,c(1,2,3,12)],by=c("id_student","code_module","code_presentation"))
df_distinction <- df_studentVle_Allmodule%>%filter(final_result=="Distinction")
df_distinction$pres_specific <- paste(df_distinction$code_module,df_distinction$code_presentation, sep="-")


df_distinction_click_clicknum <- df_distinction%>%group_by(activity_type)%>%summarise(sumclick=sum(sum_click))
df_distinction_click_studentnum <- df_distinction%>%group_by(activity_type)%>%count(id_student)%>%group_by(activity_type)%>%count()
df_distinction_click <- df_distinction_click_clicknum%>%left_join(df_distinction_click_studentnum, by = "activity_type")%>%summarise(activity_type=activity_type,average=sumclick/n)

df_distinction_num_pres_specific <- df_distinction%>%group_by(activity_type)%>%count(pres_specific)%>%group_by(activity_type)%>%count()                                                                
df_distinction <- df_distinction_click%>%left_join(df_distinction_num_pres_specific,by="activity_type")%>%summarise(activity_type=activity_type,average_click=average,num_pre=n)



write.csv(df_distinction,file = "/Users/yingxiwang/Desktop/semester2/Group8_project/GitHub/EDA_Claire/df_distinction_activity_click.csv")
