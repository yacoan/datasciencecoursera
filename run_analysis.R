#setwd("C:/Users/js1/Dropbox/SAS/Courses/Coursera/Getting and Cleaning Data/3 Lesson/UCI HAR Dataset")

# Source of data for the project:
# Getting and Cleaning Data Assigment

#Preparation Step, Read Test and Train Data
subject_test  <- read.table("./test/subject_test.txt",header=FALSE,sep="")
subject_train <- read.table("./train/subject_train.txt",header=FALSE,sep="")
Data_Test <- read.table("./test/X_test.txt",header=FALSE,sep="")
Data_Train <- read.table("./train/X_train.txt",header=FALSE,sep="")
Label_Test   <- read.table("./test/y_test.txt",header=FALSE,sep="")
Label_Train  <- read.table("./train/y_train.txt",header=FALSE,sep="")

#Uses descriptive activity names to name the activities in the data set
activity_names <- read.table("./activity_labels.txt",header=FALSE,sep="")

Label_Test$V1  <- factor(Label_Test$V1 , levels=activity_names$V1, labels = activity_names$V2)
Label_Train$V1 <- factor(Label_Train$V1, levels=activity_names$V1, labels = activity_names$V2)

#Appropriately labels the data set with descriptive activity names. 
feature_names <- read.table("./features.txt",header=FALSE,colClasses="character")
#head(feature_names)

colnames(Data_Test)  <- feature_names$V2; #names(Data_Test)
colnames(Data_Train) <- feature_names$V2; #names(Data_Train)

colnames(subject_test)  <- c("Subject");   #names(subject_test)
colnames(subject_train) <- c("Subject");   #names(subject_train)
colnames(Label_Test)    <- c("Activity");  #names(Label_Test)
colnames(Label_Train)   <- c("Activity");  #names(Label_Train)

#Merges the training and the test sets to create one data set.
All <- rbind(cbind(subject_train,Label_Train,Data_Train),cbind(subject_test,Label_Test,Data_Test))

#Extracts only the measurements on the mean and standard deviation for each measurement. 
All_mean <- sapply(All[feature_names$V2],mean,na.rm=TRUE)
All_std  <-  sapply(All[feature_names$V2],sd,na.rm=TRUE)

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
library(data.table)
temp <- data.table(All)
TidyData <- temp[, lapply(.SD, mean), by=c("Subject", "Activity")]

#Print file
write.table(TidyData, file="./tidydata.txt", sep="\t", row.names=FALSE)
