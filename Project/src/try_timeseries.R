
library('ProjectTemplate')
load.project()


library(tidyverse)
library(stats)
studentAssessment <- read_csv("data/studentAssessment.csv")
studentVle <- read_csv("data/studentVle.csv")
assessments <- read_csv("data/assessments.csv")

# combine assessment with studentAssessment
df_assessment_stuassessment <- studentAssessment %>%left_join(assessments,by="id_assessment")
View(df_assessment_stuassessment)

# add id_student,
df_assessment_stuassessment <-tidyr::unite(df_assessment_stuassessment, "id",code_module, id_student,id_assessment,remove = FALSE)

par(mfrow = c(3,3))
#AA
df_assessment_stuassessment_A <- studentAssessment %>%left_join(assessments,by="id_assessment")%>%filter(code_module == "AAA")
df_studentvle_A <- studentVle%>% filter(code_module == "AAA")
df_studentvle_A_ms<-group_by(df_studentvle_A,date)
df_studentvle_A_ms<- summarise(df_studentvle_A_ms,
                               code_module = "AAA",
                              clicksum=sum(sum_click) )

colnames(studentVle)
colnames(df_assessment_stuassessment)

engagement_over_time=df_assessment_stuassessment[,c("id_student" ,"date" )]
engagement_over_time = studentVle%>%left_join(engagement_over_time,by="id_student")

table(df_studentvle_A$date)
ms <- ts(df_studentvle_A_ms$clicksum, df_studentvle_A_ms$date)
plot(ms,  main = "AAA")+abline(v =  unique(df_assessment_stuassessment_A$date),col=3,lty=6)  
end(ms)
frequency(ms)
ms.subset <- window(ms,start = -24,end = 269)
ms.subset


#BBB
df_assessment_stuassessment_B <- studentAssessment %>%left_join(assessments,by="id_assessment")%>%filter(code_module == "BBB")
df_studentvle_B <- studentVle%>% filter(code_module == "BBB")
df_studentvle_B_ms<-group_by(df_studentvle_B,date)
df_studentvle_B_ms<- summarise(df_studentvle_B_ms,
                               code_module = "BBB",
                               clicksum=sum(sum_click) )

table(df_studentvle_B$date)
ms <- ts(df_studentvle_B_ms$clicksum, df_studentvle_B_ms$date)
plot(ms, main = "BBB")+abline(v = unique(df_assessment_stuassessment_B$date),col=3,lty=6) 
