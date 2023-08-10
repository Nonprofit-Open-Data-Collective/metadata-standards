Replication files documenting a new political action taxonomy and assigning nonprofits to various roles based upon their mission, level of public 'education' activities, lobbying, advocacy, affiliations with political organizations, and political spending. 

Notes: 

* operationalizing a taxonomy that differentiates things like advocacy, lobbying, electioneering, or strengthening democracy (focus on systems, not issues?)
* building a decision tree with indicators on 990 forms and other administrative datasets to assign orgs to these non-mutually-exclusive groups
* using additional administrative data like shared boards or staff, related entity disclosures, grants, etc to identify organizational partnerships (link 501c3, 501c4, and 527 entities) 
* develop a process to validate these data-driven classifications using some ground truth for a small set of orgs or case studies (other archival media sources or interviews)

---

I don't know the literature that well, but I would look for articles that either provide frameworks or else study one specific segment (like Elizabeth and Margaret's piece on "politically active" 501c4s), where the authors have to state their definition of a group and describe their inclusion criteria. The broad categories that come to mind are (1) advocacy and education, (2) lobbying or influencing legislation, and (3) politiking or influencing elections. There might be other useful distinctions - for example are voter registration, grassroots organizing, and campaign finance reform efforts a separate category of "promoting democratic practices" or are those advocacy or politiking? Some examples: 

Mosley, J. E., Weiner-Davis, T., & Anasti, T. (2020). Advocacy and lobbying. In The Routledge companion to nonprofit management (pp. 335-348). Routledge.

Raffa, T. (2000). Advocacy and lobbying without fear: What is allowed within a 501 (c)(3) charitable organization. Nonprofit Quarterly, 7(2), 44-47.

LeRoux, K. (2007). Nonprofits as civic intermediaries: The role of community-based organizations in promoting political participation. Urban Affairs Review, 42(3), 410-422.

Berg, K. T. (2009). Finding connections between lobbying, public relations and advocacy. Public Relations Journal.

You might also look to regulations like H Elections and legal limits placed on nonprofit activities - laws would have legal definitions of specific activities that could be helpful. 

The goal would be to create technical definitions of each term so that distinctions are clear and can be operationalized as distinct activities within the data. I would assume the categories would not be mutually exclusive? Some orgs could do both advocacy and lobbying, for example. But that is different than the casual use of the terminology in some of the literature where the activities are basically used interchangeably: 

Dellmuth, L. M., & Tallberg, J. (2017). Advocacy strategies in global governance: Inside versus outside lobbying. Political Studies, 65(3), 705-723.

Mahoney, C., & Baumgartner, F. R. (2015). Partners in advocacy: Lobbyists and government officials in Washington. The Journal of Politics, 77(1), 202-215.

For example, do "policy advocacy" and "political advocacy" actually mean lobbying? When would advocacy be distinct from lobbying? 

Leroux, K., & Goerdel, H. T. (2009). Political advocacy by nonprofit organizations: A strategic management explanation. Public performance & management review, 32(4), 514-536.

Lu, J. (2018). Organizational antecedents of nonprofit engagement in policy advocacy: A meta-analytical review. Nonprofit and Voluntary Sector Quarterly, 47(4_suppl), 177S-203S.

Once you have the distinct groups operationalized on a conceptual level then we can see if we can proceduralize identification from the administrative data. I would start by building a list of all potential indicators on the 990 forms and schedules or related datasets (527 orgs file Form 8871 and 8872). 
Header, Box I, checkbox for 527 orgs 
990, Part IV, Q3:  Did the organization engage in direct or indirect political campaign activities on behalf of or in opposition to candidates for public office? 
Schedule C, checkbox on H Election. 
Schedule C, lobbying expenses > 0.  
Keywords in org name (header), mission (990 Part III), or program activities (990 Part III)
I think we might have maybe a dozen indicators on the forms and another dozen useful variables on Schedule C and Schedule R? From there we create a decision tree to categorize orgs, eg: 

If B=true and C > 0 then Lobbying 

The other data exercise would be identifying linked organizations, or answering the question of whether an org has a lobbying or political arm. They might disclose this on the items above, but we might also link orgs through shared boards or staff (990 Part VII), grants to partner organizations (Schedule I), disclosure of related entities (Schedule R?), political donations (527 form 8872?), or lobbying expenditures (Senate Office of Public Records through OpenSecrets?). 

Then the harder question is validating the taxonomy. Do the decision rules above misclassify any organizations? Are there relationships that cannot be observed through all of the disclosed linkages? Here is where your efforts could be very meaningful, especially if you are able to interview nonprofits about their activities and their strategies for deploying specific organizational configurations. 

---

I agree that one of the barriers to creating a useful taxonomy is the variation in definitions and terms.

You might also look to regulations like H Elections and legal limits placed on nonprofit activities - laws would have legal definitions of specific activities that could be helpful.

I have found that legal definitions do seem to be the most clear cut - whereas functional definitions and the universe of terms used by academics to describe the activities of organizations are a bit more muddled and overlapping.

The goal would be to create technical definitions of each term so that distinctions are clear and can be operationalized as distinct activities within the data. I would assume the categories would not be mutually exclusive? Some orgs could do both advocacy and lobbying, for example.

Here, I think we would need to start with a basic understanding of what constitutes "an organization"... as in, is it the singularly registered entity? Does it include affiliates, chapters, or subsidiaries? How to determine this varies drastically between function, legal, and operational understandings of organizations.

As for Form 990 Points of Interest, I have compiled several that I think are worth further investigation:

* Part IV, 3. Did the organization engage in direct or indirect political campaign activities on behalf of or in opposition to candidates for public office? If “Yes,” complete Schedule C, Part I.
*  Part IV, 4. Section 501(c)(3) organizations. Did the organization engage in lobbying activities or have a section 501(h) election in effect during the tax year? If “Yes,” complete Schedule C, Part II.
*  Part IV, 34. Was the organization related to any tax-exempt or taxable entity? If “Yes,” complete Schedule R, Part II, III, or IV, and Part V, line I.
* Part IV 35a and b? Clarify question.
* Part IV, 36. Section 501(c)(3) organizations. Did the organization make any transfers to an exempt non-charitable related organization? If “Yes,” complete Schedule R, Part V, line 2.
* Part VI. Schedule A. Section B. Policies. 10a. Did the organization have local chapters, branches, or affiliates?
* Part VI. Schedule A. Section C. Disclosure. 17. List the states with which a copy of this Form 990 is required to be filed.
* Part VIII. Statement of Revenue. 2a. Services to affiliates.
* Part IX. Statement of Functional Expenses. 1. Grants and other assistance to domestic organizations and domestic governments.
* Part IX. Statement of Functional Expenses. 11. Fees for services (non-employees) a. Lobbying.
* Schedule A. Part 1. Reason for Public Charity Status.
* Schedule C. Political Campaign and Lobbying Activities. Part II-A. 1a. Total lobbying expenditures to influence pubic opinion (grassroots lobbying)
* Schedule C. Political Campaign and Lobbying Activities. Part II-A. 1b. …(direct lobbying).
* Schedule I. Grants and other assistance to organizations, governments and individuals in the United States.
* Schedule J. Compensation Information. Part II. Officers, Directors, Trustees, Key Employees, and Highest Compensated Employees
* Schedule O. Supplemental Information.
* Schedule R. Part I.
* Schedule R. Part II. Identification of Tax-Exempt Organizations.&nbsp;§&nbsp; Primary Activity&nbsp;§&nbsp; Exempt Code section&nbsp;§&nbsp; Direct controlling entity
* Schedule R. Part V. Transactions with Related Organizations.

§ (e.g. Planned Parenthood Federation of America was involved in transactions with Planned Parenthood Action Fund Inc. for upwards of $25M – which includes paying rent, funding of solicitations, etc.)

Once you have the distinct groups operationalized on a conceptual level then we can see if we can proceduralize&nbsp;identification from the administrative data. I would start by building a list of all potential indicators on the 990 forms and schedules or related datasets (527 orgs file Form 8871 and 8872).
Header, Box I, checkbox for 527 orgs
990, Part IV, Q3:&nbsp;&nbsp;Did the organization engage in direct or indirect political campaign activities on behalf of or in opposition to candidates for public office?
Schedule C, checkbox on H Election.
Schedule C, lobbying expenses &gt; 0.
Keywords in org name (header), mission (990 Part III), or program activities (990 Part III)
I think we might have maybe a dozen indicators on the forms and another dozen useful variables on Schedule C and Schedule R? From there we create a decision tree to&nbsp;categorize orgs, eg:

If B=true and C &gt; 0 then Lobbying

The other data exercise would be identifying linked organizations, or answering the question of whether an org has a lobbying or political arm. They might disclose this on the items above, but we might also link orgs through shared boards or staff (990 Part VII), grants to partner organizations (Schedule I), disclosure of related entities (Schedule R?), political donations (527 form 8872?), or lobbying expenditures (Senate Office of Public Records through OpenSecrets?).

Then the harder question is validating the taxonomy. Do the decision rules above misclassify any organizations? Are there relationships that cannot be observed through all of the disclosed linkages? Here is where your efforts could be very meaningful, especially if you are able to interview nonprofits about their activities and their strategies for deploying specific organizational configurations.
