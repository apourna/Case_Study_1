#seperate out low income, low middle and upper Middle Income. 
lowIncome <- merged_data_grp_by_income[(merged_data_grp_by_income$`Low income` != 0), 1:5]
lowMiddleIncome <- merged_data_grp_by_income[(merged_data_grp_by_income$`Lower middle income` != 0), 1:5]
upperMiddleIncome <- merged_data_grp_by_income[(merged_data_grp_by_income$`Upper middle income` != 0), 1:5]

#NOTE:Taking log(GDP) to fit into graphical scale better


#Option#1: Show all the countries using geometric points and callout country shortcode

plot <- ggplot(merged_data_2_sorted, 
               aes(x = merged_data_2_sorted$IncomeGroup, y = log(merged_data_2_sorted$`GDPin$(millions)`)))

plot + geom_point() + geom_text_repel(aes(color = merged_data_2_sorted$IncomeGroup, label=merged_data_2_sorted$CountryCode), size = 3)



#Option#2, create box plot to show the extreme values and where most of the GDP per income 
#group is concentrated.

plot + geom_boxplot(aes(fill = merged_data_2_sorted$IncomeGroup))