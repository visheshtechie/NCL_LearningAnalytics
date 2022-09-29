##########################################################
# Author: Chinomnso Ekwedike
# Date: 17/03/2022
# Module: Group Project - CSC8633
# Version: 1.0
##########################################################

# load the necessary libraries
suppressPackageStartupMessages(library(readr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(ggvis))
suppressPackageStartupMessages(library(knitr))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(treemapify))


# load the data set
student_data = read_csv("data/Student_data1.csv", show_col_types = FALSE)

# check column names
colnames(student_data)

# check data frame dimension
dim(student_data)

# retrieve the columns
new_st_data = student_data %>% select(pres_specific, id_pres)

# check the data subset
n_row = nrow(new_st_data)
n_column = ncol(new_st_data)
missing = any(is.na(new_st_data))

# display the outputs on separate lines
cat(paste("Rows: ", n_row, "\nColumns: ", n_column, "\nMissing Rows: ", missing))


# convert table to data frame and rename columns
st_count = as.data.frame(table(new_st_data$pres_specific)) %>% rename(pres_specific = Var1, num_of_students = Freq)

# display the data frame
kable(st_count)


#compute the percentage of each student within each code specific presentation
new_student_data = st_count %>% mutate(percentage = round(100 * num_of_students / n_row, 1))
kable(new_student_data)

# write data frame to csv file
#write_csv(new_student_data, "pres_specific_count.csv")


##### Graphical Summaries

# Show the different numbers in a bar chart
# plot pres_specific against number of students
new_student_data %>% ggvis(~pres_specific, ~num_of_students, fill = ~pres_specific) %>% layer_bars() %>% add_axis(
  "x", 
  title = "pres_specific", 
  title_offset = 80, 
  tick_padding = 3, 
  properties = axis_props(labels = list(angle = -70, 
  align = "right", 
  fontSize = 10))) %>% add_axis("y", title = "num_of_students", title_offset = 50)



#Display the percentage in a tree map. The tree map provides an alternative to pie chart given 
# the number of rows (22) in the data frame.

ggplot(new_student_data, aes(area = percentage, fill = pres_specific, label = paste(pres_specific, "\n", percentage, "%"))) + 
  geom_treemap() +
  geom_treemap_text(colour = "white",
                    place = "centre",
                    size = 10) + 
  theme(legend.position = "none")


