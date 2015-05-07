### PLOT 1 ###

Sys.setlocale("LC_TIME", "ENG") ##This will fix the time language setting if your locale variables are 
## set to something other than English (as in my case) 


## 1) Checks whether we have the data set in the working directory and proceeds to download it and/or
## unzip it if necessary.

if(!file.exists("household_power_consumption.txt")) {
        if(!file.exists("household_power_consumption.zip")) {
               fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
               download.file(fileUrl, destfile="household_power_consumption.zip")
        }
   unzip("household_power_consumption.zip", files=c("household_power_consumption.txt"), junkpaths=TRUE)        
}

correct_names <- names(read.table(file="household_power_consumption.txt", header=TRUE, sep=";",
                                  na.strings="?", nrows=2))

## 2) Reads the data set into R. I've manually calculated the number of rows to skip - not very elegant but effective!

really_big_table <- read.table(file="household_power_consumption.txt", header=FALSE, sep=";",
                               na.strings="?", stringsAsFactors=FALSE, skip=66637, nrows=2880)

names(really_big_table) <- correct_names

## 2a) Creates an extra column with date/time objects.

library(dplyr)

new_frame <- mutate(really_big_table, date_time_objects=paste(Date, Time))

new_frame$date_time_objects <- as.POSIXlt(new_frame$date_time_objects, format="%d/%m/%Y %H:%M:%S")

## 3) Builds the plot

png(filename="plot1.png", width=480, height=480, units="px", bg="transparent")
hist(new_frame$Global_active_power, col="red", main="Global Active Power", 
     xlab="Global Active Power (kilowatts)")
dev.off()
