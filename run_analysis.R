
#First of all, set working directory, change this path as neccessary to follow your working directory
setwd("C:/Rtraining1/R_MDec/Module3")


#STEP 1: Merges the training and the test sets to create one data set.

#create a folder name "assigment3" if doesn't exists
if(!file.exists("./assignment3")){dir.create("./assignment3")}

#download the data zip file and unzip it into folder just created above
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile="./assignment3/UCI_HAR_Dataset.zip")
unzip ("./assignment3/UCI_HAR_Dataset.zip", exdir = "./assignment3")

#construct a directory path to be used for reading the data files
data_path <- file.path("./assignment3" , "UCI HAR Dataset") 
files <-list.files(data_path, recursive=TRUE) 

subj_test <- read.table(file.path(data_path,"test", "subject_test.txt"), header = FALSE, sep="")
subj_train <- read.table(file.path(data_path,"train","subject_train.txt"), header = FALSE, sep="")
subj <- rbind(subj_test,subj_train)

y_test <- read.table(file.path(data_path,"test","y_test.txt"), header = FALSE, sep="")
y_train <- read.table(file.path(data_path,"train","y_train.txt"), header = FALSE, sep="")
data_y <- rbind(y_test,y_train)

#merge the test and train measurements into one single data set
X_test <- read.table(file.path(data_path,"test","X_test.txt"), header = FALSE, sep="")
X_train <- read.table(file.path(data_path,"train","X_train.txt"), header = FALSE, sep="")
data_x <- rbind(X_test,X_train)
#STEP 1 End



#STEP 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table(file.path(data_path, "features.txt"), header = FALSE, sep="",stringsAsFactors=FALSE)
mean_std <- features$V2[grep("(mean|std)",features$V2)]
#STEP 2 End



#STEP 3: Uses descriptive activity names to name the activities in the data set
activity <- read.table(file.path(data_path,"activity_labels.txt"), header = FALSE, sep="")
activity_label <- activity[match(data_y$V1, activity$V1), 2]
data_y[, 1] <- activity_label 
names(data_y) <- "activity"


    ###Another method to perform Step 3 and getting the same result
        #activity <- read.table(file.path(data_path,"activity_labels.txt"), header = FALSE, sep="")
        #activityLabel <- activity[data_y[, 1], 2] 
        #data_y[, 1] <- activityLabel 
        #names(data_y) <- "activity" 
#STEP 3 End



#STEP 4: Appropriately labels the data set with descriptive variable names
data_overall <- cbind(subj, data_y, data_x)
colnames(data_overall) <- c(c("volunteer", "activity"), features[,2])
selected_col <- c(c("volunteer", "activity"), mean_std)
data_overall <- subset(data_overall, select=selected_col)
#STEP 4 End



#STEP 5:From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data <- aggregate(. ~ volunteer+activity, data=data_overall, FUN=mean)
write.table(tidy_data, file = file.path(data_path, "tidy_data.txt"), row.name=FALSE)
#STEP 5 End



#Validate Result: Use the view command below to check the tidy_data output
check_tidy_data <- read.table(file.path(data_path,"tidy_data.txt"), header = TRUE, sep="")
View(check_tidy_data)


