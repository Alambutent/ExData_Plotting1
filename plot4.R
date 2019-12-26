##### Plot4 - 2x2 Plot #####

# require packages for readr, dplyr, etc.
require(tidyverse)
# require lubridate for date conversions
require(lubridate)

# Create a temporary file to handle the zipped folder
temp <- tempfile()

# Download the the zipped folder to the temp file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)

# Read the text file that is in the temp file, specifying the semicolon delimiter and 
# that NA values are logged as '?' so they can be ignored.
df <- read_delim(unz(temp, "household_power_consumption.txt"),delim=';',na=c('','?'))

# Delete the temporary file
unlink(temp)

# Use the lubridate dmy() function to convert dates to proper format
df$Date <- dmy(df$Date)

# Filter on only the two dates that we are concerned with, and combine the date and time columns
# to create a datetime column for plotting
df_filter <- df %>%
  filter(Date=='2007-02-01' | Date=='2007-02-02') %>% 
  mutate(datetime = as.POSIXct(paste(Date,Time), format='%Y-%m-%d %H:%M:%S'))


#### Create the 2x2 plot graphic #### 
# containing (row-wise from top-left) global active power over time, voltage over time,
# energy sub metering over time, and global reactive power over time

# Set up the plotting area for all 4 graphics
png(filename='plot4.png', width=480, height=480)
par(mfrow=c(2,2))

# Top-Left: global active power
plot(df_filter$datetime,df_filter$Global_active_power, type='l',ylab='Global Active Power',xlab='')

# Top-Right: voltage
plot(df_filter$datetime,df_filter$Voltage, type='l',ylab='Voltage',xlab='datetime')

# Bottom-Left: energy sub metering
plot(df_filter$datetime,df_filter$Sub_metering_1, type='l',ylab='Energy sub metering',xlab='')
lines(df_filter$datetime,df_filter$Sub_metering_2, col='red')
lines(df_filter$datetime,df_filter$Sub_metering_3, col='blue')
legend('topright',legend=c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),col=c('black','red','blue'),lwd=1)

# Bottom-Right: global reactive power
plot(df_filter$datetime,df_filter$Global_reactive_power, type='l',ylab='Global_reactive_power',xlab='datetime')
dev.off()