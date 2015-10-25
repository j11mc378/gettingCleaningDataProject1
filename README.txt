Overall Approach:
1) Focus on the train set data. We'll then repeat (inline) the steps on the test set data and merge them at the end.
(Not sure how to merge the data set first without first doing other manipulations - e.g., adding yTrain data for #example)

2) Start by reading the key files into R
- xTrain - contains the 561 features (each row belongs to an subject/individual and an activity)
- yTrain - contains the activities (only the ID of activities, not the names)
- subject_Train - contains the subject (individuals) identifiers

These three ^ files correspond to each other based on each row. That is, 
the first row in xTrain corresponds to the first row in yTrain and subject_Train

- features - this includes the features that are calculated from the experiments. 
  They are indexed 1-561 and correspond to each of the columns in the xTrain (same for xTest) #dataset.
- activity_labels - includes the activity ID and corresponding activity name. This corresponds
  to the yTrain (same for yTest) data set.

3) Label the xTrain data with the proper column names taken from "features" 
[This accomplishes Task 4 in the project requirements]

4) Subset the xTrain data to only leave the mean and standard deviation measures (columns)
[This accomplishes Task 2 in the project requirements]

5) Add to the xTrain the activity Labels (from "yTrain" and "activity_labels")
[This accomplishes Task 3 in the project requirements]

6) Add to the xTrain the subject idenfitication (from "subject_train")

7) Merge the xTrain and the xTest data sets (which already have the labels, etc)
[This accomplishes Task 1 in the project requirements]

8) Create a second, independent tidy data set with the average of each variable for each activity and each subject.
[This accomplishes Task 5 in the project requirements]

These steps have been added inline with the code.

The codebook provides all the other details about the data and the overall process.