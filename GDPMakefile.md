# GDPMakefile
Asha Mohan  
3/19/2017  
This is a case study to analyse the Gross Domestic product data of countries around the world in the year 2012. The data
is pulled from worldbank.org. The information is scattered in 2 data files, one is the GDP ranking table and another is the FEDSTATS per country data file. The two files are analysed and a subset of the information required for the case study is pulled out and consolidated here. The project is using R for tidying data & analysis. As a first step, installing and loading libraries required for the analysis.

#Basic Setup for R

All the packages needs to be downloaded from the R CRAN repository


```r
chooseCRANmirror(graphics=FALSE, ind=1)
knitr::opts_chunk$set(echo = TRUE)
```

#Set the Working Directory

Working directory is set to the main project directory. Please edit it as required when the project is 
re-used.


```r
setwd("/Users/ASHMOHAN 1/Desktop/Data_Science/SMU_Term1_Doing_Data_science/Project_2_caseStudy/Case_Study_1")
```

#Install and load the required library for the project

Packages are downloaded to help tidy the data and analysis.

```r
source("packages_for_case_study.R", echo = TRUE, keep.source = TRUE)
```

```
## 
## > install.packages("downloader")
## 
## The downloaded binary packages are in
## 	/var/folders/4k/cs36rhxn4xn42ppsyxc894rr0000gn/T//RtmpcE8a1x/downloaded_packages
## 
## > install.packages("tidyr")
## 
## The downloaded binary packages are in
## 	/var/folders/4k/cs36rhxn4xn42ppsyxc894rr0000gn/T//RtmpcE8a1x/downloaded_packages
## 
## > install.packages("ggrepel")
## 
## The downloaded binary packages are in
## 	/var/folders/4k/cs36rhxn4xn42ppsyxc894rr0000gn/T//RtmpcE8a1x/downloaded_packages
## 
## > install.packages("ggplot2")
## 
## The downloaded binary packages are in
## 	/var/folders/4k/cs36rhxn4xn42ppsyxc894rr0000gn/T//RtmpcE8a1x/downloaded_packages
## 
## > library(downloader)
## 
## > library(ggplot2)
## 
## > library(ggrepel)
## 
## > library(tidyr)
```

#Downloading data

The data is in two seperate files in CSV format. Download both the files into local working directory and check if the download is successful. 

```r
#Download the data from worldbank
## @knitr download_data
download("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", destfile = "GDP_data.csv")
download("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", destfile = "Education_data.csv")

list.files()
```

```
##  [1] "Analysis_2.R"              "Analysis_3.R"             
##  [3] "Analysis_4.R"              "Analysis_5.R"             
##  [5] "Analysis_6.R"              "Case_Study_1.Rproj"       
##  [7] "DownloadData.R"            "Education_data.csv"       
##  [9] "GDP_data.csv"              "GDPMakefile_files"        
## [11] "GDPMakefile.html"          "GDPMakefile.md"           
## [13] "GDPMakefile.Rmd"           "Merged_data_Analysis.R"   
## [15] "packages_for_case_study.R" "README.html"              
## [17] "README.Rmd"                "Tidy_and_merge_datasets.R"
```

#Tidying the GDP and FEDSTATS data

The GDP dataset has the country code, Ranking , and GDP revenue in millions of US$. There are some rows at the beginning of the data set and at the end that has description of the data, we have cleaned them. Our interest is to take the data rows that have country, GDP and Ranking.
The second dataset has more detail information on each country. Pick the required data and ignore the rest. Finally merged both dataset with country code. 

```r
#Read GDP data & look at the first 10 lines to get an idea.
GDP_data_clean <- read.csv("GDP_data.csv", stringsAsFactors = FALSE, header = FALSE)
str(GDP_data_clean)
```

```
## 'data.frame':	331 obs. of  10 variables:
##  $ V1 : chr  "" "" "" "" ...
##  $ V2 : chr  "Gross domestic product 2012" "" "" "Ranking" ...
##  $ V3 : logi  NA NA NA NA NA NA ...
##  $ V4 : chr  "" "" "" "Economy" ...
##  $ V5 : chr  "" "" "(millions of" "US dollars)" ...
##  $ V6 : chr  "" "" "" "" ...
##  $ V7 : logi  NA NA NA NA NA NA ...
##  $ V8 : logi  NA NA NA NA NA NA ...
##  $ V9 : logi  NA NA NA NA NA NA ...
##  $ V10: logi  NA NA NA NA NA NA ...
```

```r
#Remove the rows that are part of the header or description of data itself. 
GDP_data_clean <- GDP_data_clean[6:220, 1:5]
#3rd column is empty remove it
GDP_data_clean <- GDP_data_clean[, -3]

# Change to more suitable Row and column names
names(GDP_data_clean) <- c("CountryCode", "Ranking", "Country", "US$(millions)")
rownames(GDP_data_clean) <- 1:nrow(GDP_data_clean)
str(GDP_data_clean)
```

```
## 'data.frame':	215 obs. of  4 variables:
##  $ CountryCode  : chr  "USA" "CHN" "JPN" "DEU" ...
##  $ Ranking      : chr  "1" "2" "3" "4" ...
##  $ Country      : chr  "United States" "China" "Japan" "Germany" ...
##  $ US$(millions): chr  " 16,244,600 " " 8,227,103 " " 5,959,718 " " 3,428,131 " ...
```

```r
#Remove the Rows with empty ranking. 
empty_ranking <- which(GDP_data_clean$Ranking == '')
length(empty_ranking)
```

```
## [1] 25
```

```r
empty_ranking
```

```
##  [1] 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207
## [18] 208 209 210 211 212 213 214 215
```

```r
GDP_data_clean <- GDP_data_clean[(-1*empty_ranking),]

#last 5 rows have description on specific countries, we dont want them for the analysis, remove them
str(GDP_data_clean)
```

```
## 'data.frame':	190 obs. of  4 variables:
##  $ CountryCode  : chr  "USA" "CHN" "JPN" "DEU" ...
##  $ Ranking      : chr  "1" "2" "3" "4" ...
##  $ Country      : chr  "United States" "China" "Japan" "Germany" ...
##  $ US$(millions): chr  " 16,244,600 " " 8,227,103 " " 5,959,718 " " 3,428,131 " ...
```

```r
head(GDP_data_clean, 10)
```

```
##    CountryCode Ranking            Country US$(millions)
## 1          USA       1      United States   16,244,600 
## 2          CHN       2              China    8,227,103 
## 3          JPN       3              Japan    5,959,718 
## 4          DEU       4            Germany    3,428,131 
## 5          FRA       5             France    2,612,878 
## 6          GBR       6     United Kingdom    2,471,784 
## 7          BRA       7             Brazil    2,252,664 
## 8          RUS       8 Russian Federation    2,014,775 
## 9          ITA       9              Italy    2,014,670 
## 10         IND      10              India    1,841,710
```

```r
#Examine the second dataset Education_data.csv
Education_data_clean <- read.csv("Education_data.csv", stringsAsFactors = FALSE, header = TRUE)
Education_data_clean <- Education_data_clean[, 1:3]
str(Education_data_clean)
```

```
## 'data.frame':	234 obs. of  3 variables:
##  $ CountryCode : chr  "ABW" "ADO" "AFG" "AGO" ...
##  $ Long.Name   : chr  "Aruba" "Principality of Andorra" "Islamic State of Afghanistan" "People's Republic of Angola" ...
##  $ Income.Group: chr  "High income: nonOECD" "High income: nonOECD" "Low income" "Lower middle income" ...
```

```r
head(Education_data_clean, 10)
```

```
##    CountryCode                    Long.Name         Income.Group
## 1          ABW                        Aruba High income: nonOECD
## 2          ADO      Principality of Andorra High income: nonOECD
## 3          AFG Islamic State of Afghanistan           Low income
## 4          AGO  People's Republic of Angola  Lower middle income
## 5          ALB          Republic of Albania  Upper middle income
## 6          ARE         United Arab Emirates High income: nonOECD
## 7          ARG           Argentine Republic  Upper middle income
## 8          ARM          Republic of Armenia  Lower middle income
## 9          ASM               American Samoa  Upper middle income
## 10         ATG          Antigua and Barbuda  Upper middle income
```

#Analysis of Merged Data

Several analysis done using the merged data.

##1 - Merge the data based on the country shortcode. How many of the IDs match?


```r
merged_data_2 <- merge(GDP_data_clean, Education_data_clean, by = "CountryCode", all = FALSE)
str(merged_data_2)
```

```
## 'data.frame':	189 obs. of  6 variables:
##  $ CountryCode  : chr  "ABW" "AFG" "AGO" "ALB" ...
##  $ Ranking      : chr  "161" "105" "60" "125" ...
##  $ Country      : chr  "Aruba" "Afghanistan" "Angola" "Albania" ...
##  $ US$(millions): chr  " 2,584 " " 20,497 " " 114,147 " " 12,648 " ...
##  $ Long.Name    : chr  "Aruba" "Islamic State of Afghanistan" "People's Republic of Angola" "Republic of Albania" ...
##  $ Income.Group : chr  "High income: nonOECD" "Low income" "Lower middle income" "Upper middle income" ...
```

```r
head(merged_data_2, 5)
```

```
##   CountryCode Ranking              Country US$(millions)
## 1         ABW     161                Aruba        2,584 
## 2         AFG     105          Afghanistan       20,497 
## 3         AGO      60               Angola      114,147 
## 4         ALB     125              Albania       12,648 
## 5         ARE      32 United Arab Emirates      348,595 
##                      Long.Name         Income.Group
## 1                        Aruba High income: nonOECD
## 2 Islamic State of Afghanistan           Low income
## 3  People's Republic of Angola  Lower middle income
## 4          Republic of Albania  Upper middle income
## 5         United Arab Emirates High income: nonOECD
```

189 observations are seen after merging the data based on country shortcode.

##2 Sort the data frame in ascending order by GDP (so United States is last). What is the 13th country in the resulting data frame?


```r
source("Analysis_2.R", echo = TRUE, keep.source = TRUE)
```

```
## 
## > #Clean the GDP $ value such that the commas are removed
## > merged_data_2$`US$(millions)` <- gsub("[^[:digit:]]","", merged_data_2$`US$(millions)`)
## 
## > merged_data_2$`US$(millions)` <- as.double(merged_data_2$`US$(millions)`)
## 
## > merged_data_2_sorted <- merged_data_2[order(merged_data_2$`US$(millions)`, na.last = TRUE),]
## 
## > merged_data_2_sorted <- merged_data_2_sorted[,-5]
## 
## > row.names(merged_data_2_sorted) <- 1:nrow(merged_data_2_sorted)
## 
## > head(merged_data_2_sorted, 20)
##    CountryCode Ranking                        Country US$(millions)
## 1          TUV     190                         Tuvalu            40
## 2          KIR     189                       Kiribati           175
## 3          MHL     188               Marshall Islands           182
## 4          PLW     187                          Palau           228
## 5          STP     186    S\xe3o Tom\xe9 and Principe           263
## 6          FSM     185          Micronesia, Fed. Sts.           326
## 7          TON     184                          Tonga           472
## 8          DMA     183                       Dominica           480
## 9          COM     182                        Comoros           596
## 10         WSM     181                          Samoa           684
## 11         VCT     180 St. Vincent and the Grenadines           713
## 12         GRD     178                        Grenada           767
## 13         KNA     178            St. Kitts and Nevis           767
## 14         VUT     177                        Vanuatu           787
## 15         GNB     176                  Guinea-Bissau           822
## 16         GMB     175                    Gambia, The           917
## 17         SLB     174                Solomon Islands          1008
## 18         SYC     173                     Seychelles          1129
## 19         ATG     172            Antigua and Barbuda          1134
## 20         LCA     171                      St. Lucia          1239
##           Income.Group
## 1  Lower middle income
## 2  Lower middle income
## 3  Lower middle income
## 4  Upper middle income
## 5  Lower middle income
## 6  Lower middle income
## 7  Lower middle income
## 8  Upper middle income
## 9           Low income
## 10 Lower middle income
## 11 Upper middle income
## 12 Upper middle income
## 13 Upper middle income
## 14 Lower middle income
## 15          Low income
## 16          Low income
## 17          Low income
## 18 Upper middle income
## 19 Upper middle income
## 20 Upper middle income
```


St. Kitts and Nevis is the 13th country when sorted in ascending order of GDP

However its seen that Grenada and St. Kitts and Nevis have the same GDP but they got arranged per the alphabetical order
Conclusion to the project. Summarize analysis.


##3 : What are the average GDP rankings for the "High income: OECD" and "High income: nonOECD" groups?


```r
source("Analysis_3.R", echo = TRUE, keep.source = TRUE)
```

```
## 
## > #Spread the IncomeGroup column.
## > names(merged_data_2_sorted) <- c("CountryCode", "Ranking", "Country", "GDPin$(millions)", "IncomeGroup")
## 
## > merged_data_grp_by_income <- spread(merged_data_2_sorted, key = "IncomeGroup", value = "Ranking", fill = 0)
## 
## > #seperate out the high income non OECD Income Group with non-zero values. Zero value means they dont belong 
## > #to this group.
## > nonOECD <- merged_d .... [TRUNCATED] 
## 
## > nonOECD$`High income: nonOECD` <- as.numeric(nonOECD$`High income: nonOECD`)
## 
## > avg_rank_of_nonOECD_income <- mean(nonOECD$`High income: nonOECD`)
## 
## > avg_rank_of_nonOECD_income
## [1] 91.91304
## 
## > #similarly separate out the OECD income group.
## > OECD <- merged_data_grp_by_income[(merged_data_grp_by_income$`High income: OECD` != 0), 1:5]
## 
## > OECD$`High income: OECD` <- as.numeric(OECD$`High income: OECD`)
## 
## > avg_rank_of_OECD_income <- mean(OECD$`High income: OECD`)
## 
## > avg_rank_of_OECD_income
## [1] 32.96667
```

The average GDP Ranking for the High income OECD group is  32.96.

The average GDP Ranking High income NON OECD group is 91.91.



##4: Show the distribution of GDP value for all the countries and color plots by income group. Use ggplot2 to create your plot.


```r
source("Analysis_4.R", echo = TRUE, keep.source = TRUE)
```

```
## 
## > #seperate out low income, low middle and upper Middle Income. 
## > lowIncome <- merged_data_grp_by_income[(merged_data_grp_by_income$`Low income` != 0 .... [TRUNCATED] 
## 
## > lowMiddleIncome <- merged_data_grp_by_income[(merged_data_grp_by_income$`Lower middle income` != 0), 1:5]
## 
## > upperMiddleIncome <- merged_data_grp_by_income[(merged_data_grp_by_income$`Upper middle income` != 0), 1:5]
## 
## > #NOTE:Taking log(GDP) to fit into graphical scale better
## > 
## > 
## > #Option#1: Show all the countries using geometric points and callout country shortc .... [TRUNCATED] 
## 
## > plot + geom_point() + geom_text_repel(aes(color = merged_data_2_sorted$IncomeGroup, label=merged_data_2_sorted$CountryCode), size = 3)
```

![](GDPMakefile_files/figure-html/analysis_4-1.png)<!-- -->

```
## 
## > #Option#2, create box plot to show the extreme values and where most of the GDP per income 
## > #group is concentrated.
## > 
## > plot + geom_boxplot(aes(f .... [TRUNCATED]
```

![](GDPMakefile_files/figure-html/analysis_4-2.png)<!-- -->




##5:Provide summary statistics of GDP by income groups.


```r
source("Analysis_5.R", echo = TRUE, keep.source = TRUE)
```

```
## 
## > summary(nonOECD$`GDPin$(millions)`)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    2584   12840   28370  104300  131200  711000 
## 
## > summary(OECD$`GDPin$(millions)`)
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
##    13580   211100   486500  1484000  1480000 16240000 
## 
## > summary(lowIncome$`GDPin$(millions)`)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##     596    3814    7843   14410   17200  116400 
## 
## > summary(lowMiddleIncome$`GDPin$(millions)`)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##      40    2549   24270  256700   81450 8227000 
## 
## > summary(upperMiddleIncome$`GDPin$(millions)`)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##     228    9613   42940  231800  205800 2253000
```



The lowest GDP value is seen in low Middle income groups.

Highest GDP value seen in High income OECD group and the highest average is also seen in the High income OECD groups


##6:Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries are Lower middle income but among the 38 nations with highest GDP? 


```r
source("Analysis_6.R", echo = TRUE, keep.source = TRUE)
```

```
## 
## > merged_data_2_sorted$Ranking <- as.numeric(merged_data_2_sorted$Ranking)
## 
## > gdp_Ranking_quantile <- cut(merged_data_2_sorted$Ranking, 
## +                             breaks = quantile(merged_data_2_sorted$Ranking, c(0, .20, . .... [TRUNCATED] 
## 
## > #List the income Group for each Ranking 
## > Ranking_per_incomeGrp <- aggregate(merged_data_2_sorted$IncomeGroup, list(Ranking = gdp_Ranking_quantile) .... [TRUNCATED] 
## 
## > Ranking_per_incomeGrp1 <- Ranking_per_incomeGrp[,1]
## 
## > #Aggregate the Income group, counting the number of entries in each Income group
## > Rank_gp1 <- aggregate(x = Ranking_per_incomeGrp$x[[1]], by = list .... [TRUNCATED] 
## 
## > Rank_gp2 <- aggregate(x = Ranking_per_incomeGrp$x[[2]], by = list(unique.values = Ranking_per_incomeGrp$x[[2]]), FUN = length)
## 
## > Rank_gp3 <- aggregate(x = Ranking_per_incomeGrp$x[[3]], by = list(unique.values = Ranking_per_incomeGrp$x[[3]]), FUN = length)
## 
## > Rank_gp4 <- aggregate(x = Ranking_per_incomeGrp$x[[4]], by = list(unique.values = Ranking_per_incomeGrp$x[[4]]), FUN = length)
## 
## > Rank_gp5 <- aggregate(x = Ranking_per_incomeGrp$x[[5]], by = list(unique.values = Ranking_per_incomeGrp$x[[5]]), FUN = length)
## 
## > #Spread the Income Groups, combine to list and aggregate the rows together.
## > r1 <- spread(Rank_gp1, key = "unique.values", value = "x", fill = 0)
## 
## > r2 <- spread(Rank_gp2, key = "unique.values", value = "x", fill = 0)
## 
## > r3 <- spread(Rank_gp2, key = "unique.values", value = "x", fill = 0)
## 
## > r4 <- spread(Rank_gp2, key = "unique.values", value = "x", fill = 0)
## 
## > r5 <- spread(Rank_gp2, key = "unique.values", value = "x", fill = 0)
## 
## > l <- list(r1, r2, r3, r4, r5)
## 
## > IncomeGrp <- data.table::rbindlist(l, fill = TRUE, use.names = TRUE, idcol= NULL)
## 
## > Ranking_Vs_level_of_income_group <- cbind(Ranking_per_incomeGrp1 , IncomeGrp)
## 
## > Ranking_Vs_level_of_income_group
##    Ranking_per_incomeGrp1 High income: nonOECD High income: OECD
## 1:               [1,38.6]                    4                18
## 2:            (38.6,76.2]                    5                10
## 3:             (76.2,114]                    5                10
## 4:              (114,152]                    5                10
## 5:              (152,190]                    5                10
##    Lower middle income Upper middle income Low income
## 1:                   5                  11         NA
## 2:                  13                   9          1
## 3:                  13                   9          1
## 4:                  13                   9          1
## 5:                  13                   9          1
```


13 countries are in lower middle income and in highest 38 nations with highest GDP


#Summary

The analysis of Gross Domestic product data of countries around the world shows that the average GDP of high income OECD is much bigger than highest of all the other income group's GDP value.
USA seems to have the highest GDP and Tuvalu has the lowest GDP. There are only few countries in the low income category.Many of the countries belong to lower middle income and High income OECD category.
