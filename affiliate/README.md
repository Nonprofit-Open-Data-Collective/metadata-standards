Reproducible files for defining a new taxonomy of nonprofit affiliation structures and assigning organizations group IDs and group roles. 


Folder Structure: 

* data-raw: all raw data files (cannot be pushed to github because files are too larger. I include data sources here. All data used in analysis is in data-rodeo/.)
  * bmf-master.rds : 2022 NCCS BMF Master File : https://nccs-data.urban.org/data.php?ds=bmf
  * core2019.Rds : All 2019 NCCS core files combined into one data frame : https://nccs-data.urban.org/data.php?ds=core
  * eo1.csv, eo2.csv, eo3.csv, eo4.csv, eo_xx.csv, eo_pr.csv: IRS BMF files by region from https://www.irs.gov/charities-non-profits/exempt-organizations-business-master-file-extract-eo-bmf 
* data-wrangling-scripts: all R scripts for data wrangling, including user-defined functions 
  * 00-combining-eo.R : combining all IRS EO files into one file. 
  * 00-making-core-group.R : combining all NCCS core files and only keeping the records that could possibly be part of a group. 
  * 00-making-soi-group.R : combining all NCCS SOI files and only keeping the records that could possibly be part of a group. 
  * 01-finding-eins-with-group.R : combining EO, BMF, core, and SOI files, only keeping the records that could possibly be part of a group. Clean data.
  * find-parent-name.R : function to input vector of org names you thing are part of the same organization. Returns the likely parent organization name. 
  * scrape-gen.R, scrape-gen.py : R and python scripts to input an EIN and output the GEN scraped from ProPublica.
* data-rodeo: all data wrangled data
  * dat-core-group.RDA: all data from NCCS core files only keeping vairables that are related to group number.
  * IRS-EO.Rda: Most recent EO BMF from IRS. 
  * dat-soi-group.csv: all orgs in the NCCS SOI files that filed as part of a group
  * dat-group-info.Rda: information from all orgs listed in nccs bmf, irs bmf, soi, or core files that could possibly be part of a group. Variables in all data sets have been consolidated. 
  * GEN-ParentName-EIN-crosswalk.Rda: Contains two data frames.
    * `EIN_GEN_crosswalk` is a data frame with `EIN`, `GEN`, `EIN_NAME` and `GEN_NAME`. This is a list of all EIN's that have a known GEN. 
    * `GEN_ParentName_crosswalk` is a data frame with all known GEN's, the respective parent name, then a list of all EIN's that are known to use that GEN.
  
  
  
  