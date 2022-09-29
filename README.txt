############################################################################

CSC8633 GROUP PROJECT IN DATA SCIENCE  


GROUP 8

############################################################################




#####	 Project Overview   #####
###############################

This project aims to design a data science system using Open University Learning Analytics data. The project 
artefacts include exploratory data analysis and data profiling reports, source codes, project reports, git 
log, interactive Power BI dashboards and classification (predictive modelling) outputs. This project was 
carried out using R, Python, Microsoft Power BI and KNIME.



#####	 Project Features   #####
###############################

- Literature Review of similar projects
- Exploratory Data Analysis
- Data Preparation/Preprocessing and Transformation
- Data Visualisation
- Interactive Dashboards 
- Predictive Modelling through Classification and Model Evaluation



#### Data Source #####
######################

 Open University Learning Analytics Data
	- https://analyse.kmi.open.ac.uk/open_database#data



#####	 Project File Structure   #####
#####################################

All the source codes, data, outputs and reports from this project are stored in the `Project`
folder which is the ProjectTemplate folder. Within `Project` (ProjectTemplate) folder,
 

- The `config` folder contains the `global.dcf` file which contains the configuration settings for 
the project as as well as the R packages/libraries used for the project.


- The `data` folder contains all the data sets (7) that were used for the project and they include:
	`assessments.csv` - this contains information about module-presentations.
	`courses.csv` -  this contains a list of all available modules and their presentations.
	`studentAssessment.csv` -  this contains the results of students' assessments.
	`studentInfo.csv` - this contains the demographic information of the students as well as their
				results in each module they studied.
	`studentRegistration.csv` - this contains the information about student registration for the 
					  module presentation.
	`studentVle.csv` - this contains the information about students' interaction with VLE (Virtual 
				Learning Environment.
	`vle.csv` - this contains information about the materials made available in the VLE.
	


- The `munge` folder contains the pre-processing scripts for the project which are automatically run when
the `load.project()` function is executed. This contains code for loading the data into R for analysis and 
the codes used for carrying out different data transformations, data mining and writing the new data frames 
generated in the process to a csv (comma separated values) file to be used for constructing the interactive
Power BI dashboards and subsequent predictive modelling in KNIME. 
This feature can be set to TRUE or FALSE within the `global.dcf` within the `munging:` parameter. At the 
moment it is set to TRUE.

	This folder also contains the following R scripts:
	- O1-A.R - default `ProjectTemplate` munge script so does not contain any script used for the project
	- activity_type.R - used to create `student_activity.csv`
	- Assessment_pre_engagement.R - used to analyse student engagement with VLE before exams
	- breakdown_activity.R - used to create `PCA_results.csv`
	- day2_munge_changed.R - used to create `Student_data_1.csv`
	- EDA_id_pres_pres_specific_count.R - used for computing the number of students per each module and 
							corresponding presentation
	- Engagement_over_time.R - used to create `mean_number_of_clicks_per_credit.csv` and 
				`Engagement_per_module_over_time.csv`
	- Pres_specific_assessments_dates.R - used to create `Pres_specific_assessment_dates.csv`
	- id_student_all.R - for grouping students by their student id
	- module_engagement.R - used to analyse student engagement with each module
	


- The `reports` folder contains the `R Notebook` files that was used to generate some of the EDA analysis 
outputs with `.nb.html` extension names. The report folder also contain data profiling reports, generated
using `DataExplorer` package in R for all the 7 Open University Learning Analytics data sets. It also 
contains other data profiling reports for new data sets created during data mining. Other files and R 
Notebooks contain different aspects of data analysis and data mining processes carried out. The data 
profiling reports for the respective data sets are named according to the data sets and have `.html` 
extension. 
	

The `modifiedStudentInfo.html` contains the data profiling report for corresponds to the `studentInfo`
excluding the demographic data, hence the name. The `assessments.html`, `courses.html`, `vle.html`, 
`studentAssessment.html`, `studentRegistration.html` and `studentVle.html` contain data profiling report 
for the `assessments`, `courses`, `vle, `studentAssessment`, `studentRegistration` and `studentVle` data 
sets respectively.


- The `src` folder contains all the source codes used for different aspects of the project. Each file 
contains source code for a specific aspect of the project and the files are named accordingly. The files 
include:
	eda.R - this is the default file contained in ProjectTemplate and does not contain code for the project.
	eda_1.R - this contains code for a different aspect of the EDA.
	Project_EDA.R - this contains the R source code that was used to carry out exploratory data analysis for 
			the entire project. Also serves the purpose of providing all the EDA source codes in one 
			file along with codes for creating data profiling reports.
			To better understand the values in the EDA section of the group project report, a 
			combination of the values generated from `Project_EDA.R` script and the contents of the 
			corresponding data profiling reports in the `reports` folder for each data set is required.
	Group8_data_analysis_profiling_report_script.R - contains code for generating the data profiling report
									only.
	Modules_vs_Attainment_Group8.R - this contains the R source code used to compare the final result of 
						students based on their modules and courses as well as the possible impact
						of other factors on their final results.
	activity_mean_click_passPercentage.r - this contains script for analysing student engagement with module
							based on the number of clicks.
	activity_num_passPrecentage.r - this analyses the pass rate of students within each module based on their 
						engagement with the VLE.
	clicks.r - this analyses the impact of the number of studied credits on the final results of the students.
	eda.r - this contains more code for specific EDA	
	Mean click num of Distinction student.R - this analyses the learning behaviour of students with distinction
								through their engagement with the virtual learning environmnet. 
	try_timeseries.R - this contains code for a time series approach to data analysis.
	Rewarding_Activities.R - this analyses the types of activities that students engaged with most, for 
					example, top 20.


These files will not be executed automatically when the project is loaded, so would need to be manually executed 
using the base R `source` function (see section on "How to Run This Project", below) as they contain two lines of 
code that would make that possible which is `library(ProjectTemplate)` and `load.project`. 

The execution of these scripts using `source()` would lead to the production of a variety of output ranging 
from outputs printed to the console, .csv files to .html data profiling reports.



#####	 Other Project Folders  ######
####################################

`Predictive_Modelling` 
	- This contains the classification files, confusion matrices and images produced using KNIME during
	the predictive modelling (classification). 


`Power BI`
	- This folder contains the data visualisations and the interactive dashboards produced using Power BI.
	It also contains all the images of the graphs produced as well as the associated Python Notebooks.




#####	 Transformed Data Sets Used for Power BI Dashboard   ######
#################################################################

`student_activity.csv`
	- The purpose was to provide the number of clicks for each type of activity within the Virtual
	learning environment carried out by  student registered on a specific module and presentation.

`PCA_results.csv`
	- This serves the purpose of providing Principal Component Analysis (PCA) co-ordinates and 
	K-Means clustering for 7 types of activities within the virtual learning evvironment namely:
	quiz, oucontent, externalquiz, ouwiki, url, forumng and, homepage.

`Student_data_1.csv`
	- The data set provides the percentage score of the students and columns for unique identifiers.

`Engagement_per_module_over_time.csv`
	- This provides data used to compare the the engagement of students (number of clicks) between
	modules.

`pres_specific_assessment_dates.csv`
	- The purpose of this new data set was to provide the assessment dates for each module and 
	presentation.

`mean_number_of_clicks_per_credit.csv
	- The purpose of this data set was to provide the total number of clicks per student.
 


#####	 Project Tools and Packages for Data Analysis   ######
############################################################

#### Programming Language and IDE

	- R
	- RStudio
	- Python


#### R Packages

	- ProjectTemplate
	- knitr
	- dplyr
	- readr
	- factoextra
	- rstatix
	- survival
	- tidyr
	- plyr
	- psych
	- DataExplorer


#### R Packages for data visualisation 

	- ggplot2
	- ggvis
	- patchwork
	- treemapify
	- plotrix


#### Version Control and Collaboration

	- GitHub
	- Git


#### Interactive Data Visualisation and Dashboards

	- Microsoft Power BI


#### Analytics and Machine Learning Platform 

	- KNIME (Konstanz Information Miner) Analytics Platform

 

#####	 Installation Instructions For R  #####
#############################################

Note: No server installation or set up is required for this project to be executed succesfully. Only 
	the software and packages listed below are needed.


- The first step is to download and install R and RStudio

- After installing R and RStudio, open RStudio and install the packages from the R packages list that are 
not already installed. 

- For `dplyr`, `readr` and `ggplot2`, either install these libraries individually or simply install the 
`tidyverse` package which contains all three libraries among other libraries.


Note: If the Project Tools and Packages for Data Analysis are already installed on your local machine, 
	please ensure their latest versions are used to run this project.



#####	 Installation Instructions For Microsoft Power BI Desktop  #####
######################################################################

The Power BI Desktop is needed to view the dashboards. These are the files with `.pbix` extension in the 
`graphical_analysis` folder within the repository.

Microsoft Power BI Desktop can be freely downloaded from Microsoft website using the link below:
			https://powerbi.microsoft.com/en-us/downloads/ 
							OR
			https://powerbi.microsoft.com/en-us/desktop/

For the installation, follow the installation instructions on the Microsoft website.



#####	 KNIME Installation Instructions   #####
##############################################

KNIME is required in order to view the classification files. These are the files with `.knwf` extension in 
the `Classification predicting student pass fail` within the repository.

KNIME software can be freely downloaded from the wesbsite listed below.
			https://www.knime.com/downloads

After the download, follow the installation instructions KNIME on the KNIME website.



#####	 Optional Installation Instructions   #####
#################################################

This installation is optional since it is not needed for the project to run properly. It only serves the 
purpose of version control.


- Git installation. If you are using Windows, download `git` for windows from https://gitforwindows.org/ 
and follow the instructions for installation. If you are using Mac or Linux, download  `git` from 
https://git-scm.com/downloads and follow the instructions for installation.



#####	 How to Run The This Project  #####
#########################################

- Download/Clone the `Project` folder.
- Save this `Project` folder to any desired location and make a note of it. 
- Open up a new script within RStudio.
- Within the empty script, load this project by first using the `setwd()` function to set the Project as 
  your working directory by passing the path of the saved `Project` folder as an argument, example, 
  setwd("C:me/myself/and_I/Project") and ensure the code is executed. In doing so the project path has 
  been set as the working directly in RStudio. 
- Confirm that the project has been set as the working directory using the `getwd()` function. The output 
  of this functions should show the file path that was passed to the `setwd()`.
- Then run the following two lines of R code to load the `ProjectTemplate` library and load the project:

	`library('ProjectTemplate')`
	
	`load.project()`
  
After running the second code, a series of automated messages will be printed out as the project is being 
loaded. After the project has been loaded, signified by the end of the message, you can explore the files
contained in the ProjectTemplate folders and execute any desired codes.
 

Congratulations, you have successfully loaded and executed the project!




- To run the scripts in the s`src` folder that are not automatically executed when the `load.project()` 
function is called, go the console, at the bottom left of the screen in RStudio and type 
				
							`source("src/fileName.R")`

(replace `fileName` with the name of the script you wich to execute, for example, `Project_EDA.R`),then 
press enter. 

There is no required order to the execution of the scripts as each script runs independent of the others.
 


#####	 Project Credits	  #####
###############################

Special thanks to Dr Matthew Forshaw and Dr Huizhi Liang for providing a platform and opportunity to:
- Learn different theoretical concepts that aid in skill acquisition.
- To foster team work by working as a group. 
- To gain and reflect on the experience of applying the techniques taught in preceding modules to develop 
a data science system.


Thanks to our demonstrator Marco John Lewis who were always ready to lend a helping hand and provide 
direction when it was needed.



#####	 License   ######
#######################

No license is required for any portion of this project to be used. Just an acknowledgement of the project 
authors will do.



#####	 Group Members  ######
############################

Carter Mark Buckner Levy
Chinomnso Ugochi Ekwedike
Yingxi Wang
Iro Chalastani-Patsioura
Harry Patria
Vishesh Gupta

