### PLOT 4 ###

Sys.setlocale("LC_TIME", "ENG")

# 1) Checks whether we have the data set in the working directory and proceeds to download it and/or
# unzip it if necessary.

if(!file.exists("household_power_consumption.txt")) {
        if(!file.exists("household_power_consumption.zip")) {
                fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
                download.file(fileUrl, destfile="household_power_consumption.zip")
        }
        unzip("household_power_consumption.zip", files=c("household_power_consumption.txt"), junkpaths=TRUE)        
}

correct_names <- names(read.table(file="household_power_consumption.txt", header=TRUE, sep=";",
                                  na.strings="?", nrows=2))

# 2) Reads the data set into R. I've manually calculated the number of rows to skip - not very elegant but effective!
really_big_table <- read.table(file="household_power_consumption.txt", header=FALSE, sep=";",
                               na.strings="?", stringsAsFactors=FALSE, skip=66637, nrows=2880)

names(really_big_table) <- correct_names

# 2a) Creates an extra column with date/time objects.

library(dplyr)

new_frame <- mutate(really_big_table, date_time_objects=paste(Date, Time))

new_frame$date_time_objects <- as.POSIXlt(new_frame$date_time_objects, format="%d/%m/%Y %H:%M:%S")

# 3) Builds the plot

png(filename="plot4.png", width=480, height=480, units="px", bg="transparent")
par(mfrow=c(2,2))

plot(x=new_frame$date_time_objects, y=new_frame$Global_active_power, type="l", 
     xlab="", ylab="Global Active Power")

plot(x=new_frame$date_time_objects, y=new_frame$Voltage, type="l", 
     xlab="datetime", ylab="Voltage")

plot(x=new_frame$date_time_objects, y=new_frame$Sub_metering_1, type="l", 
     xlab="", ylab="Energy sub metering")
lines(x=new_frame$date_time_objects, y=new_frame$Sub_metering_2, type="l", 
      col="red")
lines(x=new_frame$date_time_objects, y=new_frame$Sub_metering_3, type="l", 
      col="blue")
legend(x="topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col=c("black", "red", "blue"), lwd=1, bty="n")

plot(x=new_frame$date_time_objects, y=new_frame$Global_reactive_power, type="l", 
     xlab="datetime", ylab="Global_reactive_power")

dev.off()
