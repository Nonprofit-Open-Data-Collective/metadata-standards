# Load packages
library( dplyr )
library ( data.table )

# Import data
d <- fread( "efile-index-data-commons-2023-08-13.csv", 
            select = c( "EIN", "FormType", "TaxYear" ))
bmf <- read.csv( "https://nccs-data.urban.org/dl.php?f=bmf/2022/bmf.bm2201.csv")
f <- fread( "F9-P04-T00-REQUIRED-SCHEDULES-2018.csv", 
            select = c( "ORG_EIN", "F9_04_HOSPITAL_X" ))

# Add metadata function
get_last_x <- function(x) {
  x <- x[ x != "" & ( ! is.na(x) ) ]
  if( length(x) == 0 )
  { return("") } 
  return( x[ length(x) ] )
}

# Convert values of 990T to NA in the d dataset
d$FormType[ d$FormType == "990T" ] <- NA

# Get the last FormType and TaxYear for each org in the d dataset
d <- 
  d %>%
  arrange( EIN, FormType, TaxYear ) %>%
  group_by( EIN ) %>%
  transmute( 
    LastFormType = get_last_x( FormType ),
    LastTaxYear = get_last_x( TaxYear )) %>%
  unique() %>% 
  ungroup() %>%
  as.data.frame()

table( d$LastFormType )

# Merge LastFormType into the BMF dataset
bmf <- merge( x = bmf, y = d, by = "EIN", all.x = T )
table( bmf$LastFormType )

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
bmf$h <- rep( 16, nrow(bmf) )
bmf$h[ !( bmf$NTEEFINAL %in% c( "E20", "E22",
                                "E21", "E32", "E30", "E31", "E80",
                                "E24", "E61", "E65", "E6A",
                                "E60", "E50", "E99", "P50", "E86",
                                "F40", "E62", "P52", "P60", "P61", "P58", "P85", 
                                "P84",
                                "P81", "P75", "E90", "E91", "P74", "E92",
                                "P70", "P73", "P71", "P80", "P82", "P86", 
                                "P87",
                                "E40", "E42", "P47", "P83", "P88",
                                "F42", "P43", "P62",
                                "P40", "P42", "P44", "P45", "P46",
                                "F31", "F33", "F32", "F30", "F60", "F70", 
                                "F99",
                                "F22", "F20", "F53", "F21", "F50", "F52", "F54", 
                                "P51",
                                "E05", "F05", "G05", "H05", "H20", "H25", "H30", 
                                "H32", "H40", "H41", "H42", "H43", "H44", "H45", 
                                "H48", "H50", "H51", "H54", "H60", "H61", "H70", 
                                "H80", "H81", "H83", "H84", "H90", "H92", "H94", 
                                "H96", "H98", "H9B", "H99",
                                "U30",
                                "G20", "G25", "G30", "G32", "G40", "G41", "G42", 
                                "G43", "G44", "G45", "G48", "G50", "G51", "G54", 
                                "G60", "G61", "G70", "G80", "G81", "G83", "G84", 
                                "G99" )) & ! ( bmf$NTEEFINAL == "B43" & 
                                                 bmf$hosp==1 )] <- 0
bmf$h[ bmf$NTEEFINAL %in% c( "E20", "E22" ) | ( bmf$NTEEFINAL == "B43" & 
                                                bmf$hosp==1 )] <- 1
bmf$h[ bmf$NTEEFINAL %in% c( "E21", "E32", "E30", "E31", "E80" )] <- 2
bmf$h[ bmf$NTEEFINAL %in% c( "E24", "E61", "E65", "E6A" )] <- 3
bmf$h[ bmf$NTEEFINAL %in% c( "E60", "E50", "E99", "P50", "E86" )] <- 4
bmf$h[ bmf$NTEEFINAL %in% c( "F40", "E62", "P52", "P60", "P61", "P58", "P85", 
                             "P84" )] <- 5
bmf$h[ bmf$NTEEFINAL %in% c( "P81", "P75", "E90", "E91", "P74", "E92" )] <- 6
bmf$h[ bmf$NTEEFINAL %in% c( "P70", "P73", "P71", "P80", "P82", "P86", 
                             "P87" )] <- 7
bmf$h[ bmf$NTEEFINAL %in% c( "E40", "E42", "P47", "P83", "P88" )] <- 8
bmf$h[ bmf$NTEEFINAL %in% c( "F42", "P43", "P62" )] <- 9
bmf$h[ bmf$NTEEFINAL %in% c( "P40", "P42", "P44", "P45", "P46" )] <- 10
bmf$h[ bmf$NTEEFINAL %in% c( "F31", "F33", "F32", "F30", "F60", "F70", 
                             "F99" )] <- 11
bmf$h[ bmf$NTEEFINAL %in% c( "F22", "F20", "F53", "F21", "F50", "F52", "F54", 
                             "P51" )] <- 12
bmf$h[ bmf$NTEEFINAL %in% c( "E05", "F05", "G05", "H05", "H20", "H25", "H30", 
                             "H32", "H40", "H41", "H42", "H43", "H44", "H45", 
                             "H48", "H50", "H51", "H54", "H60", "H61", "H70", 
                             "H80", "H81", "H83", "H84", "H90", "H92", "H94", 
                             "H96", "H98", "H9B", "H99" )] <- 13
bmf$h[ bmf$NTEEFINAL %in% c( "U30" )] <- 14
bmf$h[ bmf$NTEEFINAL %in% c( "G20", "G25", "G30", "G32", "G40", "G41", "G42", 
                             "G43", "G44", "G45", "G48", "G50", "G51", "G54", 
                             "G60", "G61", "G70", "G80", "G81", "G83", "G84", 
                             "G99" )] <- 15

table( bmf$h )
table( bmf$h, bmf$hosp )