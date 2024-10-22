library( dplyr )

setwd( "C:/Users/jdlec/Dropbox/00 - URBAN/taxonomies" )



d <- data.table::fread( "BMF_UNIFIED_V1.1.csv" )
d <- d[ new.order ]
head( d )


table( d$BMF_STATUS_CODE )
table( d$BMF_FOUNDATION_CODE )
table( d$BMF_CLASSIFICATION_CODE ) |> knitr::kable()

table( d$BMF_SUBSECTION_CODE ) |> knitr::kable()

d$CC1 <- substr( d$BMF_SUBSECTION_CODE, 1, 1 )
d$CC2 <- substr( d$BMF_SUBSECTION_CODE, 2, 2 )
d$CC3 <- substr( d$BMF_SUBSECTION_CODE, 3, 3 )
d$CC4 <- substr( d$BMF_SUBSECTION_CODE, 4, 4 )


d$SS <- stringr::str_pad( d$BMF_SUBSECTION_CODE, 2, pad = "0" )
d$SS <- paste0( "c", d$SS )
d$SSCC <- paste0( d$SS, "-", d$CC1 )

table( d$SSCC ) |> knitr::kable()



ss <- read.csv("sscc.csv")

ss$ss <- stringr::str_pad( ss$SS, 2, pad = "0" )
ss$ss <- paste0( "c", ss$ss )
ss$sscc <- paste0( ss$ss, "-", ss$CC1 )

ss$SSCCTYPE <- paste0( "501", ss$sscc, " ", ss$SSCCTYPE )
ss$SSCCTYPE





bmf1 <- read.csv("eo1.csv")
bmf2 <- read.csv("eo2.csv")
bmf3 <- read.csv("eo3.csv")
bmf <- bind_rows( bmf1, bmf2, bmf3 )

bmf$SS <- stringr::str_pad( bmf$SUBSECTION, 2, pad = "0" )
bmf$SS <- paste0( "c", bmf$SS )

bmf$CC1 <- substr( bmf$CLASSIFICATION, 1, 1 )
bmf$SSCC <- paste0( bmf$SS, "-", bmf$CC1 )


table( bmf$SSCC, useNA="ifany" ) |> knitr::kable()
setdiff( unique(bmf$SSCC), ss$SSCC )
setdiff( ss$SSCC, unique(bmf$SSCC) )

these <- setdiff( unique(bmf$SSCC), ss$SSCC )
bmff <- bmf[ bmf$SSCC %in% these , ]
table( bmff$SSCC, useNA="ifany" ) |> knitr::kable()

bmff <- bmf[ bmf$SSCC %in% ss$SSCC , ]
table( bmff$SSCC, useNA="ifany" ) |> knitr::kable()


ss$SSTYPE2 <- paste0( toupper(ss$SS2), " ", toupper(ss$SSTYPE) )

ss$SSCCTYPE3 <- paste0( toupper(ss$SS2), " ", toupper(ss$SSTYPE), " (", ss$SSCCTYPE2, ")" ) |> as.factor()
ss2 <- ss[c("SSCC","SSTYPE","SSCCTYPE","SSCCTYPE2","SSCCTYPE3")]

bmf <- merge( bmf, ss2, by="SSCC", all.x=T )

table( bmf$SSCCTYPE, useNA="ifany" ) |> knitr::kable()
table( bmf$SSCCTYPE3, useNA="ifany" ) |> knitr::kable()

table( bmf$SSCC[ is.na(bmf$SSCCTYPE) ] ) |> knitr::kable()  


bmf %>%
  group_by( SSTYPE ) %>%
  count( SSCCTYPE2 )



d <- merge( d, ss, by="sscc", all.x=T )

table( d$sscc ) |> knitr::kable()
ss$sscc

table( d$SSCCTYPE ) |> knitr::kable()

library(stringr)






new.order <- 
c("EIN", "EIN2",
"ORG_NAME_CURRENT","ORG_NAME_SEC",
"ORG_FISCAL_YEAR", "ORG_PERS_ICO", "ORG_FISCAL_PERIOD",
 
"ORG_RULING_DATE", "ORG_RULING_YEAR", 
"ORG_YEAR_FIRST", "ORG_YEAR_LAST", "ORG_YEAR_COUNT", 

"NTEE_IRS", "NTEE_NCCS", 
"NTEEV2", 
"NCCS_LEVEL_1", "NCCS_LEVEL_2", 
"NCCS_LEVEL_3",
 
"BMF_SUBSECTION_CODE", "BMF_STATUS_CODE", 
"BMF_PF_FILING_REQ_CODE", "BMF_ORGANIZATION_CODE", 
"BMF_INCOME_CODE", "BMF_GROUP_EXEMPT_NUM", 
"BMF_FOUNDATION_CODE", "BMF_FILING_REQ_CODE", 
"BMF_DEDUCTIBILITY_CODE", "BMF_CLASSIFICATION_CODE", 
"BMF_ASSET_CODE", "BMF_AFFILIATION_CODE", 

"F990_TOTAL_REVENUE_RECENT", 
"F990_TOTAL_INCOME_RECENT", 
"F990_TOTAL_ASSETS_RECENT", 
"F990_ORG_ADDR_CITY", 
"F990_ORG_ADDR_STATE", 
"F990_ORG_ADDR_ZIP", 
"F990_ORG_ADDR_STREET",

"ORG_ADDR_FULL", "ORG_ADDR_MATCH", 
"LATITUDE", "LONGITUDE", 
"GEOCODER_SCORE", "GEOCODER_MATCH", 

"CENSUS_CBSA_FIPS", 
"CENSUS_CBSA_NAME", 
"CENSUS_BLOCK_FIPS", 
"CENSUS_URBAN_AREA", 
"CENSUS_STATE_ABBR", 
"CENSUS_COUNTY_NAME" )

d <- d[ new.order ]
head( d )

dd <- read.csv("TAX-EXEMPT-TYPES-V2.csv")


c("bmf_code", "irs_code", "v501c_label", "v501c_label2", "notes", 
"exempt_type_stakeholder", "exempt_type_primary", "exempt_type_secondary", 
"govt_incorp", "req_990", "option_990EZ", "donations_deduct", 
"political_limits", "member_types", "affiliation_status")

keep <- 
c("bmf_code", "irs_code",  
"exempt_type_stakeholder", 
"exempt_type_primary", 
"govt_incorp", "req_990", "option_990EZ", "donations_deduct", 
"political_limits", "member_types", "affiliation_status")

dd <- dd[keep]

d2 <- merge( d, dd, by.x=

v1 <- unique( d$BMF_SUBSECTION_CODE )
v2 <- unique( dd$bmf_code )

setdiff( v1, v2 )
setdiff( v2, v1 )

table(d$BMF_SUBSECTION_CODE) |> knitr::kable()




