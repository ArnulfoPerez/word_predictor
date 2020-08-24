
fileURL = "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
dataFile ="./Data/dataset.zip"

if (!file.exists("./Data")) {dir.create("Data")}

if (!file.exists(dataFile)) {
  download.file(fileURL, destfile = dataFile , method = "curl")
  dateDownloaded <- date()
}

# Checking if final folder exists
if (!file.exists("final")) { 
  unzip(dataFile) 
}