# GettingAndCleaningData_Project
Course Project for Coursera's Getting and Cleaning Data

## Reading in raw data
run_analysis.R reads in  measurements, activity types, and subject IDs from "test" and "train" folders within the "UCI HAR Dataset" directory.

## Combining raw data
All "test" datasets are bound into a single data-frame, and all "train" datasets are bound into a single data-frame. These data frames are bound together to form a single table.

## Labels
Descriptive names are read in from the "features.txt" file within the "UCI HAR Dataset" folder. These names are cleaned of problematic characters. These labels, along with manually created labels for Subject ID and Activity ID are applied to the dataset using names().

## Meaningful activity names
Activity labels are read in from the "activity_labels.txt" file within the "UCI HAR Dataset" folder. The numeric IDs in this dataset are match the human-readable labels to the main dataset, but using an right_join on the main dataset's Activity IDs. The numeric IDs are removed and columns re-ordered for readability.

## Isolating relevant measurements
Measurements relating to mean or standard deviation are identified by searching the measurement labels for the terms "mean" or "std". The dataset is reduced to the Subject ID, Activity, and these columns.

## Performing mean calculations
ddply is used to apply a mean calculation to all measurements, aggregated by Subject ID and Activity type. A table containing these results is returned by the function.
