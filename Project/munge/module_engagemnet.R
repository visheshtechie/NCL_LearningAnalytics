
#create module engagement csv file
#groubby presentation & module sum cilck number in each presentation
df_sumclick_module<-Student_data_1%>%group_by(code_presentation,code_module)%>%
                                       summarise(sum_click_module=sum(total_clicks))
#count student number in each presentation
df_sumclick_countstudent<-Student_data_1%>%group_by(code_presentation,code_module)%>%count()
df_sumclick_module_countstudent<-df_sumclick_module%>%left_join(df_sumclick_countstudent,by=c("code_presentation","code_module"))%>%
  summarise(code_presentation=code_presentation,
                             code_module=code_module,
                             sum_click_module=sum_click_module,
                             studentCount=n,
                             mean_click=sum_click_module/n)

#write the csv file
write_csv(df_sumclick_module_countstudent,file = "/Users/yingxiwang/Desktop/semester2/Group8_project/GitHub/EDA_Claire/module_engagement.csv")