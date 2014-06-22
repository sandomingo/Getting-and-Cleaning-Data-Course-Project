## some constants
dir.test <- "test/"
dir.train <- "train/"
filenames.feature <- "features.txt"
filenames.train <- paste(dir.train, c("subject_train.txt", "X_train.txt", "y_train.txt"), sep="")
filenames.test <- paste(dir.test, c("subject_test.txt", "X_test.txt", "y_test.txt"), sep="")


## load data from file
data.features <- read.csv(filenames.feature, header=FALSE, sep="")
# train data
data.train.subject <- read.csv(filenames.train[1], header=FALSE, sep="")
data.train.X <- read.csv(filenames.train[2], header=FALSE, sep="")
data.train.y <- read.csv(filenames.train[3], header=FALSE, sep="")
# test data
data.test.subject <- read.csv(filenames.test[1], header=FALSE, sep="")
data.test.X <- read.csv(filenames.test[2], header=FALSE, sep="")
data.test.y <- read.csv(filenames.test[3], header=FALSE, sep="")

## extract only the measurements on the mean and stand deviation for each measurement
features.extract.colNum <- grep("std\\(\\)|mean\\(\\)", data.features$V2)
features.extract.name <- data.features$V2[features.extract.colNum]
data.train.X.extract <- data.train.X[, features.extract.colNum]
data.test.X.extract <- data.test.X[, features.extract.colNum]

## merge the training and the test sets
data.all.subject <- rbind(data.train.subject, data.test.subject)
data.all.X <- rbind(data.train.X.extract, data.test.X.extract)
data.all.y <- rbind(data.train.y, data.test.y)

## descripe the activity name
activities <- factor(data.all.y$V1)
levels(activities) <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")

## merge all columns
data.all.all <- cbind(data.all.subject, activities, data.all.X)

## add labels for the data frame
names(data.all.all) <- c("Subject", "Activity", make.names(features.extract.name))

## create an tidy data set
endIndex.X.extract <- length(data.all.X) + 2
data.all.tidy <- aggregate(data.all.all[,3: endIndex.X.extract], by=list(Subject=data.all.all$Subject, Activity=data.all.all$Activity), mean)

## write new data set to file
write.table(data.all.tidy, "tidyData.txt", quote=FALSE)
