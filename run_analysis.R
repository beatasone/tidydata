
library(dplyr)
library(plyr)
#read in train files, features and actvity files
trainsubject <- read.table("/Users/Amy/Datascience/datarun/train/subject_train.txt", sep = "")
trainactivity <- read.table("/Users/Amy/Datascience/datarun/train/y_train.txt", sep = "")
traindata <- read.table("/Users/Amy/Datascience/datarun/train/X_train.txt", sep = "")
features <- read.table("/Users/Amy/Datascience/datarun/features.txt", sep = "")
activity <- read.table("/Users/Amy/Datascience/datarun/activity_labels.txt", sep = "")
trainsubject <-  tbl_df(trainsubject)
trainactivity <-  tbl_df(trainactivity)
traindata <-  tbl_df(traindata)
features <-  tbl_df(features)
activity <-  tbl_df(activity)

#rename the columns in the feature dataframe and remove unwanted characters

features <- select(features, featurenum = V1, featurename = V2)
features$featurename <-gsub("[[:punct:]]", "", features$featurename, fixed = TRUE)
features$featurename <- make.names(features$featurename, unique = TRUE)

#create a vector datacolnames with unique values for feature name
datacolnames<-(features$featurename)


#change the colnames of the traindata set to match datcolnames
colnames(traindata)<-datacolnames


#add activityname to trainactivity to match activity number maintaining order
activity <- select(activity, activitynum = V1, activityname = V2)
trainactivity <- select(trainactivity, activitynum = V1)
trainactivity$id <- 1:nrow(trainactivity)
trainactivityname <- merge(trainactivity, activity, by.x = "activitynum", by.y = "activitynum", all.x=TRUE)
trainactivityname <-trainactivityname[order(trainactivityname$id),]


#add trainactivity data to traindata 
mergetraindataact <- cbind(trainactivityname$activityname, traindata)


#add trainsubject data to triandata 
trainsubject <- select(trainsubject, subject = V1)
traindatamerge <- cbind(trainsubject$subject, mergetraindataact)

#rename columns
names(traindatamerge)[1] <- "subject"
names(traindatamerge)[2] <- "activity"


#create a vector of feature names that include mean or std in the measurement name
fmatch <- c("mean", "std")
feattest <-grep(paste(fmatch, collapse = "|"), features$featurename, value = TRUE)
feattestmatch <- c(feattest)

#create finaltrain data dataframe with suject, activity and other variables that contain either mean or std
finaltraindata<- select(traindatamerge, subject, activity, contains("mean"), contains("std"))

#read in test files
testsubject <- read.table("/Users/Amy/Datascience/datarun/test/subject_test.txt", sep = "")
testactivity <- read.table("/Users/Amy/Datascience/datarun/test/y_test.txt", sep = "")
testdata <- read.table("/Users/Amy/Datascience/datarun/test/X_test.txt", sep = "")

testsubject <-  tbl_df(testsubject)
testactivity <-  tbl_df(testactivity)
testdata <-  tbl_df(testdata)


#change the colnames of the testdata set to match datcolnames
colnames(testdata)<-datacolnames


#add activityname to testactivity to match activity number maintaining order

testactivity <- select(testactivity, activitynum = V1)
testactivity$id <- 1:nrow(testactivity)
testactivityname <- merge(testactivity, activity, by.x = "activitynum", by.y = "activitynum", all.x=TRUE)
testactivityname <-testactivityname[order(testactivityname$id),]


#add testactivity data to testdata 
mergetestdataact <- cbind(testactivityname$activityname, testdata)


#add testsubject data to testdata 
testsubject <- select(testsubject, subject = V1)
testdatamerge <- cbind(testsubject$subject, mergetestdataact)

#rename columns
names(testdatamerge)[1] <- "subject"
names(testdatamerge)[2] <- "activity"

#create finaltest data dataframe with suject, activity and other variables that contain either mean or std
finaltestdata<- select(testdatamerge, subject, activity, contains("mean"), contains("std"))

#create new dataframe with train and test data combined
totaldata<- bind_rows(finaltraindata,finaltestdata)

totaldatagroup <- group_by(totaldata, subject, activity, add = FALSE)
finaltidydataset <- summarise_each(totaldatagroup, funs(mean))

write.table(finaltidydataset, "/Users/Amy/Datascience/datarun/finaltidydataset.txt", sep = " ", row.name=FALSE)