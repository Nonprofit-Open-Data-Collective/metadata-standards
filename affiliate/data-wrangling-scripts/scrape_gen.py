#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul 24 23:30:10 2023

@author: oliviabeck
"""

import requests
import re
from bs4 import BeautifulSoup
import time
import pandas as pd
import xml.etree.ElementTree as ET


#tic = time.time()

#ein = "10018605"
#url = "https://projects.propublica.org/nonprofits/organizations/" + ein
#page = requests.get(url)


#soup = BeautifulSoup(page.content, "html.parser")

#href_string = soup.find(class_='filings').find(class_="single-filing cf").find(class_="left-label").find(class_="action xml")

#href_string2 = str(href_string)

#pattern = r'href="([^"]*)"'

#matches = re.findall(pattern, href_string2)
#url2 = "https://projects.propublica.org" + matches[0]

#response = requests.get(url2)
#root = ET.fromstring(response.content)
#namespace = {"irs": "http://www.irs.gov/efile"}
#roup_exemption_num_element = root.find(".//irs:GroupExemptionNum", namespaces=namespace)
#group_exemption_num = group_exemption_num_element.text
#ret = group_exemption_num

#toc = time.time()

#toc - tic

#######################


pattern = r'href="([^"]*)"'


def scrape_gen(ein):
    url = "https://projects.propublica.org/nonprofits/organizations/" + ein
    
    
    try:
        #open link
        page = requests.get(url)
        #parse page
        soup = BeautifulSoup(page.content, "html.parser")
        #extract most recent 990 link
        href_string = soup.find(class_='filings').find(class_="single-filing cf").find(class_="left-label").find(class_="action xml")
        #make a string
        href_string2 = str(href_string)
        #extract the relevent link
        matches = re.findall(pattern, href_string2)
        url2 = "https://projects.propublica.org" + matches[0]
        #open link
        response = requests.get(url2)
        root = ET.fromstring(response.content)
        namespace = {"irs": "http://www.irs.gov/efile"}
        #extract exemption number
        group_exemption_num_element = root.find(".//irs:GroupExemptionNum", namespaces=namespace)
        group_exemption_num = group_exemption_num_element.text
        ret = group_exemption_num
        return(ret)
    except:
        return(pd.NA)
    
    
# get_group_exemption_num("10018605")
  

#get EIN's  
all_group_data = pd.read_csv("data-rodeo/all-group-ein-last5.csv")

data = {'EIN': all_group_data["ein"], 'group_num': 0}
df = pd.DataFrame(data).drop_duplicates().reset_index(drop=True)

#find
for i in range(df.shape[0]):
  ein_temp = str(df.EIN[i])
  group_num_temp = get_group_exemption_num(ein_temp)
  df.group_num[i] = group_num_temp

#save 
df.to_csv("data-rodeo/ein-with-group-num.csv", index=False)    
   
