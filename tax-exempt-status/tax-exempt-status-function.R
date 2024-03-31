### Setting Up Variables

label <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", 
           "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", 
           "21", "22", "23", "24", "25", "26", "27", "28", "29", 
           "40", "50", "60", "70", "71", "72", "80", "81")

description <- c(
  "501(c)(1)- Corporations originated under Act of Congress, including Federal Credit Unions", 
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
  "501(d) - Apostolic and religious orgs.", 
  "501(e) - Cooperative Hospital Service Organization",
  "501(f) - Cooperative Service Org. of Operating Educ. Org.",
  "501(k) - Child Care Organization - 501(k)",
  "501(n) - Charitable Risk Pool",
  "501(q) - Credit Counseling Organizations",
  "521 - Farmers' Cooperatives",
  "529 - Qualified State-Sponsored Tuition Program"
)


tax_exempt_group <- c(
  "MMB",  "MMB",  "CSB",  "CSB",  "MMB",  "CSB",  "CSB",  "MMB",  "MMB",  "CSB",  
  "MMB",  "MMB",  "CSB",  "MMB",  "MMB",  "CSB",  "MMB",  "MMB",  "CSB",  "MMB", 
  "MMB",  "MMB",  "MMB",  "MMB",  "MMB",  "MMB",  "MMB",  "MMB",  "MMB",  "MMB",  
  "CSB",  "CSB",  "CSB",  "CSB",  "CSB",  "CSB",  "MMB")


tax_exempt_subgroup <-  c(
  "COR",  "COR",  "GEN",  "GEN",  "SIG",  "GEN",  "CMC",  "SIG",  "INS",  "CMC",
  "PEN",  "INS",  "GEN",  "COP",  "INS",  "COP",  "INS",  "PEN",  "CMC",  "DEF",
  "INS",  "PEN",  "SIG",  "DEF",  "COR",  "INS",  "INS",  "PEN",  "INS",  "MCM",
  "COP",  "COP",  "GEN",  "COP",  "GEN",  "COP",  "PEN"
)

donations_deductible <- c(
  "YR",  "NO",  "YU",  "NO",  "NO",  "NO",  "NO",  "YR",  "NO",  "YR",  "NO",  
  "NO",  "YU",  "NO",  "NO",  "NO",  "NO",  "NO",  "NO",  "NA",  "NO",  "NO",  
  "NO",  "NO",  "NO",  "NO",  "NO",  "NO",  "NO",  "NO",  "YU",  "YU",  "YU",  
  "YU",  "NO",  "NO",  "NO")

political_activity <- c(
  "RES",  "LIM",  "RES",  "LIM",  "LIM",  "LIM",  "RES",  "RES",  "RES",  "RES",  
  "RES",  "RES",  "RES",  "RES",  "RES",  "RES",  "RES",  "RES",  "RES",  "RES",  
  "RES",  "RES",  "LIM",  "RES",  "RES",  "RES",  "RES",  "RES",  "RES",  "",
  "", "",  "",  "",  "", "",  ""
)

membership_restrictions <- c(
  "NA", "NA", "N",  "N","Y",  "N", "N",  "N", "N",  "Y", "Y",  "Y", "Y",  "Y",
  "Y",  "Y", "N",  "Y", "Y",  "NA", "N", "NA", "Y", "NA", "NA", "NA", "Y", "NA",
  "NA", "Y", "N", "Y", "N", "Y", "NA", "Y", "NA"
)

existace_501c <- c(
  "N", "Y", "N", "N", "N", "N", "N", "L", "N", "L", "N", "N", "N", "N", "N", 
  "N", "N", "N", "N", "N", "N", " ",  "N", "N", "Y", "N", "N", "N", "N", "N", 
  "Y", "Y", "N", "Y", "N", "N", "N"
)

required_990 <- c(
  "N", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", 
  "Y", "Y", "Y", "Y", "NA", "Y", "Y", "Y", "NA", "Y", "Y", "Y", "Y", "Y", "N", 
  "Y", "Y", "Y", "Y", "Y", "N"
)


option_990EZ <- c(
  "NA", "Y", "M", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", 
  "Y", "Y", "Y", "Y", "NA", "N", "Y", "Y", "NA", "Y", "Y", "Y", "N", "N", "NA",
  "Y", "Y", "Y", "Y", "N", "NA"
)

other_filing_requrirements