#Read GDP data & look at the first 10 lines to get an idea.
GDP_data_clean <- read.csv("GDP_data.csv", stringsAsFactors = FALSE, header = FALSE)
str(GDP_data_clean)

#Remove the rows that are part of the header or description of data itself. 
GDP_data_clean <- GDP_data_clean[6:220, 1:5]
#3rd column is empty remove it
GDP_data_clean <- GDP_data_clean[, -3]

# Change to more suitable Row and column names
names(GDP_data_clean) <- c("CountryCode", "Ranking", "Country", "US$(millions)")
rownames(GDP_data_clean) <- 1:nrow(GDP_data_clean)
str(GDP_data_clean)

#Remove the Rows with empty ranking. 
empty_ranking <- which(GDP_data_clean$Ranking == '')
length(empty_ranking)
empty_ranking
GDP_data_clean <- GDP_data_clean[(-1*empty_ranking),]

#last 5 rows have description on specific countries, we dont want them for the analysis, remove them
str(GDP_data_clean)
head(GDP_data_clean, 10)

#Examine the second dataset Education_data.csv
Education_data_clean <- read.csv("Education_data.csv", stringsAsFactors = FALSE, header = TRUE)
Education_data_clean <- Education_data_clean[, 1:3]
str(Education_data_clean)
head(Education_data_clean, 10)


