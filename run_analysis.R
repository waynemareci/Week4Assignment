#labels
features <- read.table("./data/features.txt")

#raw data into data.frame
x_train <- read.table("./data/x_train.txt")
y_train <- read.table("./data/y_train.txt")

#raw activity numbers into data.frame
x_test <- read.table("./data/x_test.txt")
y_test <- read.table("./data/y_test.txt")

#subjects indexes into data.frame
subject_test <- read.table("./data/subject_test.txt")
subject_train <- read.table("./data/subject_train.txt")

#merge data.frames
train <- cbind(subject_train,cbind(y_train,x_train))
test <- cbind(subject_test,cbind(y_test,x_test))

#give the columns meaningful names
names(train) <- c("subject","activity",features[,2])
names(test) <- c("subject","activity",features[,2])

# eliminate all but std and mean measurements
test_subset <- test[,c(1,2,grep("(mean|std)\\(\\)",names(test)))]
train_subset <- train[,c(1,2,grep("(mean|std)\\(\\)",names(train)))]

final <- rbind(train_subset,test_subset)

activity_labels <- read.table("./data/activity_labels.txt")

library(dplyr)
final <- mutate(final,activity=activity_labels[final$activity,2])

subject_activity_group <- group_by(final,subject,activity)
HumanActivityRecognition <- summarize_all(subject_activity_group,mean)
write.table(HumanActivityRecognition,row.names=F,file="HumanActivityRecognition.txt")