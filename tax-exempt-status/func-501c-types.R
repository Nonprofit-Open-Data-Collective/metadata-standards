### FILE PURPOSE ### 
# Function to input Subsector code and output information about that 501c type


### Make the Columns
code_opts <-  c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10",
         "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
         "21", "22", "23", "24", "25", "26", "27", "28", "29", "40",
         "50", "60", "70", "71", "72", "80", "81")

description <-  c("501(c)(1)- Corporations originated under Act of Congress, including Federal Credit Unions",
                "501(c)(2)- Title holding corporation for a tax-exempt organization.",
                "501(c)(3)- Religious, educational, charitable, scientific, and literary organizations...",
                "501(c)(4) - Civic Leagues, Social Welfare Organizations, and Local Associations of Employees.",
                "501(c)(5) - Labor, Agricultural and Horticultural Organizations",
                "501(c)(6)- Business leagues, chambers of commerce, real estate boards, etc. formed to improve conditions...",
                "501(c)(7)- Social and recreational clubs which provide pleasure, recreation, and social activities.",
                "501(c)(8)- Fraternal beneficiary societies and associations, with lodges providing for payment of life...",
                "501(c)(9)- Voluntary employees' beneficiary ass'ns (including fed. employees' voluntary beneficiary...",
                "501(c)(10)- Domestic fraternal societies and assoc's-lodges devoting their net earnings to charitable...",
                "501(c)(11)- Teachers retirement fund associations.",
                "501(c)(12)- Benevolent life insurance associations, mutual ditch or irrigation companies, mutual or coop...",
                "501(c)(13)- Cemetery companies, providing burial and incidental activities for members.",
                "501(c)(14) - State-chartered credit unions, mutual reserve funds, offering loans to members...",
                "501(c)(15) - Mutual insurance cos. ar associations, providing insurance to members substantially at cost...",
                "501(c)(16) - Cooperative organizations to finance crop operations, in conjunction with activities ...",
                "501(c)(17) - Supplemental unemployment benefit trusts, providing payments of suppl. unemployment comp...",
                "501(c)(18) - Employee funded pension trusts, providing benefits under a pension plan funded by employees...",
                "501(c)(19) - Post or organization of war veterans.",
                "501(c)(20) - Trusts for prepaid group legal services, as part of a qual. group legal service plan or plans.",
                "501(c)(21) - Black lung trusts, satisfying claims for compensation under Black Lung Acts.",
                "501(c)(22)  - Multiemployer Pension Plan",
                "501(c)(23) - Veterans association formed prior to 1880",
                "501(c)(24)  -Trust described in Section 4049 of ERISA",
                "501(c)(25) - Title Holding Company for Pensions, etc",
                "2501(c)(26) - State-Sponsored High Risk Health Insurance Organizations",
                "501(c)(27) - State-Sponsored Workers Compensation Reinsurance",
                "501(c)(28) - National Railroad Retirement Investment Trust (NRRIT)",
                "501(c)(29) - Qualified Nonprofit Health Insurance Issuers",
                "501(d) - Apostolic and religious orgs. - 501(d)",
                "501(e) - Cooperative Hospital Service Organization - 501(e)",
                "501(f) - Cooperative Service Org. of Operating Educ. Org.- 501(f)",
                "501(k) - Child Care Organization - 501(k)",
                "501(n) - Charitable Risk Pool",
                "501(q) - Credit Counseling Organizations",
                "521 - Farmers' Cooperatives",
                "529 - Qualified State-Sponsored Tuition Program")


tax_exempt_group <- c("MMB", "MMB", "CSB", "CSB", "MMB", "CSB", "CSB", "MMB", 
                      "MMB", "CSB", "MMB", "MMB", "CSB", "MMB", "MMB", "CSB", 
                      "MMB", "MMB", "CSB", "MMB", "MMB", "MMB", "MMB", "MMB", 
                      "MMB", "MMB", "MMB", "MMB", "MMB", "MMB", "CSB", "CSB", 
                      "CSB", "CSB", "CSB", "CSB", "MMB")

tax_exempt_subgroup <- c("COR", "COR", "GEN", "GEN", "SIG", "GEN", "CMC", "SIG", 
                         "INS", "CMC", "PEN", "INS", "GEN", "COP", "INS", "COP", 
                         "INS", "PEN", "CMC", "DEF", "INS", "PEN", "SIG", "DEF", 
                         "COR", "INS", "INS", "PEN", "INS", "MCM", "COP", "COP", 
                         "GEN", "COP", "GEN", "COP", "PEN")

govt_established <-  c("F", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N",
                     "N", "N", "N", "N", "N", "N", "NA", "N", "N", "N", "N", "N", "N", "N",
                     "N", "N", "N", "N", "N", "N", "NA", "N", "NA")


required_990 <- c("N",  "Y",  "YE",  "Y",  "Y",  "Y",  "Y",  "Y",  "Y",  "Y",  
                  "Y",  "Y",  "Y",  "Y",  "Y",  "Y",  "Y",  "Y",  "Y",  "NA",  
                  "Y",  "Y",  "Y",  "NA",  "Y",  "Y",  "Y",  "Y",  "Y",  "N",  
                  "Y",  "Y",  "Y",  "Y",  "Y",  "N", NA)



option_990EZ <-  c("NA", "Y", "YU", "M", "Y", "Y", "Y", "YR", "NO", "YR", "NO", "NO", "YU", "NO",
                 "NO", "NO", "NO", "NO", "NO", "NA", "NO", "NO", "Y", "NA", "NO", "NO", "NO",
                 "NO", "NO", "1065", "NA", "YU", "YU", "YU", "NO", "NA", "NO")



political_activity <- c("RES", "LIM", "RES", "LIM", "LIM", "LIM", "RES", "RES", 
                        "RES", "RES", "RES", "RES", "RES", "RES", "RES", "RES",
                        "RES", "RES", "RES", "RES", "RES", "RES", "LIM", "RES",
                        "RES", "RES", "RES", "RES", "RES", rep(NA, 8))


membership_restrictions <- c("N", "Y", "N", "N", "N", "N", "N", "L", "N", "N", "N", "N", "N", "N", "N", "N",
                             "N", "N", "N", "N", "N", "Y", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N",
                             "N", "N", "NA", "N", "N")

existence_501c <- c("NA", "NA", "N", "N", "N", "N", "N", "L", "N", "N", "N", "N", "N", "N", "N", "N",
                    "N", "N", "N", "NA", "N", "N", "NA", "N", "NA", "NA", "N", "N", "NA", "NA", "Y",
                    "N", "N", "N", "NA", "NA", "NA")

other_filing_requirements <- c("NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA",
                               "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NO", "NA", "NA", "NA", "NA", "NA",
                               "NA", "NA", "NA", "1065", "NA", "NA", "NA", "NA", "NA", "1120-C", "NA")
 
donations_deductible <- c("NA", "YR", "RES", "NO", "NO", "NO", "RES", "RES", "RES", "RES", "RES", "RES",
                          "RES", "RES", "RES", "RES", "RES", "RES", "RES", "NA", "NO", "RES", "NO", "RES",
                          "NA", "RES", "RES", "RES", "RES", "Y", "NA", "YU", "YU", "YU", "NO", "NA", "NO")


### Make the data frame

types <- data.frame(
  code = code_opts, 
  description, tax_exempt_group, tax_exempt_subgroup, govt_established, 
  required_990, option_990EZ, political_activity, membership_restrictions,
  existence_501c, other_filing_requirements, donations_deductible)


### Make the Function to input 501c types and output list of information about it.
get_tax_exempt_type <- function(code){
  
  ### Inputs
  # code = foundation code from 990 bmf. should be 2 digits. 
  # e.g. if FOUNDATION="5", then code="05". If FOUNDATION="16", then code="16"
  # https://www.irs.gov/pub/irs-soi/eo-info.pdf - EO SUBSECTION AND CLASSIFICATION CODES
  
  ### Outputs
  # data.frame with characteristics of that 501c type.
  
  ## Only input one code
  code <- as.character(code)
  if(length(code) != 1){
    stop("Input only one foundation code at a time.")
  }
  
  ## add leading 0's 
  code <- sprintf("%02s", code)
  
  ## test the code is correct - if not, return NAs
  if(!(code %in% types$code)){
    message("Input foundation code is not vaild. NAs will be returned")
    df.bad <- data.frame(matrix(NA, ncol = ncol(types), nrow = 1))
    colnames(df.bad) <- colnames(types)
    df.bad$code <- code
    return(df.bad)
  }
  
  ## Output table results
  which.row <- which(types$code == code)
  return(types[which.row, ])
  
}


### Examples

#Get one code
get_tax_exempt_type("5")
get_tax_exempt_type("16")
get_tax_exempt_type("81")
get_tax_exempt_type("82")


#get multiple codes 
fake_data <- data.frame(
  codes = c("01", "51", "22", "08", "10")
)

library(dplyr)
library(tidyr)
fake_data %>%
  mutate(new_columns = map(codes, get_tax_exempt_type)) %>% 
  unnest(new_columns) 

