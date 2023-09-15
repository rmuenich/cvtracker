## Academic COI Tracker

Like many researchers, I try to focus my time on developing new ideas and creating new work, not on paperwork. Yet we are asked to constantly keep track of potential COI's in very long forms with different requirements for formatting across different agencies. Therefore, I developed the code here to read in a database of all of your COIs (you will have to make, but you can import things from ORCID if you want to automate that) and then filter COIs based on date, remove duplicates while keeping most recent COI, then spit out CSV files that can be copied into the templates. For now I have only done this for NSF and USDA, but if you'd like to collaborate on other agencies please let me know!

If this saves you some time let me know, it is saving me time!

### Files in this repository

* COIMGT.xlsx - this is a fake example of COIs :) 
* NSFCOA_T3_Muenich_[DATE].xlsx - example of running the code for NSF time period, table 3
* NSFCOA_T4_Muenich_[DATE].xlsx - example of running the code for NSF time period, table 4
* USDACOA_Muenich_[DATE].xlsx - example of running the code for USDA time period and format
* walkthrough.html and .RMD - the code in an html document created from the R markdown

**Currently Includes**

* NSF Tables 3 & 4
    + [current NSF COA](https://new.nsf.gov/funding/senior-personnel-documents#collaborators-and-other-affiliations-2b3)
* USDA COI 
    + [current USDA COI](https://www.nifa.usda.gov/application-support-templates)


*To learn more about linking to ORCID*

I may update this later to link to ORCID so you don't have to maintain the database. I used ORCID for my CV, but it doesn't have all potential COIs, like proposals under review. So that is why I went with this. But if you want to learn more check out: (https://ciakovx.github.io/rorcid.html)