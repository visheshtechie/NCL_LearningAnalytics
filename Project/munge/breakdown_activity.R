#Student-percentage clicks to activity
library(factoextra)
library(rstatix)

#uses dataset created by src/activity_type.R
student_activity<-read.csv("data/student_activity.csv")

#breakdown dataframe made
breakdown_activity<-data.frame(unique(student_activity$id_pres))
#create columns for all activity types
for (i in unique(student_activity$activity_type)){
  breakdown_activity[i]<-0
}

#set teh row names to be the student row names
row.names(breakdown_activity)<-breakdown_activity$unique.student_activity.id_pres.

#get the unique activity type
activities<-unique(student_activity$activity_type)
#for each student id 
for (i in unique(student_activity$id_pres)){
  #get teh rows which the id_pres is equal to i
  index_id<-which(student_activity$id_pres==i)
  #for all activity types
  for (j in activities){
    #temporary datframe
    temp<-student_activity[index_id,]
    #the number of clicks by activity for a student
    clicks<-temp[temp$activity_type==j,]$clicks_by_activity
    #if the student did not take part in that activity set to 0
    if (length(clicks)==0){
      #set to 0
      clicks<-0
    }
    #add to the breakdown activity dataframe
    breakdown_activity[i,j]<-clicks
  }
}

#remove student numbers
breakdown_activity<-breakdown_activity[,c(2:21)]

#add a total column
breakdown_activity$total<-apply(breakdown_activity, MARGIN=1, sum)

#calculate as each column as a percentage of total clicks
for (i in activities){
  breakdown_activity[,i]<-(breakdown_activity[,i]/breakdown_activity$total)
}
#remove the total column
breakdown_activity<-breakdown_activity[,c(1:20)]

#pca analysis
pca_breakdown_activity<-prcomp(breakdown_activity)

#plot eiganvalues
fviz_eig(pca_breakdown_activity)

#set seed for reproducibility
set.seed(42)

#perform kmeans
kmeans_result<-kmeans(breakdown_activity, 4)

#perform pca visualisation
fviz_pca_ind(pca_breakdown_activity,geom="point", habillage = kmeans_result$cluster)

#perform variable visualisation
fviz_pca_var(pca_breakdown_activity)

#Get the first 3 dimensions
PCA_axis<-data.frame(pca_breakdown_activity$x[,1:3])
#add the id_pres column
PCA_axis$id_pres<-row.names(PCA_axis)
#set up group column
PCA_axis$group<-0
#for loop
for( i in row.names(PCA_axis)){
  #set the values
  PCA_axis[i, "group"]<-kmeans_result$cluster[i]
}

#write to csv
write.csv(PCA_axis,"data/PCA_results.csv")

#Removing some columns
#remove the total column
breakdown_activity_reduced<-breakdown_activity[c("quiz", "oucontent", "externalquiz", "ouwiki", "url","forumng", "homepage")]

#pca analysis
pca_breakdown_activity<-prcomp(breakdown_activity_reduced)

#plot eiganvalues
fviz_eig(pca_breakdown_activity)

#set seed for reproducibility
set.seed(42)

#perform kmeans
kmeans_result<-kmeans(breakdown_activity_reduced, 4)

#perform pca visualisation
fviz_pca_ind(pca_breakdown_activity,geom="point", habillage = kmeans_result$cluster)

#perform variable visualisation
fviz_pca_var(pca_breakdown_activity)

#Get the first 3 dimensions
PCA_axis<-data.frame(pca_breakdown_activity$x[,1:3])
#add the id_pres column
PCA_axis$id_pres<-row.names(PCA_axis)
#set up group column
PCA_axis$group<-0
#for loop
for( i in row.names(PCA_axis)){
  #set the values
  PCA_axis[i, "group"]<-kmeans_result$cluster[i]
}
#Add a pres_specific column
#create empty list
pres_specific<-c()
#for loop
for (i in PCA_axis$id_pres){
  #split i by "-"
  x<-strsplit(i, "-")
  #append to empty list
  pres_specific<-append(pres_specific, paste(x[[1]][3],x[[1]][2], sep="-"))
}
#Add to the existing dataframe
PCA_axis$pres_specific<-pres_specific

#write to csv
write.csv(PCA_axis,"data/PCA_results.csv")
