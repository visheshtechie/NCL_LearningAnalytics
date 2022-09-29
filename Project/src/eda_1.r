library('ProjectTemplate')
load.project()



#df_studentAssessment = studentAssessment[sample(nrow(studentAssessment), 10000), ]
#df_studentVle = studentVle[sample(nrow(studentVle), 10000), ]

#df = inner_join(studentAssessment, studentVle, by = 'id_student')

df_studentInfo = studentInfo[,c(-4:-8,-11)]
#df_Assessment = assessments[which(assessments$assessment_type == 'Exam'),]
#df_studentAssessment0 = studentAssessment[which(studentAssessment$id_assessment == df_Assessment$id_assessment),]

#df_stuRe_stuInfo <- merge(df_studentInfo,studentRegistration , by.x = "code_module", by.y = "code_presentation", by.z = "id_student",all.z=TRUE)
df_studentInfo_group <- df_studentInfo%>%group_by(id_student,code_module,code_presentation)%>%left_join(,)
1 <- merge(df_studentInfo,studentRegistration , by.x = "code_module", by.y = "code_presentation", by.z = "id_student",all.z=TRUE)
df_Assessmentstu <- studentAssessment %>%left_join(assessments,by="id_assessment") #%>% filter(assessment_type == 'Exam')
df_Assessmentstu_course <-df_Assessmentstu%>%left_join(courses,by=c("code_module","code_presentation"))#%>% filter(assessment_type == 'Exam')
df_Assessmentstu_course_click <-df_Assessmentstu_course%>%left_join(studentVle,by=c("code_module","code_presentation","id_student"))
#Number of credit with Final result
ggplot(studentInfo, aes(x=studied_credits)) + geom_histogram()

Assessmentstu_A <- studentAssessment %>%left_join(assessments,by="id_assessment") %>% filter(code_module == 'AAA')
# combine the assesmentstudent and 
df_AssStuA<- studentVle%>%filter(code_module == "AAA")
#df1 <- Assessmentstu_A %>% filter(id_student == 6516)


df_studentInfoA<-df_studentInfo%>%filter(code_module == "AAA")
ggplot(df_studentInfoA,aes(factor(final_result),fill=factor(studied_credits)))+geom_bar()




# combine assessment with studentAssessment
df_assessment_stuassessment <- studentAssessment %>%left_join(assessments,by="id_assessment")
# add id_student,
df_assessment_stuassessment <-tidyr::unite(df_assessment_stuassessment, "id",code_module, id_student,id_assessment,remove = FALSE)
