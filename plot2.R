##### Plot2 - Global Active Power Line Plot #####

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


#### Create the Global Active Power line plot png ####

# Initiate png graphic
png(filename='plot2.png', width=480, height=480)
# Plot to png
plot(df_filter$datetime,df_filter$Global_active_power, type='l',ylab='Global Active Power (kilowatts)',xlab='')
# Finish
dev.off()