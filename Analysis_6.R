merged_data_2_sorted$Ranking <- as.numeric(merged_data_2_sorted$Ranking)
gdp_Ranking_quantile <- cut(merged_data_2_sorted$Ranking, 
                            breaks = quantile(merged_data_2_sorted$Ranking, c(0, .20, .40, .60, .80, 1)), 
                            include.lowest=TRUE)
#List the income Group for each Ranking 
Ranking_per_incomeGrp <- aggregate(merged_data_2_sorted$IncomeGroup, list(Ranking = gdp_Ranking_quantile), FUN = list)
Ranking_per_incomeGrp1 <- Ranking_per_incomeGrp[,1]

#Aggregate the Income group, counting the number of entries in each Income group
Rank_gp1 <- aggregate(x = Ranking_per_incomeGrp$x[[1]], by = list(unique.values = Ranking_per_incomeGrp$x[[1]]), FUN = length)
Rank_gp2 <- aggregate(x = Ranking_per_incomeGrp$x[[2]], by = list(unique.values = Ranking_per_incomeGrp$x[[2]]), FUN = length)
Rank_gp3 <- aggregate(x = Ranking_per_incomeGrp$x[[3]], by = list(unique.values = Ranking_per_incomeGrp$x[[3]]), FUN = length)
Rank_gp4 <- aggregate(x = Ranking_per_incomeGrp$x[[4]], by = list(unique.values = Ranking_per_incomeGrp$x[[4]]), FUN = length)
Rank_gp5 <- aggregate(x = Ranking_per_incomeGrp$x[[5]], by = list(unique.values = Ranking_per_incomeGrp$x[[5]]), FUN = length)

#Spread the Income Groups, combine to list and aggregate the rows together.
r1 <- spread(Rank_gp1, key = "unique.values", value = "x", fill = 0)
r2 <- spread(Rank_gp2, key = "unique.values", value = "x", fill = 0)
r3 <- spread(Rank_gp2, key = "unique.values", value = "x", fill = 0)
r4 <- spread(Rank_gp2, key = "unique.values", value = "x", fill = 0)
r5 <- spread(Rank_gp2, key = "unique.values", value = "x", fill = 0)

l <- list(r1, r2, r3, r4, r5)
IncomeGrp <- data.table::rbindlist(l, fill = TRUE, use.names = TRUE, idcol= NULL)
Ranking_Vs_level_of_income_group <- cbind(Ranking_per_incomeGrp1 , IncomeGrp)
Ranking_Vs_level_of_income_group