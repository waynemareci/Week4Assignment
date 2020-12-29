#labels
features <- read.table("features.txt")

#activities
activity_labels <- read.table("activity_labels.txt")

#raw data into data.frame
x_train <- read.table("x_train.txt")
y_train <- read.table("y_train.txt")

#raw activity numbers into data.frame
x_test <- read.table("x_test.txt")
y_test <- read.table("y_test.txt")

#subjects indexes into data.frame
subject_test <- read.table("subject_test.txt")
subject_train <- read.table("subject_train.txt")

#merge data.frames
train <- cbind(subject_train,cbind(y_train,x_train))
test <- cbind(subject_test,cbind(y_test,x_test))

#give the columns meaningful names
names(train) <- c("subject","activity",features[,2])
names(test) <- c("subject","activity",features[,2])

#eliminate all but std and mean measurements
test_subset <- test[,c(1,2,grep("(mean|std)\\(\\)",names(test)))]
train_subset <- train[,c(1,2,grep("(mean|std)\\(\\)",names(train)))]

#combine test and train data 
final <- rbind(train_subset,test_subset)

library(dplyr)

#replace activity indexes with descriptive labels
final <- mutate(final,activity=activity_labels[final$activity,2])

#summarize data by averaging by subject and activity
subject_activity_group <- group_by(final,subject,activity)
HumanActivityRecognition <- summarize_all(subject_activity_group,mean)

#convert back to txt file
write.table(HumanActivityRecognition,row.names=F,file="HumanActivityRecognition.txt")