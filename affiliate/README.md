Reproducible files for defining a new taxonomy of nonprofit affiliation structures and assigning organizations group IDs and group roles. 


Folder Structure: 

* data-raw: all raw data files 
* data-wrangling-scripts: all R scripts for data wrangling, including user-defined funcitons 
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
  * dat-group-info.csv: information from all orgs listed in nccs bmf, irs bmf, soi, or core files that could possibly be part of a group. Only information pertaining to group structure has been kept. 