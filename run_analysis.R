##To download
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="C:/Users/Sebastian/Documents/Conferences, Competitions, Online Courses/Coursera/Getting and Cleaning Data/UCIHARDataset.zip")

##To run the files of activity names and activity labels
ActivityNames <- read.table("C:/Users/Sebastian/Documents/Conferences, Competitions, Online Courses/Coursera/Getting and Cleaning Data/UCI HAR Dataset/features.txt")
ActivityLabels <- read.table("C:/Users/Sebastian/Documents/Conferences, Competitions, Online Courses/Coursera/Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt")
ActivityNames[,2] <- as.character(ActivityNames[,2])
ActivityLabels[,2] <- as.character(ActivityLabels[,2])

##To extract the means and standard deviations only
MeanStd <- grep(".*mean.*|.*std.*", ActivityNames[,2])
MeanStdnames <- ActivityNames[MeanStd, 2]
MeanStdnames = gsub('mean', 'Mean', MeanStdnames)
MeanStdnames = gsub('-std', 'Std', MeanStdnames)
MeanStdnames <- gsub('[-()]', '', MeanStdnames)

##To load the datasets of training and set, together with their respective labels and subjects
Training <- read.table("C:/Users/Sebastian/Documents/Conferences, Competitions, Online Courses/Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt")[MeanStd]
Test <- read.table("C:/Users/Sebastian/Documents/Conferences, Competitions, Online Courses/Coursera/Getting and Cleaning Data/UCI HAR Dataset/test/X_test.txt")[MeanStd]
Trainlabels <- read.table("C:/Users/Sebastian/Documents/Conferences, Competitions, Online Courses/Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/y_train.txt")
Testlabels <- read.table("C:/Users/Sebastian/Documents/Conferences, Competitions, Online Courses/Coursera/Getting and Cleaning Data/UCI HAR Dataset/test/y_test.txt")
SubjectTrain <- read.table("C:/Users/Sebastian/Documents/Conferences, Competitions, Online Courses/Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt")
SubjectTest <- read.table("C:/Users/Sebastian/Documents/Conferences, Competitions, Online Courses/Coursera/Getting and Cleaning Data/UCI HAR Dataset/test/subject_test.txt")

##To merge the training and test datasets
Train <- cbind(SubjectTrain, Trainlabels, Training)
Test2 <- cbind(SubjectTest, Testlabels, Test)
Combine <- rbind(Train, Test2)
colnames(Combine) <- c("Subject", "Activity", MeanStdnames)

##To convert the activities and subjects into factors
library(reshape2)
Combine$Activity <- factor(Combine$Activity, levels=ActivityLabels[,1], labels=ActivityLabels[,2])
Combine$Subject <- as.factor(Combine$Subject)

Combine.melted <- melt(Combine, id=c("Subject", "Activity"))
Combine.mean <- dcast(Combine.melted, Subject + Activity ~ variable, mean)
write.table(Combine.mean, "tidy.txt", row.names=FALSE, quote=FALSE)


