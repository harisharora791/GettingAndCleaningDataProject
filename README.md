
# Getting and Cleaning Data Course Project on Coursera
## By Harish Arora

## Project Instructions (Brief)
### Download data for the project
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### Create one R script called run_analysis.R that does the following.

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names.
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Solution

### Before we start -
It is common practice in ML to break up the dataset into train, eval and test buckets. This excercise wants us to do the opposite. Not sure why

### The Script has following logic

- Set working dir to project home dir
- Download and unzip the zip file if it does not already exist
- Unzip creates a new dir where all the data is kept. Change dir to that dir.
- Read the files and create following data tables
  - feature set table
  - test set X
  - test set Y
  - train set X
  - train set Y
  - activity set
  - test subject set
  - train subject set
 
 - use rbind to merge test and train sets for x, y and subject
 - create one big data set by combining all the sets using cbind
 - create a summary set by selecting only following columns
   - subject
   - code
   - other columns that contain 'mean' or 'std'
 - Use activity names from activityset to name the activities in the data set.
 - Fix the column names to all lower case descriptive words
 - Create another table with the average of each variable for each activity and each subject.
 - write the final summary table as csv file.
  
