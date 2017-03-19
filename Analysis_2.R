#Clean the GDP $ value such that the commas are removed
merged_data_2$`US$(millions)` <- gsub("[^[:digit:]]","", merged_data_2$`US$(millions)`)
merged_data_2$`US$(millions)` <- as.double(merged_data_2$`US$(millions)`)
merged_data_2_sorted <- merged_data_2[order(merged_data_2$`US$(millions)`, na.last = TRUE),]
merged_data_2_sorted <- merged_data_2_sorted[,-5]
row.names(merged_data_2_sorted) <- 1:nrow(merged_data_2_sorted)
head(merged_data_2_sorted, 20)
