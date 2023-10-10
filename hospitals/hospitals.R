# Load packages
library( dplyr )
library ( data.table )

# Import data
d <- fread( "efile-index-data-commons-2023-08-13.csv", select = c( "EIN", "FormType", "TaxYear" ))
bmf <- read.csv( "https://nccs-data.urban.org/dl.php?f=bmf/2022/bmf.bm2201.csv")
schedh_1 <- read.csv( "SH-P01-T00-FAP-COMMUNITY-BENEFIT-POLICY-2018.csv" )
schedh_3 <- read.csv( "SH-P03-T00-FAP-COMMUNITY-BENEFIT-POLICY-2018.csv" )
schedh_5 <- read.csv( "SH-P05-T00-FAP-COMMUNITY-BENEFIT-POLICY-2018.csv" )

# Add metadata functions
get_last_x <- function(x) {
  x <- x[ x != "" & ( ! is.na(x) ) ]
  if( length(x) == 0 )
  { return("") } 
  return( x[ length(x) ] )
}

get_best_x <- function(x) {
  if( length(x) == 0 )
  { return("") }
  t <- table(x)
  mode.x <- t[ t == max(t) ] %>% names()
  mode.x <- paste0( mode.x, collapse=";;" )
  return( mode.x )
}

# Convert values of 990T to NA in the d dataset
d$FormType[ d$FormType == "990T" ] <- NA

# Get the last FormType and TaxYear for each org in the d dataset
d <- 
  d %>%
  arrange( EIN, FormType, TaxYear ) %>%
  group_by( EIN ) %>%
  transmute( 
    LastFormType = get_last_x( FormType),
    LastTaxYear = get_last_x( TaxYear )) %>%
  unique() %>% 
  ungroup() %>%
  as.data.frame()

table( d$LastFormType )

# Merge LastFormType into the BMF dataset
bmf <- merge( x = bmf, y = d, by = "EIN", all.x = T )
table( bmf$LastFormType )

# Investigate the number of NAs in each section of the schedh datasets
# I'm skipping part 2, since only some hospitals fill out that part.
table(is.na(schedh_1$SH_01_REP_ANNUAL_COM_BEN_X))
#| FALSE   TRUE 
#| 2312 404064 

table(is.na(schedh_1$SH_01_FA_AMT_BUDGETED_CARE_X))
#| FALSE   TRUE 
#| 2304 404072

table(is.na(schedh_1$SH_01_FPG_FREE_CARE_X))
#| FALSE   TRUE 
#| 2303 404073 

table(is.na(schedh_1$SH_01_FAP_X))
#| FALSE   TRUE 
#| 2312 404064 

table(is.na(schedh_3$SH_03_COLLEC_POLICY_WRITTEN_X))
#| FALSE   TRUE 
#| 2304 404072 

table(is.na(schedh_3$SH_03_MEDICARE_REIMBURSE_AMT))
#| FALSE   TRUE 
#| 2259 404117 

table(is.na(schedh_3$SH_03_BAD_DEBT_EXP_REPORTED_X))
#| FALSE   TRUE 
#| 2290 404086

table(is.na(schedh_5$SH_05_HOSPITAL_NUM))
#| FALSE   TRUE 
#| 2312 404064

table(is.na(schedh_5$SH_05_CHNA_FIRST_LIC_X))
#| FALSE   TRUE 
#| 2304 404072 

table(is.na(schedh_5_5$SH_05_FAP_CRITERIA_EXPLAIN_X))
#| FALSE   TRUE 
#| 2304 404072 

# Since there's no clear pattern, 
# let's use F9_04_HOSPITAL_X from Form 990 instead.
remove(schedh_1)
remove(schedh_2)
remove(schedh_3)
remove(schedh_4)
remove(schedh_5)

f <- fread( "F9-P04-T00-REQUIRED-SCHEDULES-2018.csv", 
            select = c( "ORG_EIN", "F9_04_HOSPITAL_X" ))

# Rename ORG_EIN to EIN in the f dataset for merging purposes
f <- f %>% rename( "EIN" = "ORG_EIN" )

# Remove duplicate rows from the f dataset
n_distinct( f$EIN )
f <- f %>% distinct( EIN, .keep_all = T )

# Remove duplicate rows from the bmf dataset
n_distinct( bmf$EIN )
bmf <- bmf %>% distinct( EIN, .keep_all = T )

# Merge the F9_04_HOSPITAL_X variable into the BMF dataset
bmf <- merge( x = bmf, y = f, by = "EIN", all.x = T )

# Create the hosp variable
bmf$hosp[ bmf$F9_04_HOSPITAL_X == 0 | bmf$F9_04_HOSPITAL_X == "false" | 
          bmf$LastFormType == "990PF" ] <- 0
bmf$hosp[ bmf$F9_04_HOSPITAL_X == 1 | bmf$F9_04_HOSPITAL_X == "true" ] <- 1

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