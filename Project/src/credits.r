library('ProjectTemplate')
load.project()


#studied_credits

library(tidyverse)
library(MASS)

#clean student information dataset
df_studentInfo = studentInfo[,c(-4:-8,-11)]
#Credits distribution
ggplot(studentInfo, aes(x=studied_credits)) + geom_histogram()
#plot the studied_credits with final_result
ggplot(df_studentInfo,aes(studied_credits,id_student,color=factor(final_result)))+geom_point()       
#When the credits are larger, the student is about to give up easily. Between 300-600 credits, there are no distinction participants,


ggplot(df_studentInfo,aes(factor(final_result),fill=factor(studied_credits)))+geom_bar()


#studied credit number in module A (as example)
df_studentInfoA<-df_studentInfo%>%filter(code_module == "AAA")
ggplot(df_studentInfoA,aes(factor(final_result),fill=factor(studied_credits)))+geom_bar()


