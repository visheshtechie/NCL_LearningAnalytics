library('ProjectTemplate')
load.project()


library(tidyverse)

df_studentVle_Allmodule <- studentVle%>%left_join(vle[,1:4],by=c("id_site","code_module","code_presentation"))
df_studentVle_Allmodule <- df_studentVle_Allmodule%>%left_join(studentInfo[,c(1,2,3,12)],by=c("id_student","code_module","code_presentation"))


#test A
df_AAA2013J_activity_num1 <- vle %>% 
  filter(code_module=='AAA' & code_presentation=='2013J') %>%
  group_by(activity_type) %>% count()
#df_AAA2013J_activity_num1 <- df_AAA2013J_activity_num1%>%group_by(activity_type)

df_AAA2013J_activity_num1$n <- df_AAA2013J_activity_num1$n / sum(df_AAA2013J_activity_num1$n) * 100

###
#df_AAA2013J_activity_num1 <- df_AAA2013J_activity_num1[order(df_AAA2013J_activity_num1$n,decreasing = T),] 
#dfhead <- head(df_AAA2013J_activity_num1,4)

#i=length(df_AAA2013J_activity_num1$n)
#dfother <- data.frame(activity_type='other', n=sum(test1[5:i,]$n))

#df_AAA2013J_activity_num1 <- rbind(dfhead,dfother)

df_AAA2013J_activity_num1 <- df_AAA2013J_activity_num1 %>% 
  pivot_wider(names_from = activity_type, values_from = n)
df_AAA2013J_activity_num1$code_module <- 'AAA'
df_AAA2013J_activity_num1$code_presentation <- '2013J'

df_AAA2013J_info <- studentInfo %>% filter(code_module=='AAA' & code_presentation=='2013J') %>%
  group_by(final_result) %>% count()
df_AAA2013J_passrate <- (df_AAA2013J_info$n[which(df_AAA2013J_info$final_result=='Distinction')] + df_AAA2013J_info$n[which(df_AAA2013J_info$final_result=='Pass')]) / sum(df_AAA2013J_info$n)
df_AAA2013J_activity_num1$Pass_rate <-  df_AAA2013J_passrate


#create function to get the percentage of each types of activities and pass rate
createDFactivitynum <- function(code_module1, code_presentation1){
  #get the click percentage of each types of activities
  df <- vle %>% 
    filter(code_module == as.character(code_module1) & code_presentation == as.character(code_presentation1)) %>%
    group_by(activity_type) %>%count()
  df$n <- df$n / sum(df$n) * 100

  df <- df %>% 
    pivot_wider(names_from = activity_type, values_from = n)
  df$code_module <- as.character(code_module1)
  df$code_presentation <- as.character(code_presentation1)
  
  # get pass rate
  df1 <- studentInfo %>% filter(code_module == as.character(code_module1) & code_presentation == as.character(code_presentation1)) %>%
    group_by(final_result) %>% count()
  df1 <- (df1$n[which(df1$final_result=='Distinction')] + df1$n[which(df1$final_result=='Pass')]) / sum(df1$n)
  df$Pass_rate <-  df1
  
  return(df)
}

#use the function(createDFactivitynum) in every module and presentation
#AAA
df_AAA2013J_activity_num <- createDFactivitynum('AAA', '2013J')
df_AAA2014J_activity_num <- createDFactivitynum('AAA', '2014J')
#BBB
df_BBB2013B_activity_num <- createDFactivitynum('BBB', '2013B')
df_BBB2013J_activity_num <- createDFactivitynum('BBB', '2013J')
df_BBB2014B_activity_num <- createDFactivitynum('BBB', '2014B')
df_BBB2014J_activity_num <- createDFactivitynum('BBB', '2014J')
#CCC
df_CCC2014B_activity_num <- createDFactivitynum('CCC', '2014B')
df_CCC2014J_activity_num <- createDFactivitynum('CCC', '2014J')
#DDD
df_DDD2013B_activity_num <- createDFactivitynum('DDD', '2013B')
df_DDD2013J_activity_num <- createDFactivitynum('DDD', '2013J')
df_DDD2014B_activity_num <- createDFactivitynum('DDD', '2014B')
df_DDD2014J_activity_num <- createDFactivitynum('DDD', '2014J')
#EEE
df_EEE2013J_activity_num <- createDFactivitynum('EEE', '2013J')
df_EEE2014B_activity_num <- createDFactivitynum('EEE', '2014B')
df_EEE2014J_activity_num <- createDFactivitynum('EEE', '2014J')
#FFF
df_FFF2013B_activity_num <- createDFactivitynum('FFF', '2013B')
df_FFF2013J_activity_num <- createDFactivitynum('FFF', '2013J')
df_FFF2014B_activity_num <- createDFactivitynum('FFF', '2014B')
df_FFF2014J_activity_num <- createDFactivitynum('FFF', '2014J')
#GGG
df_GGG2013J_activity_num <- createDFactivitynum('GGG', '2013J')
df_GGG2014B_activity_num <- createDFactivitynum('GGG', '2014B')
df_GGG2014J_activity_num <- createDFactivitynum('GGG', '2014J')


# combine all the sub-dataset 
df_allmodule_activity_num = bind_rows(df_AAA2013J_activity_num,
                                        df_AAA2014J_activity_num,
                                        df_BBB2013B_activity_num,
                                        df_BBB2013J_activity_num,
                                        df_BBB2014B_activity_num,
                                        df_BBB2014J_activity_num,
                                        df_CCC2014B_activity_num,
                                        df_CCC2014J_activity_num,
                                        df_DDD2013B_activity_num,
                                        df_DDD2013J_activity_num,
                                        df_DDD2014B_activity_num,
                                        df_DDD2014J_activity_num,
                                        df_EEE2013J_activity_num,
                                        df_EEE2014B_activity_num,
                                        df_EEE2014J_activity_num,
                                        df_FFF2013B_activity_num,
                                        df_FFF2013J_activity_num,
                                        df_FFF2014B_activity_num,
                                        df_FFF2014J_activity_num,
                                        df_GGG2013J_activity_num,
                                        df_GGG2014B_activity_num,
                                        df_GGG2014J_activity_num)
#Replace the missing values with 0
df_allmodule_activity_num[is.na(df_allmodule_activity_num)]=0
#
#write.csv(df_allmodule_activity_num,file = "/Users/yingxiwang/Desktop/semester2/Group8_project/GitHub/EDA_Claire/df_allmodule_activity_num.csv")

X_num <- df_allmodule_activity_num[,-c(6:8)]
Y_num <- df_allmodule_activity_num$Pass_rate*100
df_allmodule_activity_num <- data.frame(X_num,Y_num)
#Allmodule_activity_click_model<-lm(formula = df_allmodule_activity_click[,12] ~ df_allmodule_activity_click[,-c(10,11)])
df_allmodule_activity_num_model<-lm(Y_num ~ .,df_allmodule_activity_num)
summary(df_allmodule_activity_num_model)
