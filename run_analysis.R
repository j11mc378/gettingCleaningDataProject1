run_analysis <- function() {
#Overall Approach:
#1) Focus on the train set data. We'll then repeat (inline) the steps on the test set data and merge them at the end.
#(Not sure how to merge the data set first without first doing other manipulations - e.g., adding yTrain data for #example)
#
#2) Start by reading the key files into R
# - xTrain - contains the 561 features (each row belongs to an subject/individual and an activity)
# - yTrain - contains the activities (only the ID of activities, not the names)
# - subject_Train - contains the subject (individuals) identifiers
#
# These three ^ files correspond to each other based on each row. That is, 
# the first row in xTrain corresponds to the first row in yTrain and subject_Train
#
# - features - this includes the features that are calculated from the experiments. 
#   They are indexed 1-561 and correspond to each of the columns in the xTrain (same for xTest) #dataset.
# - activity_labels - includes the activity ID and corresponding activity name. This corresponds
#   to the yTrain (same for yTest) data set.
#
#3) Label the xTrain data with the proper column names taken from "features" 
#[This accomplishes Task 4 in the project requirements]
#
#4) Subset the xTrain data to only leave the mean and standard deviation measures (columns)
#[This accomplishes Task 2 in the project requirements]
#
#5) Add to the xTrain the activity Labels (from "yTrain" and "activity_labels")
#[This accomplishes Task 3 in the project requirements]
#
#6) Add to the xTrain the subject idenfitication (from "subject_train")
#
#7) Merge the xTrain and the xTest data sets (which already have the labels, etc)
#[This accomplishes Task 1 in the project requirements]
#
#8) Create a second, independent tidy data set with the average of each variable for each activity and each subject.
#[This accomplishes Task 5 in the project requirements]

####
##Execution of Steps:
###

#2) - Read in key files:
  #X_train is the train set. X_Test is the test set.
  #This is the "feature vector" which has 561 variables
  #Each row contains 561 variables
  xTrain <- read.table("UCI HAR Dataset/train/X_train.txt", sep="", header = FALSE)
  xTest <- read.table("UCI HAR Dataset/test/X_test.txt", sep="", header = FALSE)
  
  #y_train are the labels for the activities. Each row contains the activity. Do for both train and test.
  #Set the activityID as column to be easily merged with activity_labels later on
  yTrain <- read.csv("UCI HAR Dataset/train/y_train.txt", sep=" ", header = FALSE, col.names = "ActivityID")
  yTest <- read.csv("UCI HAR Dataset/test/y_test.txt", sep=" ", header = FALSE, col.names = "ActivityID")
  
  #read subject train - the subject identifiers. Give column name for later merging. Do for train and test sets.
  subjectTrain <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep=" ", header = FALSE, col.names = "subjectID")
  
  subjectTest <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep=" ", header = FALSE, col.names = "subjectID")
  
  #Load the other data such as the features and the activity names - This only needs to happen once as it applies
  #the same to both train and test data
  features <- read.table("UCI HAR Dataset/features.txt", col.names = c("index", "variables"))
  
  #read in the activity labels. Give it appropriate column names for merging.
  activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("ActivityID","ActivityName"))

#3) - Add appropriate column names from "features" to the xtrain data
  #make a copy of Xtrain data to make some changes. This will end-up being the full set after the transformations.
  final_xTrain <- xTrain
  final_xTest <- xTest
  
  #Update the column names based on the features variables
  colnames(final_xTrain) <- features$variables
  colnames(final_xTest) <- features$variables

#4) Subset the xTrain data to only leave the mean and standard deviation measures (columns)
  #do the same for xTest data
  #[This accomplishes Task 2 in the project requirements]
  #Reviewed the data set and found the specific columns that relate to mean and std dev (66 columns found)
  meanStdColumns <- c(1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 
                      240:241,253:254, 266:271,345:350,424:429,503:504,516:517,529:530,542:543)
  
  final_xTrain <- final_xTrain[, meanStdColumns]
  final_xTest <- final_xTest[, meanStdColumns]
  

#5) Add the xTrain the activity Labels (from "yTrain" and "activity_labels")
#[This accomplishes Task 3 in the project requirements]
  #combine the activities with the ytrain data - yTrainLabeled
  yTrainLabeled <- merge(yTrain, activityLabels, by = "ActivityID")
  yTestLabeled <- merge(yTest, activityLabels, by= "ActivityID")

  #add the activity (ID and name) to the xTrain data and test data. Remove the ID afterwards to comply with tidy set.
  final_xTrain <- cbind(yTrainLabeled, final_xTrain)
  final_xTrain <- subset(final_xTrain, select = -c(ActivityID)) #Remove the ID to keep only the name - for tidy set
  
  final_xTest <- cbind(yTestLabeled, final_xTest)
  final_xTest <- subset(final_xTest, select = -c(ActivityID))#Remove the ID to keep only the name - for tidy set
  
#6) Add to the xTrain the subject idenfitication (from "subject_train")
  #Add the subject to the xTrain data
  final_xTrain <- cbind(subjectTrain, final_xTrain)
  final_xTest <- cbind(subjectTest, final_xTest)
 
#7) Merge the xTrain and the xTest data sets (which already have the labels, etc)
  fullDataSet <- rbind(final_xTest,final_xTrain)

#8) Create a second, independent tidy data set with the average of each variable for each activity and each subject.  #[This accomplishes Task 5 in the project requirements]
  library(dplyr)
  result <- fullDataSet %>% group_by(subjectID,ActivityName) %>% summarize_each(funs(mean))
  
  #write out the tidy data set
  write.table(result, file="tidy_result.txt", row.names = FALSE)
}
#tidy data
# Each variable forms a column
# Each observation forms a row
# Each table/file stores data about one kind of observation