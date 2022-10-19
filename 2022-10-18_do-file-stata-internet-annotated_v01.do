***************************************************************************************************************************************************************************************************************************
***SYNTAX FOR "The influence of socio-economic factors on patterns of internet use among older adults before and during the COVID-19 pandemic: A latent transition analysis of the English Longitudinal Study of Ageing"***
***************************************************************************************************************************************************************************************************************************

* STATA version: 17.0, BE-Basic Edition

* STATA citation: StataCorp. 2021. Stata Statistical Software: Release 17. College Station, TX: StataCorp LLC. 

* Data citation (main ELSA survey): Banks, J., Batty, G. David, Breedvelt, J., Coughlin, K., Crawford, R., Marmot, M., Nazroo, J., Oldfield, Z., Steel, N., Steptoe, A., Wood, M., Zaninotto, P. (2021). English Longitudinal Study of Ageing: Waves 0-9, 1998-2019. [data collection]. 37th Edition. UK Data Service. SN: 5050, DOI: 10.5255/UKDA-SN-5050-24

* Data citation (COVID-19 sub-study): Steptoe, A., Addario, G., Banks, J., Batty, G. David, Coughlin, K., Crawford, R., Dangerfield, P., Marmot, M., Nazroo, J., Oldfield, Z., Pacchiotti, B., Steel, N., Wood, M., Zaninotto, P. (2021). English Longitudinal Study of Ageing COVID-19 Study, Waves 1-2, 2020. [data collection]. 2nd Edition. UK Data Service. SN: 8688, DOI: 10.5255/UKDA-SN-8688-2

* Data access statement: ELSA data from the main survey (SN 5050) and the COVID-19 sub-study (SN 8688) are available through the UK Data Service (https://ukdataservice.ac.uk/). The main ELSA dataset is safeguarded and can be accessed via https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=5050#!/access-data. The COVID-19 sub-study can be accessed via https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=8688#!/access-data. More information on how to access ELSA, including the conditions of use, can be found on the UK Data Service website (main ELSA survey: https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=5050#!/details; COVID-19 sub-study: https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=8688#!/details) and the ELSA website (main ELSA survey: https://www.elsa-project.ac.uk/accessing-elsa-data; COVID-19 sub-study: https://www.elsa-project.ac.uk/covid-19-data).

* Date of data access/download (dd/mm/yyyy): 17/12/2021

* Project ID: 217429

* Data documentation: Documentation pertaining to ELSA (e.g., data dictionaries, questionnaires, technical reports, user guides) is available on the UK Data Service website (main ELSA survey: https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=5050#!/documentation; COVID-19 sub-study: https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=8688#!/documentation) and the ELSA website (main ELSA survey: https://www.elsa-project.ac.uk/data-and-documentation; COVID-19 sub-study: https://www.elsa-project.ac.uk/covid-19-data).

*********************
***DATA PROCESSING***
*********************

* Change working directory - add pathname in between quotation marks for Windows
cd ""

* Variables Wave 9
use idauniq scint scinddt scindlt scindtb scindph scind95 scind96 scinaem scinacl scinaed scinabk scinash scinasl scinasn scinact scinanw scinast scinagm scinajb scinaps scina95 scina96 scinahe w9nssec8 w9nssec3 samptyp w9xwgt w9scwt indsex indager dimarr fqethnmr wpdes hhtot heill helim using wave_9_elsa_data_eul_v1.dta
* Describe dataset
describe
* Sort from lowest to highest participant identifier (ID)
sort idauniq
* Rename variables to shorter forms
rename w9nssec8 nssec8
rename w9nssec3 nssec3
rename indsex Sex
* Generate a new variable called wave and assign the number 9 to each observation (to designate Wave 9)
gen wave = 9
* Save Wave 9 core dataset
save wave9internet.dta

* Variables COVID Wave 1
use idauniq CvIntA CvIntB CvIntC01 CvIntC02 CvIntC03 CvIntC04 CvIntC05 CvIntC06 CvIntC07 CvIntC08 CvIntC09 CvIntC10 CvIntC11 CvIntC12 CvIntD CvIntE01 CvIntE02 CvIntE03 CvIntE04 CvIntE05 CvIntE06 CvIntE07 CvIntE08 CvIntE980 CvIntE990 CvIntE995 CvIntE998 FinStat Cohort CorePartner wtfin1 wtfin2 cov19lwgt Sex Age_Arch RelStat Ethnicity_arch CvPred CvPstd CvNumP heill_updated helim_updated using elsa_covid_w1_eul.dta
* Describe dataset
describe
* Sort from lowest to highest participant ID
sort idauniq
* Generate a new variable called wave and assign the number 10 to each observation (to designate COVID Wave 1)
gen wave = 10
* Save COVID Wave 1 core dataset
save covidwave1internet.dta

* Variables Wave 9 Derived
use idauniq edqual using wave_9_ifs_derived_variables.dta
* Describe dataset
describe
* Sort from lowest to highest participant ID
sort idauniq
* Save Wave 9 derived dataset
save wave9derived.dta

* Variables Wave 9 Financial Derived
use idauniq totwq5_bu_s using wave_9_financial_derived_variables.dta
* Describe dataset
describe
* Sort from lowest to highest participant ID
sort idauniq
* Save Wave 9 financial dataset
save wave9financial.dta

* Wave 9 complete data
* Merge core, derived, and financial datasets for Wave 9 using the participant ID
use wave9internet.dta
* One-to-one merge of data in memory with wave9financial.dta on participant ID
merge 1:1 idauniq using wave9financial.dta, generate (merge_financial9)
* Overwrite Wave 9 dataset, by replacing the previously saved file
save wave9internet.dta, replace
* Use the newly saved file for Wave 9
use wave9internet.dta
* One-to-one merge of data in memory with wave9derived.dta on participant ID
merge 1:1 idauniq using wave9derived.dta, generate (merge_derived9)
* Sort from lowest to highest participant ID
sort idauniq
* Overwrite Wave 9 dataset, by replacing the previously saved file
save wave9internet.dta, replace

* Append Wave 9 and COVID Wave 1 datasets
use wave9internet.dta
append using covidwave1internet.dta
* Sort by participant ID and wave (lowest to highest)
sort idauniq wave
* Assigns a number in ascending order to each row of observations
gen ascnr = _n

* Unique individual serial number (personal ID)
* Replace variable as missing for any missing cases (coded as negative numbers in the ELSA dataset)
replace idauniq = . if idauniq<0

* Organising dataset
* Generate a variable that assigns the observation number (i.e., 1 for first data collection timepoint, 2 for second data collection timepoint) to each row by participant ID
bysort idauniq (wave): gen obsnr = _n
* Generate a variable that assigns the number of total observations to each row of data for a given participant
bysort idauniq: gen obscount = _N
* Check how many participants have data at 1 or 2 timepoints - the "if obsnr==1" statement is used to prevent participants with data at two timepoints from contributing to the counts twice
tabulate obscount if obsnr==1
* Generate a variable that assigns the number 1 to the row representing participants' first observation
bysort idauniq (wave): gen first = 1 if _n==1
* Generate a variable that assigns the number 1 to the row representing participants' last observation
bysort idauniq (wave): gen last = 1 if _n==_N
* Generate a variable that assigns the number 1 to the row representing participants' first observation if this corresponds to Wave 9 (baseline)
bysort idauniq (wave): gen firstwave = 1 if obsnr==1 & wave==9
* Carry the value of this last variable forwards to the remainder of a participant's observations 
bysort idauniq: gen variable = firstwave[1]
* Install unique command
ssc install unique
* Count total number of participants and observations
unique idauniq
* 9,043 individuals, 15,776 observations
* Assign the COVID Wave 1 longitudinal weight to all observations for a participant
bysort idauniq(wave): replace cov19lwgt = cov19lwgt[2]
* Drop if participant is not a core member
drop if (samptyp !=1 & wave==9) | (inlist(wtfin1,-1,.) & wave==10)
* Count total number of participants and observations
unique idauniq
* 7,489 individuals, 13,074 observations
* Replace age = 90 if participant is aged 90+ years (collapsed in ELSA and coded as -7 at Wave 9)
replace indager = 90 if indager==-7
* Drop observation if the participant is aged less than 60 years at Wave 9
drop if indager < 60 & wave==9
* Count total number of participants and observations
unique idauniq
* 7,097 individuals, 11,687 observations
* Check how many participants have data at Wave 9
tab firstwave
* Drop if age data are missing at Wave 9
drop if indager ==. & wave==9
* Count total number of participants and observations
unique idauniq
* 7,097 individuals, 11,687 observations
tab Age_Arch
* Drop observation if the participant is aged less than 60 years at COVID Wave 1
drop if Age_Arch < 60 & wave==10
* Count total number of participants and observations
unique idauniq
* 6,187 individuals, 10,777 observations
* Drop if age data are missing at COVID Wave 1
drop if Age_Arch ==. & wave==10
* Count total number of participants and observations
unique idauniq
* 6,187 individuals, 10,777 observations
* Save dataset with a new name
save dataLCA.dta

* Internet frequency (Wave 9, COVID Wave 1)
* Wave 9
* Replace variables as missing for any missing cases (coded as negative numbers in the ELSA dataset)
replace scint = . if scint<0
* Generate a new variable
gen frequency = .
* Assign the number 0 if the participant never used the internet or email
replace frequency = 0 if scint == 6
* Assign the number 1 if the participant used the internet or email at least once a month (but not every week), at least once every 3 months, or less than every 3 months
replace frequency = 1 if inlist(scint,3,4,5)
* Assign the number 2 if the participant used the internet or email at least once a week (but not every day)
replace frequency = 2 if scint == 2
* Assign the number 3 if the participant used the internet or email every day, or almost every day
replace frequency = 3 if scint == 1
* COVID Wave 1
* Replace variables as missing for any missing cases (coded as negative numbers in the ELSA dataset)
replace CvIntA = . if CvIntA<0
* Assign the number 0 if the participant never used the internet
replace frequency = 0 if CvIntA == 6
* Assign the number 1 if the participant used the internet at least once a month (but not every week), or less than monthly
replace frequency = 1 if inlist(CvIntA,4,5)
* Assign the number 2 if the participant used the internet at least once a week (but not every day)
replace frequency = 2 if CvIntA == 3
* Assign the number 3 if the participant used the internet more than once a day, every day, or almost every day
replace frequency = 3 if inlist(CvIntA,1,2)
* Coding of final internet frequency variable:
* 0: Never
* 1: Low frequency (At least once a month, but not every week/Less than monthly/At least once every three months/Less than every three months)
* 2: Moderate frequency (At least once a week, but not every day)
* 3: High frequency (More than once a day/Every day, or almost every day)

* Highest Educational Qualification (Wave 9)
* Excluded foreign/other
* Replace variable as missing for any missing cases (coded as negative numbers in the ELSA dataset)
replace edqual = . if edqual<0
* Check participant counts in each category at Wave 9
tab edqual if wave==9
* Generate a new variable
gen educanew = .
* Assign the number 0 if the participant does not have any formal qualifications
replace educanew = 0 if edqual == 7
* Assign the number 1 if the participant has A level equivalent, O level equivalent, or other grade equivalent
replace educanew = 1 if inlist(edqual,3,4,5)
* Assign the number 2 if the participant has completed some higher education (below degree), or has a degree or equivalent
replace educanew = 2 if inlist(edqual,1,2)
* Coding of final education variable:
* 0: No formal qualifications
* 1: School qualifications
* 2: Higher education

* NS-SEC 8 and 3 category classification (Wave 9)
* Excluded Never worked and long-term unemployed
* Replace variables as missing for any missing cases (coded as negative numbers or 99 in the ELSA dataset)
replace nssec8 = . if nssec8<0
replace nssec8 = . if nssec8 == 99
replace nssec3 = . if nssec3<0
replace nssec3 = . if nssec3 == 99
* Generate a new variable
gen mynssec3 = .
* Assign the number 2 if the participant's current or most recent occupation was coded as: Higher managerial, administrative and professional occupations; or Lower managerial, administrative and professional occupations
replace mynssec3 = 2 if inlist(nssec8,1,2)
* Assign the number 1 if the participant's current or most recent occupation was coded as: Intermediate occupation; or Small employers and own account workers
replace mynssec3 = 1 if inlist(nssec8,3,4)
* Assign the number 0 if the participant's current or most recent occupation was coded as: Lower supervisory and technical occupations; or Semi-routine occupations; or Routine occupations
replace mynssec3 = 0 if inlist(nssec8,5,6,7)
* Coding of final occupational class variable:
* 0: Lower occupations
* 1: Intermediate occupations
* 2: Higher occupations

* Quintiles of BU total (non-pension) wealth (Wave 9)
* Replace variable as missing for any missing cases (coded as negative numbers in the ELSA dataset)
replace totwq5_bu_s = . if totwq5_bu_s<0
* Coding of final wealth variable:
* 1: 1st quintile (lowest)
* 2: 2nd quintile
* 3: 3rd quintile
* 4: 4th quintile
* 5: 5th quintile (highest)

* Biological sex (Wave 9, COVID Wave 1)
* Replace variable as missing for any missing cases (coded as negative numbers in the ELSA dataset)
replace Sex = . if Sex<0
* Assign the number 0 if the participant is male
replace Sex = 0 if Sex == 1
* Assign the number 1 if the participant is female
replace Sex = 1 if Sex == 2
* Coding of the final biological sex variable:
* 0: Male, 1: Female

* Ethnicity (Wave 9, COVID Wave 1)
* Wave 9
* Replace variable as missing for any missing cases (coded as negative numbers in the ELSA dataset)
replace fqethnmr = . if fqethnmr<0
* Assign the number 0 if the participant is White
replace fqethnmr = 0 if fqethnmr == 1
* Assign the number 1 if the participant is Non-White
replace fqethnmr = 1 if fqethnmr == 2
* COVID Wave 1
* Assign the number 0 if the participant is Non-BAME
replace Ethnicity_arch = 0 if Ethnicity_arch == 1
* Assign the number 1 if the participant is BAME
replace Ethnicity_arch = 1 if Ethnicity_arch == 2
* Coding of the final ethnicity variable:
* 0: White, 1: Non-White

* Current employment situation (Wave 9, COVID Wave 1)
* Replace variables as missing for any missing cases (coded as negative numbers in the ELSA dataset)
replace wpdes = . if wpdes<0
replace CvPstd = . if CvPstd<0

* Number of people in household (Wave 9, COVID Wave 1)
* Wave 9
* Replace variable as missing for any missing cases (coded as negative numbers or 0 in the ELSA dataset)
replace hhtot = . if hhtot<0
replace hhtot = . if hhtot==0
* Assign the number 0 if one person lives in household
replace hhtot = 0 if hhtot==1
* Assign the number 1 if more than one person lives in household
replace hhtot = 1 if hhtot>1 & hhtot != .
* COVID Wave 1
* Replace variable as missing for any missing cases (coded as negative numbers or 0 in the ELSA dataset)
replace CvNumP = . if CvNumP<0
* Assign the number 0 if one person lives in household
replace CvNumP = 0 if CvNumP==1
* Assign the number 1 if more than one person lives in household
replace CvNumP = 1 if CvNumP>1 & CvNumP != .
* Coding of the final living status variable:
* 0: Living alone, 1: Not living alone

* Age categorical (Wave 9, COVID Wave 1)
* Generate a new variable
gen age_cat = .
* Assign the number 0 for participants aged 60-69 years at Wave 9
replace age_cat = 0 if indager >= 60 & indager <= 69
* Assign the number 1 for participants aged 70-79 years at Wave 9
replace age_cat = 1 if indager >= 70 & indager <= 79
* Assign the number 2 for participants aged 80+ years at Wave 9 and without missing age data
replace age_cat = 2 if indager >= 80 & indager != .
* Assign the number 0 for participants aged 60-69 years at COVID Wave 1
replace age_cat = 0 if Age_Arch >= 60 & Age_Arch <= 69
* Assign the number 1 for participants aged 70-79 years at COVID Wave 1
replace age_cat = 1 if Age_Arch >= 70 & Age_Arch <= 79
* Assign the number 2 for participants aged 80+ years at COVID Wave 1 and without missing age data
replace age_cat = 2 if Age_Arch >= 80 & Age_Arch != .
* Coding of the final categorical age variable:
* 0: 60-69 years
* 1: 70-79 years
* 2: 80+ years

* Limiting long-standing illness (Wave 9)
* Generate a new variable and assign the number 0 for participants with no long-standing illness or a long-standing illness that is not limiting 
gen limiting = 0 if heill == 2 | helim == 2
* Assign the number 1 for participants with a limiting long-standing illness
replace limiting = 1 if helim == 1
* Coding of the final limiting long-standing illness variable:
* 0: No long-standing illness or not limiting, 1: Limiting long-standing illness

* Save dataset with a new name
save data01LCA.dta

* Time-constant education - Wave 9
* Generate a new variable duplicating the education variable at Wave 9
gen educa_cons = educanew if wave==9
* Declare a panel dataset with participant ID "idauniq" and time variable "wave" 
tsset idauniq wave
* Install carryforward command
ssc install carryforward
* Generate a completely balanced dataset (i.e., all participants have a row for each wave)
tsfill, full
* Carryforward observations with respect to the time variable "wave" (i.e., from Wave 9 to COVID Wave 1) by participant ID
bysort idauniq: carryforward educa_cons, replace

* Time-constant occupational class - Wave 9
* Generate a new variable duplicating the occupational class variable at Wave 9
gen mynssec3_cons = mynssec3 if wave==9
* Declare a panel dataset with participant ID "idauniq" and time variable "wave" 
tsset idauniq wave
* Carryforward observations with respect to the time variable "wave" (i.e., from Wave 9 to COVID Wave 1) by participant ID
bysort idauniq: carryforward mynssec3_cons, replace

* Time-constant wealth - Wave 9
* Generate a new variable duplicating the wealth variable at Wave 9
gen wealth_cons = totwq5_bu_s if wave==9
* Declare a panel dataset with participant ID "idauniq" and time variable "wave" 
tsset idauniq wave
* Carryforward observations with respect to the time variable "wave" (i.e., from Wave 9 to COVID Wave 1) by participant ID
bysort idauniq: carryforward wealth_cons, replace

* Time-constant biological sex - Wave 9
* Generate a new variable duplicating the biological sex variable at Wave 9
gen sex_cons = Sex if wave==9
* Declare a panel dataset with participant ID "idauniq" and time variable "wave" 
tsset idauniq wave
* Carryforward observations with respect to the time variable "wave" (i.e., from Wave 9 to COVID Wave 1) by participant ID
bysort idauniq: carryforward sex_cons, replace

* Time-constant age category - Wave 9
* Generate a new variable duplicating the categorical age variable at Wave 9
gen age_cons = age_cat if wave==9
* Declare a panel dataset with participant ID "idauniq" and time variable "wave" 
tsset idauniq wave
* Carryforward observations with respect to the time variable "wave" (i.e., from Wave 9 to COVID Wave 1) by participant ID
bysort idauniq: carryforward age_cons, replace

* Limiting long-standing illness - Wave 9 (and updated in COVID Wave 1 for non-responders)
* Generate a new variable duplicating the limiting long-standing illness variable at Wave 9
gen limiting_cons = limiting if wave==9
* Declare a panel dataset with participant ID "idauniq" and time variable "wave" 
tsset idauniq wave
* Carryforward observations with respect to the time variable "wave" (i.e., from Wave 9 to COVID Wave 1) by participant ID
bysort idauniq: carryforward limiting_cons, replace
* Assign the number 0 for participants with no long-standing illness or a long-standing illness that is not limiting at COVID Wave 1
replace limiting_cons = 0 if heill_updated == 2 | helim_updated == 2
* Assign the number 1 for participants with a limiting long-standing illness at COVID Wave 1
replace limiting_cons = 1 if helim_updated == 1

* Save dataset with a new name
save data02LCA.dta

* Time variable
* Generate a new variable
gen Time = .
* Assign the number 0 for observations at Wave 9
replace Time = 0 if wave==9
* Assign the number 1 for observations at COVID Wave 1
replace Time = 1 if wave==10
* Coding of the final time variable:
* 0: Wave 9, 1: COVID Wave 1

* Activities respondent used internet for in last 3 months (Wave 9, COVID Wave 1)
* Emails
* Generate a new variable
gen emails = .
* Assign the number 1 if the participant reported using the internet for sending/receiving emails
replace emails = 1 if scinaem==1 & wave==9
replace emails = 1 if CvIntC01==1 & wave==10
* Assign the number 0 if the participant reported not using the internet for sending/receiving emails
replace emails = 0 if scinaem==0 & wave==9
replace emails = 0 if CvIntC01==0 & wave==10
* Calls
* Generate a new variable
gen calls = .
* Assign the number 1 if the participant reported using the internet for telephoning/video calls (via webcam) over the internet at Wave 9
replace calls = 1 if scinacl==1 & wave==9
* Assign the number 1 if the participant reported using the internet for making video or voice calls at COVID Wave 1
replace calls = 1 if CvIntC02==1 & wave==10
* Assign the number 0 if the participant reported not using the internet for telephoning/video calls (via webcam) over the internet at Wave 9
replace calls = 0 if scinacl==0 & wave==9
* Assign the number 0 if the participant reported not using the internet for making video or voice calls at COVID Wave 1
replace calls = 0 if CvIntC02==0 & wave==10
* Health
* Generate a new variable
gen health = .
* Assign the number 1 if the participant reported using the internet for finding information on health-related issues
replace health = 1 if scinahe==1 & wave==9
replace health = 1 if CvIntC03==1 & wave==10
* Assign the number 0 if the participant reported not using the internet for finding information on health-related issues
replace health = 0 if scinahe==0 & wave==9
replace health = 0 if CvIntC03==0 & wave==10
* Entertainment
* Generate a new variable
gen entertainment = .
* Assign the number 1 if the participant reported using the internet for streaming/downloading live or on demand TV/radio (BBC iPlayer, 4OD, ITV Player, Demand 5), music (iTunes, Spotify), ebooks, or games at Wave 9
replace entertainment = 1 if (scinast==1 | scinagm==1) & wave==9
* Assign the number 1 if the participant reported using the internet for streaming TV/videos/radio (BBC iPlayer, Netflix, Amazon Prime, YouTube), listening to music (Spotify, Apple Music), playing online games, or reading ebooks at COVID Wave 1
replace entertainment = 1 if CvIntC08==1 & wave==10
* Assign the number 0 if the participant reported not using the internet for streaming/downloading live or on demand TV/radio (BBC iPlayer, 4OD, ITV Player, Demand 5), music (iTunes, Spotify), ebooks, or games at Wave 9
replace entertainment = 0 if (scinast==0 & scinagm==0) & wave==9
* Assign the number 0 if the participant reported not using the internet for streaming TV/videos/radio (BBC iPlayer, Netflix, Amazon Prime, YouTube), listening to music (Spotify, Apple Music), playing online games, or reading ebooks at COVID Wave 1
replace entertainment = 0 if CvIntC08==0 & wave==10
* News
* Generate a new variable
gen news = .
* Assign the number 1 if the participant reported using the internet for news/newspaper/blog websites
replace news = 1 if scinanw==1 & wave==9
replace news = 1 if CvIntC07==1 & wave==10
* Assign the number 0 if the participant reported not using the internet for reading news/newspaper/blog websites
replace news = 0 if scinanw==0 & wave==9
replace news = 0 if CvIntC07==0 & wave==10
* Market
* Generate a new variable
gen market = .
* Assign the number 1 if the participant reported using the internet for shopping/buying goods or services
replace market = 1 if scinash==1 & wave==9
replace market = 1 if CvIntC05==1 & wave==10
* Assign the number 0 if the participant reported not using the internet for shopping/buying goods or services
replace market = 0 if scinash==0 & wave==9
replace market = 0 if CvIntC05==0 & wave==10
* Social networking
* Generate a new variable
gen socialnetworking = .
* Assign the number 1 if the participant reported using the internet for social networking sites (Facebook, Twitter, MySpace), or creating, uploading, or sharing content (YouTube, blogging, or Flickr) at Wave 9
replace socialnetworking = 1 if (scinasn==1 | scinact==1) & wave==9
* Assign the number 1 if the participant reported using the internet for social networking sites at COVID Wave 1
replace socialnetworking = 1 if CvIntC06==1 & wave==10
* Assign the number 0 if the participant reported not using the internet for social networking sites (Facebook, Twitter, MySpace), or creating, uploading, or sharing content (YouTube, blogging, or Flickr) at Wave 9
replace socialnetworking = 0 if (scinasn==0 & scinact==0) & wave==9
* Assign the number 0 if the participant reported not using the internet for social networking sites at COVID Wave 1
replace socialnetworking = 0 if CvIntC06==0 & wave==10
* Internet transactions
* Generate a new variable
gen internettransactions = .
* Assign the number 1 if the participant reported using the internet for finances (banking, paying bills), or public services (e.g., obtaining benefits, paying taxes) at Wave 9
replace internettransactions = 1 if (scinabk==1 | scinaps==1) & wave==9
* Assign the number 1 if the participant reported using the internet for managing finances at COVID Wave 1
replace internettransactions = 1 if CvIntC04==1 & wave==10
* Assign the number 0 if the participant reported not using the internet for finances (banking, paying bills), or public services (e.g., obtaining benefits, paying taxes) at Wave 9
replace internettransactions = 0 if (scinabk==0 & scinaps==0) & wave==9
* Assign the number 0 if the participant reported not using the internet for managing finances at COVID Wave 1
replace internettransactions = 0 if CvIntC04==0 & wave==10

* Count total number of participants and observations
unique idauniq
* 6,187 individuals, 12,374 observations

* Dummy variables for conditional LCA and LTA models
* Education
* Medium education (i.e., school qualifications) (coded as 1) versus low (i.e., no formal qualifications) or high (i.e., higher education) education (coded as 0)
gen mediumed = 0 if inlist(educa_cons,0,2)
replace mediumed = 1 if educa_cons == 1
* High education (coded as 1) versus low or medium education (coded as 0)
gen highed = 0 if inlist(educa_cons,0,1)
replace highed = 1 if educa_cons == 2
* Occupational class
* Intermediate occupations (coded as 1) versus lower or higher occupations (coded as 0)
gen mediumocc = 0 if inlist(mynssec3_cons,0,2)
replace mediumocc = 1 if mynssec3_cons == 1
* Higher occupations (coded as 1) versus lower or intermediate occupations (coded as 0)
gen highocc = 0 if inlist(mynssec3_cons,0,1)
replace highocc = 1 if mynssec3_cons == 2
* Wealth
* 2nd quintile (coded as 1) versus 1st, 3rd, 4th, or 5th quintile (coded as 0)
gen quint2 = 0 if inlist(wealth_cons,1,3,4,5)
replace quint2 = 1 if wealth_cons == 2
* 3rd quintile (coded as 1) versus 1st, 2nd, 4th, or 5th quintile (coded as 0)
gen quint3 = 0 if inlist(wealth_cons,1,2,4,5)
replace quint3 = 1 if wealth_cons == 3
* 4th quintile (coded as 1) versus 1st, 2nd, 3rd, or 5th quintile (coded as 0)
gen quint4 = 0 if inlist(wealth_cons,1,2,3,5)
replace quint4 = 1 if wealth_cons == 4
* 5th quintile (coded as 1) versus 1st, 2nd, 3rd, or 4th quintile (coded as 0)
gen quint5 = 0 if inlist(wealth_cons,1,2,3,4)
replace quint5 = 1 if wealth_cons == 5

* Age continuous (Wave 9, COVID Wave 1)
gen agecont = indager if wave==9
replace agecont = Age_Arch if wave==10

* Time-constant age continuous - Wave 9
* Generate a new variable duplicating the categorical age variable at Wave 9
gen indager_cons = indager if wave==9
* Declare a panel dataset with participant ID "idauniq" and time variable "wave" 
tsset idauniq wave
* Carryforward observations with respect to the time variable "wave" (i.e., from Wave 9 to COVID Wave 1) by participant ID
bysort idauniq: carryforward indager_cons, replace

* Save dataset with a new name
save datalongLCA.dta

*******************
***DATA ANALYSIS***
*******************

* Keep necessary variables
keep idauniq Time mediumed highed mediumocc highocc quint2 quint3 quint4 quint5 indager_cons sex_cons Sex emails calls health entertainment news market socialnetworking internettransactions
* Save dataset with a new name
save LCAlongcov.dta
* Reshape data into wide format for observations identified by participant ID and add "Time" as an identifying time period
reshape wide Sex emails calls health entertainment news market socialnetworking internettransactions, j(Time) i(idauniq)
* Save dataset with a new name
save LCAwidecov.dta
* Rename time-varying variables to shorter forms and/or to distinguish the relevant time period
rename Sex0 SexTV0
rename entertainment0 enter0
rename socialnetworking0 social0
rename internettransactions0 transa0
rename Sex1 SexTV1
rename entertainment1 enter1
rename socialnetworking1 social1
rename internettransactions1 transa1
* Save dataset with a new name
save LCAwidenamescov.dta

* Use data in memory
use LCAwidenamescov.dta
* Keep if the participant is male
keep if sex_cons==0 | SexTV1==0
* Save dataset with a new name
save malewide2.dta
* Count total number of participants
unique idauniq
* 2,694 individuals
* Find the necessary package
search stata2mplus
* Convert Stata data into a data file and Mplus input file
stata2mplus using malewide2.dta

* Use LCAwidenamescov.dta dataset
use LCAwidenamescov.dta
* Keep if the participant is female
keep if sex_cons==1 | SexTV1==1
* Save dataset with a new name
save femalewide2.dta
* Count total number of participants
unique idauniq
* 3,493 individuals
* Convert Stata data into a data file and Mplus input file
stata2mplus using femalewide2.dta

* Import posterior probabilities of class membership following the unconditional 3-class LCA for male participants (pre-pandemic)
clear
import excel "", sheet("") firstrow
* Save dataset with a new name
save posteriormalec3t0.dta
* Import posterior probabilities of class membership following the unconditional 3-class LCA for male participants (intra-pandemic)
import excel "", sheet("") firstrow clear
* Save dataset with a new name
save posteriormalec3t1.dta

* Use male participant dataset with core variables included in analyses
use malewide2.dta
* One-to-one merge of data in memory with posteriormalec3t0.dta on participant ID
merge 1:1 idauniq using posteriormalec3t0.dta, generate (merge_posc3t0)
* Sort from lowest to highest participant ID
sort idauniq
* One-to-one merge of data in memory with posteriormalec3t1.dta on participant ID
merge 1:1 idauniq using posteriormalec3t1.dta, generate (merge_posc3t1)
* Sort from lowest to highest participant ID
sort idauniq
* Drop unnecessary variables
drop merge_posc3t0 merge_posc3t1
* Save dataset with a new name
save LCAmalecross.dta

* Re-order classes
gen classnew0 = .
replace classnew0 = 1 if class0==3
replace classnew0 = 2 if class0==2
replace classnew0 = 3 if class0==1
gen classnew1 = .
replace classnew1 = 1 if class1==2
replace classnew1 = 2 if class1==3
replace classnew1 = 3 if class1==1
* 1: Low
* 2: Medium 
* 3: High
* Overwrite dataset, by replacing the previously saved file
save LCAmalecross.dta, replace

* Produce a two-way table of frequency counts (preliminary cross-classification tables) 
tabulate classnew0 classnew1
tab classnew0 if classnew0!=. & classnew1!=.
tab classnew1 if classnew0!=. & classnew1!=.

* Use full dataset
use datalongLCA.dta
* Keep observations at baseline
keep if wave==9
* Save dataset with a new name
save demographw9.dta

* Descriptive statistics for the total male sample and stratified by class membership (pre-pandemic)
* Use complete male participant dataset
use LCAmalecross.dta
* One-to-one merge of data in memory with demographw9.dta on participant ID
merge 1:1 idauniq using demographw9.dta, generate (merge_demograph)
* Sort from lowest to highest participant ID
sort idauniq
* Keep data from the participants included in the unconditional LCA at pre-pandemic
keep if classnew0!=.
* Count total number of participants
unique idauniq
* 1,819 individuals
replace dimarr = . if dimarr<0
replace dimarr = 4 if dimarr==5
replace dimarr = 5 if dimarr==6
sum indager
tab age_cat
tab fqethnmr
tab dimarr
tab wpdes
save maledescw9.dta
tab hhtot
tab edqual
tab educa_cons
tab mynssec3_cons
tab wealth_cons
tab frequency
tab limiting
tab limiting_cons

sum indager_cons if classnew0==1
tab age_cat if classnew0==1
tab fqethnmr if classnew0==1
tab dimarr if classnew0==1
tab wpdes if classnew0==1
tab hhtot if classnew0==1
tab educa_cons if classnew0==1
tab mynssec3_cons if classnew0==1
tab wealth_cons if classnew0==1
tab frequency if classnew0==1
tab limiting if classnew0==1
tab limiting_cons if classnew0==1

sum indager_cons if classnew0==2
tab age_cat if classnew0==2
tab fqethnmr if classnew0==2
tab dimarr if classnew0==2
tab wpdes if classnew0==2
tab hhtot if classnew0==2
tab educa_cons if classnew0==2
tab mynssec3_cons if classnew0==2
tab wealth_cons if classnew0==2
tab frequency if classnew0==2
tab limiting if classnew0==2
tab limiting_cons if classnew0==2

sum indager_cons if classnew0==3
tab age_cat if classnew0==3
tab fqethnmr if classnew0==3
tab dimarr if classnew0==3
tab wpdes if classnew0==3
tab hhtot if classnew0==3
tab educa_cons if classnew0==3
tab mynssec3_cons if classnew0==3
tab wealth_cons if classnew0==3
tab frequency if classnew0==3
tab limiting if classnew0==3
tab limiting_cons if classnew0==3

use datalongLCA.dta

* Time-constant marital status - Wave 9
* Generate a new variable duplicating the marital status variable at Wave 9
gen marital_cons = dimarr if wave==9
* Declare a panel dataset with participant ID "idauniq" and time variable "wave" 
tsset idauniq wave
* Carryforward observations with respect to the time variable "wave" (i.e., from Wave 9 to COVID Wave 1) by participant ID
bysort idauniq: carryforward marital_cons, replace

* Time-constant ethnicity - Wave 9
* Generate a new variable duplicating the ethnicity variable at Wave 9
gen ethnicity_cons = fqethnmr if wave==9
* Declare a panel dataset with participant ID "idauniq" and time variable "wave" 
tsset idauniq wave
* Carryforward observations with respect to the time variable "wave" (i.e., from Wave 9 to COVID Wave 1) by participant ID
bysort idauniq: carryforward ethnicity_cons, replace

save datalongLCA.dta, replace

* Use full dataset
use datalongLCA.dta
* Keep observations at follow-up
keep if wave==10
* Save dataset with a new name
save demographcw1.dta

* Descriptive statistics for the total male sample and stratified by class membership (intra-pandemic)
* Use complete male participant dataset
use LCAmalecross.dta
* One-to-one merge of data in memory with demographcw1.dta on participant ID
merge 1:1 idauniq using demographcw1.dta, generate (merge_demograph)
* Sort from lowest to highest participant ID
sort idauniq
* Keep data from the participants included in the unconditional LCA at intra-pandemic
keep if classnew1!=.
* Count total number of participants
unique idauniq
* 1,750 individuals
sum Age_Arch
tab age_cat
tab Ethnicity_arch
tab RelStat
tab marital_cons
replace marital_cons = . if marital_cons<0
tab RelStat if marital_cons==.
gen relcw1 = marital_cons
replace relcw1 = 1 if RelStat == 8 & marital_cons==.
replace relcw1 = 2 if inlist(RelStat,1,3,4) & marital_cons==.
replace relcw1 = 4 if inlist(RelStat,5,6) & marital_cons==.
replace relcw1 = 4 if marital_cons==5
replace relcw1 = 5 if marital_cons==6
replace relcw1 = 5 if RelStat == 7 & marital_cons==.
tab CvPstd
save maledescw10.dta
tab CvNumP
tab educa_cons
tab mynssec3_cons
tab wealth_cons
tab frequency
tab limiting_cons

sum Age_Arch if classnew1==1
tab age_cat if classnew1==1
tab Ethnicity_arch if classnew1==1
tab relcw1 if classnew1==1
tab CvPstd if classnew1==1
tab CvNumP if classnew1==1
tab educa_cons if classnew1==1
tab mynssec3_cons if classnew1==1
tab wealth_cons if classnew1==1
tab frequency if classnew1==1
tab limiting_cons if classnew1==1

sum Age_Arch if classnew1==2
tab age_cat if classnew1==2
tab Ethnicity_arch if classnew1==2
tab relcw1 if classnew1==2
tab CvPstd if classnew1==2
tab CvNumP if classnew1==2
tab educa_cons if classnew1==2
tab mynssec3_cons if classnew1==2
tab wealth_cons if classnew1==2
tab frequency if classnew1==2
tab limiting_cons if classnew1==2

sum Age_Arch if classnew1==3
tab age_cat if classnew1==3
tab Ethnicity_arch if classnew1==3
tab relcw1 if classnew1==3
tab CvPstd if classnew1==3
tab CvNumP if classnew1==3
tab educa_cons if classnew1==3
tab mynssec3_cons if classnew1==3
tab wealth_cons if classnew1==3
tab frequency if classnew1==3
tab limiting_cons if classnew1==3

* Import posterior probabilities of class membership following the unconditional 3-class LCA for female participants (pre-pandemic)
clear
import excel "", sheet("") firstrow clear
* Save dataset with a new name
save posteriorfemalec3t0.dta
* Import posterior probabilities of class membership following the unconditional 2-class LCA for female participants (intra-pandemic)
import excel "", sheet("") firstrow clear
* Save dataset with a new name
save posteriorfemalec2t1.dta

* Use female participant dataset with core variables included in analyses
use femalewide2.dta
* One-to-one merge of data in memory with posteriorfemalec3t0.dta on participant ID
merge 1:1 idauniq using posteriorfemalec3t0.dta, generate (merge_posc3t0)
* Sort from lowest to highest participant ID
sort idauniq
* One-to-one merge of data in memory with posteriorfemalec3t1.dta on participant ID
merge 1:1 idauniq using posteriorfemalec2t1.dta, generate (merge_posc2t1)
* Sort from lowest to highest participant ID
sort idauniq
* Drop unnecessary variables
drop merge_posc3t0 merge_posc2t1
* Save dataset with a new name
save LCAfemalecross.dta

* Re-order classes
gen classnew0 = .
replace classnew0 = 1 if class0==2
replace classnew0 = 2 if class0==3
replace classnew0 = 3 if class0==1
gen classnew1 = .
replace classnew1 = 1 if class1==2
replace classnew1 = 2 if class1==1
* 1: Low
* 2: Medium 
* 3: High 
* Overwrite dataset, by replacing the previously saved file
save LCAfemalecross.dta, replace

* Produce a two-way table of frequency counts (preliminary cross-classification tables) 
tabulate classnew0 classnew1
tab classnew0 if classnew0!=. & classnew1!=.
tab classnew1 if classnew0!=. & classnew1!=.

* Descriptive statistics for the total female sample and stratified by class membership (pre-pandemic)
* Use complete female participant dataset
use LCAfemalecross.dta
* One-to-one merge of data in memory with demographw9.dta on participant ID
merge 1:1 idauniq using demographw9.dta, generate (merge_demograph)
* Sort from lowest to highest participant ID
sort idauniq
* Keep data from the participants included in the unconditional LCA at pre-pandemic
keep if classnew0!=.
* Count total number of participants
unique idauniq
* 2,235 individuals
replace dimarr = . if dimarr<0
replace dimarr = 4 if dimarr==5
replace dimarr = 5 if dimarr==6
sum indager
tab age_cat
tab fqethnmr
tab dimarr
tab wpdes
save femaledescw9.dta
tab hhtot
tab edqual
tab educa_cons
tab mynssec3_cons
tab wealth_cons
tab frequency
tab limiting
tab limiting_cons

sum indager_cons if classnew0==1
tab age_cat if classnew0==1
tab fqethnmr if classnew0==1
tab dimarr if classnew0==1
tab wpdes if classnew0==1
tab hhtot if classnew0==1
tab educa_cons if classnew0==1
tab mynssec3_cons if classnew0==1
tab wealth_cons if classnew0==1
tab frequency if classnew0==1
tab limiting if classnew0==1
tab limiting_cons if classnew0==1

sum indager_cons if classnew0==2
tab age_cat if classnew0==2
tab fqethnmr if classnew0==2
tab dimarr if classnew0==2
tab wpdes if classnew0==2
tab hhtot if classnew0==2
tab educa_cons if classnew0==2
tab mynssec3_cons if classnew0==2
tab wealth_cons if classnew0==2
tab frequency if classnew0==2
tab limiting if classnew0==2
tab limiting_cons if classnew0==2

sum indager_cons if classnew0==3
tab age_cat if classnew0==3
tab fqethnmr if classnew0==3
tab dimarr if classnew0==3
tab wpdes if classnew0==3
tab hhtot if classnew0==3
tab educa_cons if classnew0==3
tab mynssec3_cons if classnew0==3
tab wealth_cons if classnew0==3
tab frequency if classnew0==3
tab limiting if classnew0==3
tab limiting_cons if classnew0==3

* Descriptive statistics for the total female sample and stratified by class membership (intra-pandemic)
* Use complete female participant dataset
use LCAfemalecross.dta
* One-to-one merge of data in memory with demographcw1.dta on participant ID
merge 1:1 idauniq using demographcw1.dta, generate (merge_demograph)
* Sort from lowest to highest participant ID
sort idauniq
* Keep data from the participants included in the unconditional LCA at intra-pandemic
keep if classnew1!=.
* Count total number of participants
unique idauniq
* 2,158 individuals
sum Age_Arch
tab age_cat
tab Ethnicity_arch
tab RelStat
tab marital_cons
replace marital_cons = . if marital_cons<0
tab RelStat if marital_cons==.
gen relcw1 = marital_cons
replace relcw1 = 1 if RelStat == 8 & marital_cons==.
replace relcw1 = 2 if inlist(RelStat,1,2,3,4) & marital_cons==.
replace relcw1 = 4 if inlist(RelStat,5,6) & marital_cons==.
replace relcw1 = 4 if marital_cons==5
replace relcw1 = 5 if marital_cons==6
replace relcw1 = 5 if RelStat == 7 & marital_cons==.
tab CvPstd
save femaledescw10.dta
tab CvNumP
tab educa_cons
tab mynssec3_cons
tab wealth_cons
tab frequency
tab limiting_cons

sum Age_Arch if classnew1==1
tab age_cat if classnew1==1
tab Ethnicity_arch if classnew1==1
tab relcw1 if classnew1==1
tab CvPstd if classnew1==1
tab CvNumP if classnew1==1
tab educa_cons if classnew1==1
tab mynssec3_cons if classnew1==1
tab wealth_cons if classnew1==1
tab frequency if classnew1==1
tab limiting_cons if classnew1==1

sum Age_Arch if classnew1==2
tab age_cat if classnew1==2
tab Ethnicity_arch if classnew1==2
tab relcw1 if classnew1==2
tab CvPstd if classnew1==2
tab CvNumP if classnew1==2
tab educa_cons if classnew1==2
tab mynssec3_cons if classnew1==2
tab wealth_cons if classnew1==2
tab frequency if classnew1==2
tab limiting_cons if classnew1==2