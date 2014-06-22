# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.

## First merge the training set with the training labels

X_train <- read.table(".\\train\\X_train.txt")
Y_train <- read.table(".\\train\\y_train.txt")
subject_train <- read.table(".\\train\\subject_train.txt")
merged_train <- cbind(X_train, Y_train, subject_train)

X_test <- read.table(".\\test\\X_test.txt")
Y_test <- read.table(".\\test\\y_test.txt")
subject_test <- read.table(".\\test\\subject_test.txt")
merged_test <- cbind(X_test, Y_test, subject_test)

merged_data <- rbind(merged_test, merged_train)

# Extracts only the measurements on the mean and standard deviation for each 
# measurement. 

## Note that as part of this extraction, I only extracted items that explicitely
## included mean() or std() functinos as part of the column name.  Other similar 
## column names such as angle(X,gravityMean) or angle(tBodyAccMean,gravity) 
## where excluded as they are not explicit mean() or std() columns

features <- read.table(".\\features.txt")
labels <- c(as.character(features[,2]),"Activity ID", "Subject ID")
names(merged_data) <- labels

mean_std_measurement_data <- cbind(
        merged_data[,grep("mean()",colnames(merged_data))],
        merged_data[,grep("std()",colnames(merged_data))],
        merged_data$"Activity ID",
        merged_data$"Subject ID")


# Uses descriptive activity names to name the activities in the data set

## Although most descriptive names were imported in the last step, the last two
## need to be rewritten to make them simple to read and avoid escape characters
## per guidance in community boards.  

labels <- names(mean_std_measurement_data)
labels[length(labels)-1] <- "Activity ID"
labels[length(labels)] <- "Subject ID"
names(mean_std_measurement_data) <- labels


# Appropriately labels the data set with descriptive variable names. 

## The meaning of each of the column names for this data set can be found in 
## the code book; these column names are sufficiently descriptive per current
## guidance. For this step, renamed the Activity IDs to be more descriptive
## instead of ambiguous number IDs

WALKING <- mean_std_measurement_data$"Activity ID" == 1
WALKING_UPSTAIRS <- mean_std_measurement_data$"Activity ID" == 2
WALKING_DOWNSTAIRS <- mean_std_measurement_data$"Activity ID" == 3
SITTING <- mean_std_measurement_data$"Activity ID" == 4
STANDING <- mean_std_measurement_data$"Activity ID" == 5
LAYING <- mean_std_measurement_data$"Activity ID" == 6

mean_std_measurement_data$"Activity ID"[WALKING] <- "WALKING"
mean_std_measurement_data$"Activity ID"[WALKING_UPSTAIRS] <- "WALKING_UPSTAIRS"
mean_std_measurement_data$"Activity ID"[WALKING_DOWNSTAIRS] <- 
        "WALKING_DOWNSTAIRS"
mean_std_measurement_data$"Activity ID"[SITTING] <- "SITTING"
mean_std_measurement_data$"Activity ID"[STANDING] <- "STANDING"
mean_std_measurement_data$"Activity ID"[LAYING] <- "LAYING"


# Creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject. 

library(reshape2)

