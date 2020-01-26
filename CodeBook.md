---
title: "Cookbook"
author: "Lidwien van de Wijngaert"
date: "1/26/2020"
output: html_document
---

Using the assignment as a starting point, the script, called run_analysis.R does the following: 

0) Preliminary steps 
1) Reading and merging the data
2) Extract mean and standard deviation
3) Descriptive activity names 
4) Descriptive variable names are added 
5) Create a tidy dataset 

# Ad 0) Preliminary steps 

The data for this assignment can be found here: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

Information about the data can be found here: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

This step contains the following substeps: 

* The libraries that are needed are loaded
* The working directory is set
* The workspace is cleaned up
* The data is downloaded 
* The data is unzipped 

# Ad 1) Reading and merging the data
This step focusses on merging the training and the test sets to create one data set

* Read the files
        + Read training data into table
        + Read testing data into table
        + Read feature data into table
        + Read activity labels into table
* Assign column names to the tables
* Merge all data from train and test one single new table. 

# Ad 2) Extract mean and standard deviation
Extract only the measurements on the mean and standard deviation for each measurement
* Read column names from the complete dataset
* Create vector for defining ID, mean and standard deviation:
* Make the subset from tbl_trainTest by using val_meanStDev

# Ad 3) Descriptive activity names 
In this step descriptive activity names to name the activities in the data set are added. 

* Add a new column to setWithActivityNames that contains the descriptive column name based on activityID. 

# Ad 4) Descriptive variable names are added 

In step 1 variable names are allready added. 

# Ad 5) Create a tidy dataset 
From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
* Making a second tidy data set
* Aggregate (using the mean) the data for each respondent and activitiy 
* Sort the data using SubjectId (first) and activityId (second)
* Write tbl_TidyData2 to a txt file

