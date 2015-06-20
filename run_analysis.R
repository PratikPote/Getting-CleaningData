## Download and unzip the dataset
filename<-"data.zip"
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,filename)
unzip(filename)

# load activity labels and features
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activitylabels[,2] <- as.character(activity_labels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainLabels <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainLabels, train)
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testLabels, test)


# merge datasets and add labels
final<- rbind(train, test)
colnames(final) <- c("subject", "activity", featuresWanted.names)

# turn activities & subjects into factors
final$activity <- factor(final$activity, levels = activitylabels[,1], labels = activitylabels[,2])
final$subject <- as.factor(final$subject)

library(reshape2)
final.melted <- melt(final, id = c("subject", "activity"))
final.mean <- dcast(final.melted, subject + activity ~ variable, mean)

#creating tidy.txt
write.table(final.mean, "tidy.txt", row.names = FALSE, quote = FALSE)