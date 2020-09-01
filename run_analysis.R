### Preparing Data

filename <- "FinalTestData.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}


features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


#### 1. Merges the training and the test sets to create one data set

xdata<-rbind(x_train, x_test)

ydata<-rbind(y_train, y_test)

subjects<-rbind(subject_train, subject_test)

Data<-cbind(subjects, xdata, ydata)

#### 2. Extracts only the measurements on the mean and standard deviation 
####    for each measurement.

Data1 <-select(Data, subject, code, contains("mean"), contains("std"))

#### 3. Uses descriptive activity names to name the activities in the data set.

Data1$code <- activities[Data1$code, 2]

#### 4. Appropriately labels the data set with descriptive variable names.

names(Data1)[2] = "activity"

names(Data1)<-gsub("Acc", "Accelerometer", names(Data1))

names(Data)<-gsub("Gyro", "Gyroscope", names(Data1))

names(Data1)<-gsub("BodyBody", "Body", names(Data1))

names(Data1)<-gsub("Mag", "Magnitude", names(Data1))

names(Data1)<-gsub("^t", "Time", names(Data1))

names(Data1)<-gsub("^f", "Frequency", names(Data1))

names(Data1)<-gsub("tBody", "TimeBody", names(Data1))

names(Data1)<-gsub("-mean()", "Mean", names(Data1), ignore.case = TRUE)

names(Data1)<-gsub("-std()", "STD", names(Data1), ignore.case = TRUE)

names(Data1)<-gsub("-freq()", "Frequency", names(Data1), ignore.case = TRUE)

names(Data1)<-gsub("angle", "Angle", names(Data1))

names(Data1)<-gsub("gravity", "Gravity", names(Data1))

### 5. From the data set in step 4, creates a second, independent tidy data set 
### with the average of each variable for each activity and each subject.

Data2 <- Data1 %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

write.table(Data2, "Data2.txt", row.name=FALSE)




