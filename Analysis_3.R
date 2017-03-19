#Spread the IncomeGroup column.
names(merged_data_2_sorted) <- c("CountryCode", "Ranking", "Country", "GDPin$(millions)", "IncomeGroup")
merged_data_grp_by_income <- spread(merged_data_2_sorted, key = "IncomeGroup", value = "Ranking", fill = 0)
#seperate out the high income non OECD Income Group with non-zero values. Zero value means they dont belong 
#to this group.
nonOECD <- merged_data_grp_by_income[(merged_data_grp_by_income$`High income: nonOECD` != 0), 1:4]
nonOECD$`High income: nonOECD` <- as.numeric(nonOECD$`High income: nonOECD`)
avg_rank_of_nonOECD_income <- mean(nonOECD$`High income: nonOECD`)
avg_rank_of_nonOECD_income
#similarly separate out the OECD income group.
OECD <- merged_data_grp_by_income[(merged_data_grp_by_income$`High income: OECD` != 0), 1:5]
OECD$`High income: OECD` <- as.numeric(OECD$`High income: OECD`)
avg_rank_of_OECD_income <- mean(OECD$`High income: OECD`)
avg_rank_of_OECD_income