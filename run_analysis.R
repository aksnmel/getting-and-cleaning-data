## Setting the working directory one folder up the folder containing
## the UCI HAR Dataset
setwd("/Users/MyPrinshu/data_science")

## Defining the path to the dataset to be used across the program
path_rf <- file.path("./data_cleanse","UCI HAR Dataset")
files <- list.files(path_rf,recursive=TRUE)
files

## Preparing the data as per the activity and its values. Hence the 
## Y series of data are the activities and the X series of data is the
## corresponding values for the activities.
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

## Features data
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

## The below will read the subject data i.e the people who have 
## underwent through the experiment
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

##Merges the training and the test sets to create one data set

##1.Concatenate the data tables by rows this is being done on basis
##  of the similar data i.e having the same set of columns to merge
## data row wise. 
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

##2.This step will provide column names to the data in the dataframes 
## given below
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

## 3.Merge columns to get the data frame Data for all data into 
## a single data frame
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

## Extracts only the measurements on the mean and standard deviation
## for each measurement
## 1.Subset Name of Features by measurements on the mean and 
## standard deviation i.e taken Names of Features with ?mean()? 
## or ?std()?
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

##Subset the data frame Data by seleted names of Features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

## Uses descriptive activity names to name the activities in the data set
## 1.Read descriptive activity names from ?activity_labels.txt?
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

## Appropriately labels the data set with descriptive variable names

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

##Creates a second,independent tidy data set and ouput it

library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)







