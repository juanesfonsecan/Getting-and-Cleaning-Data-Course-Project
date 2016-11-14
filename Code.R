#Downloads the raw data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to the directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Reads the train tables
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reads the test tables
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reads feature vector
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reads activity labels
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Assigns columns names 
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#Merges the sets in a unique set, first by train and test
mtrain <- cbind(y_train, subject_train, x_train)
mtest <- cbind(y_test, subject_test, x_test)
bigset <- rbind(mtrain, mtest)

#take the data column names
colNames <- colnames(bigset)

#Vector with names with means and standard deviations
meanstd <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

#New set with only mean and std variables
setMeanAndStd <- bigset[ , meanstd == TRUE]

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

tidy <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
tidy <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

write.table(tidy, "tidy.txt", row.name=FALSE