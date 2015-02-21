library(dplyr)
library(plyr)

run_analysis <- function() {
    # Read in data from file
    x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
    y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
    sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
    x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
    y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
    sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
    
    # Bind subjects, and activities to measurements
    test_dat <- cbind(sub_test, y_test, x_test)
    train_dat <- cbind(sub_train, y_train, x_train)
    
    # Combine test and train into single data set
    dat <- rbind(test_dat, train_dat)
    
    # Get descriptive column names, remove problematic characters, apply to dataset
    labels <- read.table("UCI HAR Dataset/features.txt", header = FALSE)[,2]
    labels <- sapply(labels, gsub, pattern = "-", replacement = "")
    labels <- sapply(labels, gsub, pattern = "\\(", replacement = "")
    labels <- sapply(labels, gsub, pattern = ")", replacement = "")
    labels <- sapply(labels, gsub, pattern = ",", replacement = "")
    names(dat) <- c("subject_id", "activity_id", as.character(labels))
    
    # Replace activity IDs with meaningful descriptions
    activity_map <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
    names(activity_map) <- c("activity_id", "activity")
    dat <- right_join(activity_map, dat)
    
    # Drop activity ID and reorder columns
    dat <- dat[,c(3,2,4:ncol(dat))]
    
    # Determine mean and standard deviation for each measurement, by subject_id
    mean_index <- sapply(names(dat), grepl, pattern = "mean", ignore.case = TRUE)
    sd_index <- sapply(names(dat), grepl, pattern = "std", ignore.case = TRUE)
    mean_sd_index <- mean_index | sd_index
    
    # Reduce data set to subject_id, activity and columns involving mean and st dev
    mean_sd_index[1:2] <- TRUE
    ms_dat <- dat[,mean_sd_index]
    
    # Calculate mean of each measurement for each combination of subject and activity
    tidy_dat <- ddply(ms_dat, .(subject_id, activity), numcolwise(mean))
}