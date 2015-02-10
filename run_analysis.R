library(data.table)
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
  download.file(url, destfile="getdata_projectfiles_UCI HAR Dataset.zip", method = "curl", mode = "wb")
  unzip("getdata_projectfiles_UCI HAR Dataset.zip")
}

activity_labels <- read.table("UCI HAR Dataset//activity_labels.txt",sep=" ",header = F)
activity_labels <- setNames(activity_labels, c("label", "activity"))

features <- read.table("UCI HAR Dataset//features.txt",sep="",header = F)
features <- setNames(features, c("featurenr", "featurename"))
         
test_subject <-read.table("UCI HAR Dataset/test/subject_test.txt",sep=" ",header = F)
test_subject <- setNames(test_subject, "subjectnr")

test_X <-read.table("UCI HAR Dataset/test/X_test.txt",sep="",header = F)
test_X <- setNames(test_X, features$featurename)
test_Y <-read.table("UCI HAR Dataset/test/y_test.txt",sep="",header = F)
test_Y <- setNames(test_Y, "label")
testdata <- cbind(test_subject, test_Y, test_X)

train_subject <-read.table("UCI HAR Dataset/train/subject_train.txt",sep="",header = F)
train_subject <- setNames(train_subject, "subjectnr")
train_X <-read.table("UCI HAR Dataset/train/X_train.txt",sep="",header = F)
train_X <- setNames(train_X, features$featurename)
train_Y <-read.table("UCI HAR Dataset/train/y_train.txt",sep="",header = F)
train_Y <- setNames(train_Y, "label")
traindata <- cbind(train_subject, train_Y, train_X)

result <- rbind(testdata,traindata)
r <- merge(result, activity_labels, by="label",all.x=T)
r <- r[,c(2, 564, 3:563), drop=F]

answer_df1 <- r[,c(1,2,grep("std", colnames(r)), grep("mean", colnames(r)))]
write.table(answer_df1, "answer_df1.txt",row.name=FALSE)

answer_df1$subjectnr <- as.factor(answer_df1$subjectnr)
answer_df1 <- data.table(answer_df1)
answer_df2 <- aggregate(. ~subjectnr + activity, answer_df1, mean)
write.table(answer_df2, "answer_df2.txt",row.name=FALSE)

