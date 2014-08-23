library("reshape2")

# Data Directories
dataBaseDirectory <- "./UCI HAR Dataset/"
dataTestDirectory <- "./UCI HAR Dataset/test/"
dataTrainDirectory <- "UCI HAR Dataset/train/"

#Import data
activities <- read.table(paste0(dataBaseDirectory, "activity_labels.txt"), header=FALSE, 
                         stringsAsFactors=FALSE)
features <- read.table(paste0(dataBaseDirectory, "features.txt"), header=FALSE, 
                       stringsAsFactors=FALSE)

# Test Data Import & Prepare
subject_test <- read.table(paste0(dataTestDirectory, "subject_test.txt"), header=FALSE)
x_test <- read.table(paste0(dataTestDirectory, "X_test.txt"), header=FALSE)
y_test <- read.table(paste0(dataTestDirectory, "y_test.txt"), header=FALSE)
temp <- data.frame(Activity = factor(y_test$V1, labels = activities$V2))
testData <- cbind(temp, subject_test, x_test)

# Train Data Import & Prepare
subject_train <- read.table(paste0(dataTrainDirectory, "subject_train.txt"), header=FALSE)
x_train <- read.table(paste0(dataTrainDirectory, "X_train.txt"), header=FALSE)
y_train <- read.table(paste0(dataTrainDirectory, "y_train.txt"), header=FALSE)
temp <- data.frame(Activity = factor(y_train$V1, labels = activities$V2))
trainData <- cbind(temp, subject_train, x_train)

# Tidy Data
processed <- rbind(testData, trainData)
names(processed) <- c("Activity", "Subject", features[,2])
select <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
tidyData <- processed[c("Activity", "Subject", select)]

# Write Tidy Data
write.table(tidyData, file="./tidyData.txt", row.names=FALSE)

# Tidy Data Average/Activity. Melt and Cast.
tidyDataMelt <- melt(tidyData, id=c("Activity", "Subject"), measure.vars=select)
tidyDataMean <- dcast(tidyDataMelt, Activity + Subject ~ variable, mean)

# Write Tidy Average Data
write.table(tidyDataMean, file="./AverageData.txt", row.names=FALSE)
