# This script, called run_analysis.R does the following.
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Thanks to jcombardi on Github for much needed inspiration. 

# Load libraries
library(dplyr)

#Set working directory 
setwd("~/Desktop/R/Course3/GettingAndCleaningData")

# Clean up workspace
rm(list=ls())

# -----------------------------
# Step 0 - Downloading the data
# -----------------------------

if(!file.exists("./data")){dir.create("./data")}
# Assign location of the data to fileURL and download the zip file. 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet in /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#---------------------------------------------------------------------
# Step 1. Merges the training and the test sets to create one data set
#---------------------------------------------------------------------

# 1.1 Read the files

# 1.1.1  Read training data into table
tbl_x_train       <- read.table("./data/UCI HAR Dataset/train/x_train.txt")
tbl_y_train       <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
tbl_subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# 1.1.2 Read testing data into table
tbl_x_test        <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
tbl_y_test        <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
tbl_subject_test  <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# 1.1.3 Read feature data into table
tbl_features      <- read.table('./data/UCI HAR Dataset/features.txt')

# 1.1.4 Read activity labels into table
activityLabels <- read.table('./data/UCI HAR Dataset/activity_labels.txt')

# 1.2 Assign column names to the tables

colnames(tbl_x_train) <- tbl_features[,2]
colnames(tbl_y_train) <-"activityId"
colnames(tbl_subject_train) <- "subjectId"

colnames(tbl_x_test) <- tbl_features[,2] 
colnames(tbl_y_test) <- "activityId"
colnames(tbl_subject_test) <- "subjectId"

colnames(activityLabels) <- c("activityId","activityType")

# 1.3 Merge all data from train and test one single new table. 
#     - Combine all trainings data (activityId, activityType and measurements)
#     - Combine all test data (activityId, activityType and measurements)
#     - Combine training and test data

tbl_all_train  <- cbind(tbl_y_train, tbl_subject_train, tbl_x_train)
tbl_all_test   <- cbind(tbl_y_test, tbl_subject_test, tbl_x_test)
tbl_trainTest  <- rbind(tbl_all_train, tbl_all_test)

#-----------------------------------------------------------------------------------------------
# Step 2. Extract only the measurements on the mean and standard deviation for each measurement
#-----------------------------------------------------------------------------------------------

# 2.1 Read column names from the complete dataset

val_colNames <- colnames(tbl_trainTest)

# 2.2 Create vector for defining ID, mean and standard deviation:
#     - grepl returns TRUE if a string contains the pattern, otherwise FALSE
#     - So the values in val_meanStDev are tru when the column name is 
#       activityId, subjectId or (|) contain mean or standard deviation. 

val_meanStDev <- (grepl("activityId" , val_colNames) | 
                          grepl("subjectId" , val_colNames) | 
                          grepl("mean.." , val_colNames) | 
                          grepl("std.." , val_colNames) 
)

count(val_meanStDev)

# The value "TRUE" is assigned 81 times. 

# 2.3 Make the subset from tbl_trainTest by using val_meanStDev

tbl_trainTestMeanStDev <- tbl_trainTest[ , val_meanStDev == TRUE]

# The table tbl_trainTestMeanStDev has 81 columns. 

#-------------------------------------------------------------------------------
# Step 3. Uses descriptive activity names to name the activities in the data set
#-------------------------------------------------------------------------------

# Add a new column to setWithActivityNames that contains 
# the descriptive column name based on activityID. 

tbl_trainTestMeanStDevActivityNames <- merge(tbl_trainTestMeanStDev, activityLabels,
                                             by='activityId',
                                             all.x=TRUE)

tbl_TidyData1 <- tbl_trainTestMeanStDevActivityNames[c(2,1,82,3:81)]
tbl_TidyData1 <- tbl_TidyData1[order(tbl_TidyData1$subjectId, tbl_TidyData1$activityId),]

#--------------------------------------------------------------------------
# Step 4. Appropriately labels the data set with descriptive variable names
#--------------------------------------------------------------------------

# In 1.1.3 the variable names were read 
# In 1.2 the variable names were assigned to the tables
# These variable names were used in further steps. 

#--------------------------------------------------------------------------
# Step 5. From the data set in step 4, create a second, 
#         independent tidy data set with the average of each variable 
#         for each activity and each subject.
#--------------------------------------------------------------------------

#5.1 Making a second tidy data set

# Aggregate (using the mean) the data for each respondent and activitiy 
tbl_TidyData2 <- aggregate(. ~subjectId + activityType, tbl_TidyData1, mean)

# Sort the data using SubjectId (first) and activityId (second)
tbl_TidyData2 <- tbl_TidyData2[order(tbl_TidyData2$subjectId, tbl_TidyData2$activityId),]

#5.2 Write  tbl_TidyData2 to a txt file

write.table(tbl_TidyData2, "tbl_TidyData2.txt", row.name=FALSE)


