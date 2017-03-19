
merged_data_2 <- merge(GDP_data_clean, Education_data_clean, by = "CountryCode", all = FALSE)
str(merged_data_2)
head(merged_data_2, 5)

