# Load packages
library( dplyr )

# Import data
bmf <- read.csv( "https://nccs-data.urban.org/dl.php?f=bmf/2022/bmf.bm2201.csv")
schedh <- read.csv( "SH-P05-T00-FAP-COMMUNITY-BENEFIT-POLICY-2018.csv" )

t <- read.csv( "SCHEDULE-TABLE-2018.csv" )


https://nccs-efile.s3.us-east-1.amazonaws.com/parsed/SCHEDULE-TABLE-2009.csv

sh <- list()

for( i in 2009:2019 )
{
  fn <- paste0( "https://nccs-efile.s3.us-east-1.amazonaws.com/parsed/SCHEDULE-TABLE-", i, ".csv" )
  d <- read.csv( fn )
  df <- d[ d$SCHEDH , ]
  sh[[as.character(i)]] <- df
}

dh <- dplyr::bind_rows( sh )

ntee <- dplyr::select( bmf, EIN, NTEEFINAL )

dh <- merge( dh, ntee, by.x="ORG_EIN", by.y="EIN", all.x=T )

dh$NTEE1 <- substr( dh$NTEEFINAL, 1, 1 )

table( dh$NTEE1 ) %>% knitr::kable()


|Var1 |  Freq|
|:----|-----:|
|     |    35|
|A    |     5|
|B    |   217|
|D    |     1|
|E    | 22454|
|F    |   651|
|G    |    41|
|H    |     5|
|I    |     2|
|J    |     1|
|K    |     1|
|L    |    11|
|M    |     3|
|N    |    17|
|P    |   153|
|Q    |    16|
|R    |     1|
|S    |    35|
|T    |    20|
|U    |     1|
|W    |     6|
|X    |    49|
|Y    |     3|




dd <- select( dh, ORG_EIN, NTEE1, NTEEFINAL, SCHEDH ) %>% unique()
table( dd$NTEE1 ) %>% knitr::kable()


|Var1 | Freq|
|:----|----:|
|     |   14|
|A    |    5|
|B    |   38|  # university hospitals
|D    |    1|
|E    | 2507|
|F    |   85|
|G    |    7|
|H    |    1|
|I    |    2|
|J    |    1|
|K    |    1|
|L    |    9|
|M    |    3|
|N    |    9|
|P    |   27|
|Q    |    2|
|R    |    1|
|S    |    9|
|T    |    4|
|U    |    1|
|W    |    6|
|X    |    6|
|Y    |    3|


dd$NTEE2 <- substr( dd$NTEEFINAL, 1, 2 )
table( dd$NTEE2 ) %>% knitr::kable()


|Var1 | Freq|
|:----|----:|
|     |   14|
|A2   |    2|
|A6   |    2|
|A8   |    1|
|B1   |    7|
|B2   |    9|
|B4   |   14|
|B8   |    4|
|B9   |    4|
|D1   |    1|
|E1   |   35|
|E2   | 2360|
|E3   |   61|
|E4   |    2|
|E5   |    5|
|E6   |    3|
|E7   |    2|
|E8   |    1|
|E9   |   38|
|F0   |    2|
|F2   |    7|
|F3   |   76|
|G3   |    4|
|G4   |    2|
|G9   |    1|
|H9   |    1|
|I1   |    1|
|I7   |    1|
|J3   |    1|
|K2   |    1|
|L0   |    1|
|L2   |    6|
|L8   |    1|
|L9   |    1|
|M2   |    3|
|N2   |    1|
|N3   |    1|
|N5   |    2|
|N6   |    4|
|N9   |    1|
|P2   |    2|
|P3   |    2|
|P7   |   18|
|P8   |    5|
|Q3   |    1|
|Q7   |    1|
|R2   |    1|
|S2   |    6|
|S3   |    1|
|S8   |    2|
|T2   |    1|
|T3   |    1|
|T7   |    2|
|U3   |    1|
|W3   |    5|
|W8   |    1|
|X2   |    5|
|X9   |    1|
|Y4   |    3|



# Sched H Part V Section A. HOSPITAL FACILITIES
# How many hospital facilities did the organization operate during
# the tax year?
# (list in order of size, from largest to smallest—see instructions)


schedh <- schedh[ ! is.na(schedh$SH_05_HOSPITAL_NUM) , ]
table( schedh$SH_05_HOSPITAL_NUM )

n.string <- strsplit( schedh$SH_05_HOSPITAL_NUM, ";" )
get_first <- function( x ) {
  x <- x[1]
  x <- gsub( "[{}]", "", x )
  return(x)
}

xx <- lapply( n.string, get_first ) %>% unlist()
table(xx)

> table(xx) %>% sort() %>% knitr::kable()


|xx | Freq|
|:--|----:|
|16 |    1|
|19 |    1|
|20 |    1|
|21 |    1|
|24 |    1|
|28 |    1|
|42 |    1|
|43 |    1|
|13 |    2|
|18 |    2|
|22 |    2|
|10 |    3|
|11 |    3|
|14 |    3|
|9  |    4|
|12 |    5|
|15 |    5|
|7  |    7|
|8  |    9|
|6  |   12|
|5  |   30|
|4  |   40|
|3  |   61|
|2  |  198|
|1  | 1918|




# https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201141369349304784_public.xml
# JOHNS CREEK COMMUNITY ARTS CENTER


# > table( table( dh$ORG_EIN ) )
# 
#    1    2    3    4    5    6    7    8    9   10   11   12   13   14 
#  260  102   90  113  116  115   94  109  248 1055  608  107   18    2 
#


####
####  NTEE VS ACTIVE HOSPITALS
####


d.e20 <- filter( bmf, NTEEFINAL %in% c("E20","E21","E22","E24") )

table( d.e20$NTEEFINAL ) %>% knitr::kable()

|Var1 | Freq|
|:----|----:|
|E20  | 1429|
|E21  | 1978|
|E22  | 2804|
|E24  |  403|

# E20 Hospitals
# E21 Community Health Systems
# E22 General Hospitals
# E24 Specialty Hospitals 

b2 <- filter( bmf, EIN %in% eins )

# 42103594 

https://nccs-efile.s3.us-east-1.amazonaws.com/xml/201912999349200006_public.xml

https://s3.amazonaws.com/irs-form-990/201912999349200006_public.xml

# Create a hosp variable in the schedh dataset
schedh$hosp <- 1

# Rename ORG_EIN to EIN in the schedh dataset for merging purposes
schedh <- schedh %>% rename( "EIN" = "ORG_EIN" )

# Remove duplicate rows from the schedh dataset
n_distinct(schedh$EIN)
schedh <- schedh %>% distinct(EIN, .keep_all = T )

# Drop all but the EIN and hosp variables from the schedh dataset
schedh <- subset( schedh, select = c( "EIN", "hosp" ))

# Merge the hosp variable into the BMF dataset
bmf <- merge( x = bmf, y = schedh, by = "EIN", all.x = T )
table( bmf$hosp )

# Convert hosp values of NA to 0
bmf$hosp[ is.na( bmf$hosp )] <- 0
table( bmf$hosp )

# Create variables
bmf$h <- rep( 6, nrow(bmf) )
bmf$h[ bmf$hosp == 0 & !( bmf$NTEEFINAL %in% c( "E20", "E21", "E22", "E24", 
       "F31", "E30", "E31", "E32", "E40", "E42", "E50", "E60", "E61", "E62", 
       "E65", "E6A", "E90", "E91", "E92", "E99", "F20", "F21", "F22", "F30", 
       "F32", "F33", "F40", "F42", "F50", "F52", "F53", "F54", "F60", "F70", 
       "F99", "E80", "G20", "G25", "G30", "G32", "G40", "G41", "G42", "G43", 
       "G44", "G45", "G48", "G50", "G51", "G54", "G60", "G61", "G70", "G80", 
       "G81", "G83", "G84", "G99" ))] <- 0
bmf$h[ bmf$hosp == 1 | bmf$NTEEFINAL %in% c( "E20", "E21", "E22", "E24", "F31" 
       ) ] <- 1
bmf$h[ bmf$hosp == 0 & bmf$NTEEFINAL %in% c( "E30", "E31", "E32", "E40", "E42", 
       "E50", "E60", "E61", "E62", "E65", "E6A", "E90", "E91", "E92", "E99", 
       "F20", "F21", "F22", "F30", "F32", "F33", "F40", "F42", "F50", "F52", 
       "F53", "F54", "F60", "F70", "F99" )] <- 2
bmf$h[ bmf$hosp == 0 & bmf$NTEEFINAL == "E80" ] <- 3
bmf$h[ bmf$hosp == 0 & bmf$NTEEFINAL %in% c( "G20", "G25", "G30", "G32", "G40", 
       "G41", "G42", "G43", "G44", "G45", "G48", "G50", "G51", "G54", "G60", 
       "G61", "G70", "G80", "G81", "G83", "G84" )] <- 4
bmf$h[ bmf$hosp == 0 & bmf$NTEEFINAL == "G99" ] <- 5

table( bmf$h )