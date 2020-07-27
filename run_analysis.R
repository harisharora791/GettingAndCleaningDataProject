## Before we start -
## It is a common practice in ML to break up the dataset into train, eval and test buckets.
## This excercise wants us to do the opposite. Not sure why

## Set working dir to project home dir
projectdir <- "/Users/Harish/Git/wearables_tidy_data"
setwd(projectdir)
library(dplyr)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file <- "dataset.zip"
datasetdir <- "UCI HAR Dataset"

## download the file if it does not already exist
if (!file.exists(file) && !dir.exists("datasetdir")) {
  download.file(url, file, method="curl")
  unzip(file)
}

## change dir to featureset dir so we don't have to type the dir name everytime
setwd(datasetdir)

## Read the files and create data tables
featureset <- read.table("features.txt", col.names = c("featurenumber","featurename"))
testset_x <- read.table("test/X_test.txt", col.names = featureset$featurename)
testset_y <- read.table("test/y_test.txt", col.names = "code")
trainset_x <- read.table("train/X_train.txt", col.names = featureset$featurename)
trainset_y <- read.table("train/y_train.txt", col.names = "code")

activityset <- read.table("activity_labels.txt", col.names = c("activitycode", "activitydescription"))
testsubjectset <- read.table("test/subject_test.txt", col.names = "subject")
trainsubjectset <- read.table("train/subject_train.txt", col.names = "subject")


## Merge the train, test and subject data sets
fullset_x <- rbind(trainset_x, testset_x)
fullset_y <- rbind(trainset_y, testset_y)
fullset_subject <- rbind(trainsubjectset, testsubjectset)

## combine all columns to create one full set
fullset <- cbind(fullset_subject, fullset_y, fullset_x)

## Focus on mean and standard deviation for each measurement.
summaryset <- fullset %>% select(subject, code, contains("mean"), contains("std"))

## Use activity names from activityset to name the activities in the data set.
summaryset$code <- activityset[summaryset$code, 2]
names(summaryset)[2] = "activity"

## Fix the column names to all lower case descriptive words
names(summaryset)<-gsub("Gyro", "gyroscope", names(summaryset))
names(summaryset)<-gsub("Acc", "accelerometer", names(summaryset))
names(summaryset)<-gsub("Mag", "magnitude", names(summaryset))
names(summaryset)<-gsub("BodyBody", "body", names(summaryset))
names(summaryset)<-gsub("^f", "frequency", names(summaryset))
names(summaryset)<-gsub("^t", "time", names(summaryset))
names(summaryset)<-gsub("-mean()", "mean", names(summaryset), ignore.case = TRUE)
names(summaryset)<-gsub("tBody", "timebody", names(summaryset))
names(summaryset)<-gsub("angle", "angle", names(summaryset))
names(summaryset)<-gsub("-std()", "std", names(summaryset), ignore.case = TRUE)
names(summaryset)<-gsub("gravity", "gravity", names(summaryset))
names(summaryset)<-gsub("-freq()", "frequency", names(summaryset), ignore.case = TRUE)

## Create another table with the average of each variable for each activity and each subject.
finalsummary <- summaryset %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean))

## Depending on the requirement, write the finalsummary table
setwd(projectdir)
write.table(finalsummary, "final_summary.csv", row.name=FALSE)