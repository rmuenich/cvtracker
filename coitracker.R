library(tidyverse)
library(readxl)
library(lubridate)

coi<-read_excel("COIMGT.xlsx")
coi$`COI TYPE`<-as.factor(coi$`COI TYPE`)
coi$fullname<-paste(coi$`COI Last Name`,coi$`COI First Name`,sep=", ")

str(coi) #checking that dates read in correctly

### Select how far back to look for COI ###
### NSF is 48 months
### USDA is 36 months
### NOAA is 48 months
setback<-48 ## set number of months here
today<-date(now())
coidate<-date(now()-months(setback)) 

# filter your COIs for ending dates after your COI date
cois<-coi[coi$Enddate>coidate,]

### Separate by type of COI
## for most agencies they want to know the type of COI, so we want to separate by COI type, then remove duplicates within each category, before recombining to summarize
# I only have collaborators, co-authors, and mentees/advisors categories but you could add more if needed
### IF NOAA SKIP TO NOAA SECTION DON'T RUN THESE ###
cois_c<-cois[cois$`COI TYPE`=="grant",]
cois_a<-cois[cois$`COI TYPE`=="publication",]
cois_m<-coi[coi$`COI TYPE`=="mentee" | coi$`COI TYPE`== "mentor",] #not I don't use filtered version bc last active date doesn't matter here

# here I am just removing any duplicates and keeping the more recent COI in case of duplicates.
# when this function removes duplicates it keeps first listed, so that's why we arrange by most recent first
cois_c<-cois_c %>%
  arrange(desc(Enddate)) %>%
  distinct(fullname, .keep_all = TRUE)
cois_a<-cois_a %>%
  arrange(desc(Enddate)) %>%
  distinct(fullname, .keep_all = TRUE)
cois_m<-cois_m %>%
  arrange(desc(Enddate)) %>%
  distinct(fullname, .keep_all = TRUE)


#######################################
##### CREATING NSF TABLE 4 OF COA #####
#######################################

#NSF COI as of 9/12/2023
#List names as last name, first name, middle initial, and provide organizational affiliations, if known, for the following:
### Co-authors on any book, article, report, abstract or paper with collaboration in the last 48 months (publication date may be later); and
### Collaborators on projects, such as funded awards, graduate research or others in the last 48 months. 

#now we are ready to write this into a csv that you can then copy over to your NSF COA template in Table 4
#a/c, name (last name, first), affiliation, email, last active
nsfcois_write<-rbind(cois_c,cois_a)
nsfcois_write<-nsfcois_write %>%
  arrange(fullname)
nsfcois_write$nsftype<-ifelse(nsfcois_write$`COI TYPE`=="grant","C:","A:")

write.csv(nsfcois_write[,c("nsftype","fullname","COI Institution","Enddate")], paste0("NSFCOA_T4_Muenich_",today,".csv"), row.names = FALSE)


#######################################
##### CREATING NSF TABLE 3 OF COA #####
#######################################
#In Table 3, NSF wants you to list names as last name, first name, middle initial, and provide organizational affiliations, if known, for the following: 
###• G The individual’s Ph.D. advisors; and
###• T All of the individual’s Ph.D. thesis advisees.
nsfcois_write <- cois_m %>%
  arrange(fullname)
nsfcois_write$nsftype<-ifelse(nsfcois_write$`COI TYPE`=="mentor","G:","T:")

write.csv(nsfcois_write[,c("nsftype","fullname","COI Institution")], paste0("NSFCOA_T3_Muenich_",today,".csv"), row.names = FALSE)


#######################################
#####   CREATING USDA COI LIST    #####
#######################################

#USDA COI as of 9/12/2023
# USDA COI List requires you to list alphabetically – with last name first -- the full names of the following individuals:
###- All co-authors on publications within the past three years, including pending publications and submissions
###- All collaborators on projects within the past three years, including current and planned collaborations
###- All thesis or postdoctoral advisees/advisors
###- All persons in your field with whom you have had a consulting/financial arrangement/other conflict-of-interest in the past three years
#name (Last, first), co-author, collaborator, advisee/advisor, other-specify

####START HERE SKIP REST
usdacois_agg<-cois %>%
  arrange(fullname) %>%
  distinct(fullname, .keep_all = TRUE)

usdacois_agg$C<-ifelse(usdacois_agg$fullname %in% cois_c$fullname,"X","")
usdacois_agg$A<-ifelse(usdacois_agg$fullname %in% cois_a$fullname,"X","")
usdacois_agg$M<-ifelse(usdacois_agg$fullname %in% cois_m$fullname,"X","")


# write csv to copy to USDA template
#name (Last, first), co-author, collaborator, advisee/advisor, other-specify
write.csv(usdacois_agg[,c("fullname","A","C","M")], paste0("USDACOI_Muenich_",today,".csv"), row.names = FALSE)

#######################################
#####   CREATING NOAA COI LIST    #####
#######################################

#NOAA COI as of 8/12/2024
# NOAA COI List requires you to list in separate columns the first name, last name, and institution of the following individuals:
# Collaborators are individuals who have participated in a project or publication within the last 48 months with any 
# investigator, including co-authors on publications. Collaborators also include those persons with whom the investigators 
# may have ongoing collaboration negotiations. Advisees and advisors do not have a time limit. Advisees are persons with 
# whom the individual investigator has had an association as thesis or dissertation advisor or postdoctoral sponsor. Advisors
# include an individual’s own graduate and postgraduate advisors. Unfunded participants in the proposed study should also be 
# included on the list, but not their collaborators.

####need to remove duplicates
noaacois_agg<-cois %>%
  arrange(fullname) %>%
  distinct(fullname, .keep_all = TRUE)


# write csv to copy to NOAA template
#First Name, Last Name, Institution
write.csv(noaacois_agg[,c("COI First Name","COI Last Name","COI Institution")], paste0("NOAACOI_Muenich_",today,".csv"), row.names = FALSE)
