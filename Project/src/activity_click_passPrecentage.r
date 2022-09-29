library('ProjectTemplate')
load.project()


library(tidyverse)
library(ggplot2)

#
df_AAA2013J_activity_click <- df_studentVle_Allmodule %>% 
  filter(code_module=='AAA' & code_presentation=='2013J') %>%
  group_by(activity_type ) %>% summarise(n = sum(sum_click))
df_AAA2013J_activity_click$n <- df_AAA2013J_activity_click$n / sum(df_AAA2013J_activity_click$n) * 100
####
df_AAA2013J_activity_click <- df_AAA2013J_activity_click[order(df_AAA2013J_activity_click$n,decreasing = T),] 
dfhead <- head(df_AAA2013J_activity_click)

i=as.numeric(nrow(df_AAA2013J_activity_click))
dfother <- df_AAA2013J_activity_click[6:i,]%>%summarise(activity_type="other",
                                                        n=sum(n))

df_AAA2013J_activity_click <- rbind(dfhead,dfother)

df_AAA2013J_activity_click <- df_AAA2013J_activity_click %>% 
  pivot_wider(names_from = activity_type, values_from = n)
df_AAA2013J_activity_click$code_module <- 'AAA'
df_AAA2013J_activity_click$code_presentation <- '2013J'

df_AAA2013J_info <- studentInfo %>% filter(code_module=='AAA' & code_presentation=='2013J') %>%
  group_by(final_result) %>% count()
df_AAA2013J_passrate <- (df_AAA2013J_info$n[which(df_AAA2013J_info$final_result=='Distinction')] + df_AAA2013J_info$n[which(df_AAA2013J_info$final_result=='Pass')]) / sum(df_AAA2013J_info$n)
df_AAA2013J_activity_click$Pass_rate <-  df_AAA2013J_passrate

#create function to get the click percentage of each types of activities and pass rate
createDFactivityclick <- function(code_module1, code_presentation1){
  #get the click percentage of each types of activities
  df <- df_studentVle_Allmodule %>% 
    filter(code_module == as.character(code_module1) & code_presentation == as.character(code_presentation1)) %>%
    group_by(activity_type) %>% summarise(n = sum(sum_click))
  df$n <- df$n / sum(df$n) * 100
  ###
  #df <- df[order(df$n,decreasing = T),] 
  #dfhead <- head(df,4)
  
  
  
  #i=length(df$n)
  #dfother <- data.frame(activity_type='other', n=sum(df[5:i,]$n))
  
 
  #df <- rbind(dfhead,dfother)
  ###
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
#use the function(createDFactivityclick) in every module and presentation
#AAA
df_AAA2013J_activity_click <- createDFactivityclick('AAA', '2013J')
df_AAA2014J_activity_click <- createDFactivityclick('AAA', '2014J')
#BBB
df_BBB2013B_activity_click <- createDFactivityclick('BBB', '2013B')
df_BBB2013J_activity_click <- createDFactivityclick('BBB', '2013J')
df_BBB2014B_activity_click <- createDFactivityclick('BBB', '2014B')
df_BBB2014J_activity_click <- createDFactivityclick('BBB', '2014J')
#CCC
df_CCC2014B_activity_click <- createDFactivityclick('CCC', '2014B')
df_CCC2014J_activity_click <- createDFactivityclick('CCC', '2014J')
#DDD
df_DDD2013B_activity_click <- createDFactivityclick('DDD', '2013B')
df_DDD2013J_activity_click <- createDFactivityclick('DDD', '2013J')
df_DDD2014B_activity_click <- createDFactivityclick('DDD', '2014B')
df_DDD2014J_activity_click <- createDFactivityclick('DDD', '2014J')
#EEE
df_EEE2013J_activity_click <- createDFactivityclick('EEE', '2013J')
df_EEE2014B_activity_click <- createDFactivityclick('EEE', '2014B')
df_EEE2014J_activity_click <- createDFactivityclick('EEE', '2014J')
#FFF
df_FFF2013B_activity_click <- createDFactivityclick('FFF', '2013B')
df_FFF2013J_activity_click <- createDFactivityclick('FFF', '2013J')
df_FFF2014B_activity_click <- createDFactivityclick('FFF', '2014B')
df_FFF2014J_activity_click <- createDFactivityclick('FFF', '2014J')
#GGG
df_GGG2013J_activity_click <- createDFactivityclick('GGG', '2013J')
df_GGG2014B_activity_click <- createDFactivityclick('GGG', '2014B')
df_GGG2014J_activity_click <- createDFactivityclick('GGG', '2014J')


# combine all the sub-dataset 
df_allmodule_activity_click = bind_rows(df_AAA2013J_activity_click,
                                        df_AAA2014J_activity_click,
                                        df_BBB2013B_activity_click,
                                        df_BBB2013J_activity_click,
                                        df_BBB2014B_activity_click,
                                        df_BBB2014J_activity_click,
                                        df_CCC2014B_activity_click,
                                        df_CCC2014J_activity_click,
                                        df_DDD2013B_activity_click,
                                        df_DDD2013J_activity_click,
                                        df_DDD2014B_activity_click,
                                        df_DDD2014J_activity_click,
                                        df_EEE2013J_activity_click,
                                        df_EEE2014B_activity_click,
                                        df_EEE2014J_activity_click,
                                        df_FFF2013B_activity_click,
                                        df_FFF2013J_activity_click,
                                        df_FFF2014B_activity_click,
                                        df_FFF2014J_activity_click,
                                        df_GGG2013J_activity_click,
                                        df_GGG2014B_activity_click,
                                        df_GGG2014J_activity_click)


write.csv(df_allmodule_activity_click,file = "/Users/yingxiwang/Desktop/semester2/Group8_project/GitHub/EDA_Claire/df_allmodule_activity_click.csv")

#Linear regression models of

X_click <- df_allmodule_activity_click[,-c(6:8)]
Y_click <- df_allmodule_activity_click$Pass_rate*100
x<-data.frame(X_click,Y_click)
#Allmodule_activity_click_model<-lm(formula = df_allmodule_activity_click[,12] ~ df_allmodule_activity_click[,-c(10,11)])
Allmodule_activity_click_model<-lm(Y_click~.,data = x)
summary(Allmodule_activity_click_model)

