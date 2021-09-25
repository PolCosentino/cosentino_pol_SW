/* 2.create_ipums_highways_am_educ_msa.do

This program recodes MSA and creates indexes of Education Assortative Matching presented in Chiappori (NBER, 2020). The sample is restricted to married couples (simple case without singles).

Data used :
 - usa_00015.dta (1950 data, from IPUMS USA file)
 - usa_00016.dta (1960 data, from IPUMS USA file)
 - usa_00017.dta (1970 data, from IPUMS USA file)
 - usa_00024.dta (1980 data, from IPUMS USA file)
 - usa_00023.dta (1990 data, from IPUMS USA file)
 - usa_00022.dta (2000 data, from IPUMS USA file)
 - msa_recoded_baum_snow.dta (recoded msa data with highways information, from temp file)
  
Necessary progams: 
 - 1.recode_msa_baum_snow.do
 
3 Macros:
 - msa_recode : recode MSA in order to match IPUMs and Baum-Snow data. 2 cases need to be distinguished. In IPUMs data : some MSAs have been separated over time
 and can be reattached to have only one MSA code and facilitate the merge (we followed IPUMs website to do so) or Baum-Snow has associated some MSA to others MSA 
 for different reasons (geographical proximity, observed only 2 times, etc.). Therefore, we replicate the same operations (part of the code is taken from msa-recode.do,
 Baum-Snow 2007). In Baum-Snow data : MSA code do not correspond with IPUMs MSA code. We correct them in Baum-Snow data (necessary do-file: 1.recode_msa_baum_snow.do).
 - create_indexes : creates assortative matching indexes (Chiappori, 2020)
 - merge_highways : merge to Baum-Snow data to get highways information
 
Output file :
  - ipums_highways_am_educ_msa.dta
  
 Updated by Pol, 09/08/2021 */

*global home "C:/Users/cbosquet/Dropbox/Recherche/artseghighway" /* Clement */
*global data "C:/Users/cbosquet/Desktop/Recherche/artseghighway/data" /* Clement */

global home "/Users/pololebo/Dropbox/artseghighway" /* Pol */
global data "/Users/pololebo/Desktop/Scolarité/Master/M1 - économie du développement/Stage/artseghighway/data" /* Pol */

set more off

*do "$home/prog/1.recode_msa_baum_snow.do"

* definition of the macro 
capture program drop msa_recode
program define msa_recode

********** Load IPUMs Data **********
use "$input_file", clear
 * use metarea for msa code
 decode metaread, generate(area_name)
 label drop METAREAD
 drop if metaread==0
 rename metaread msa
 keep year msa statefip countyfip serial hhwt pernum relate related area_name  sex age marst race bpld  educ 
***IPUMs data MSA***
 *Reattach MSA following IPUMs website
 *Wilkes-Barre-hazelton, PA => Scranton-Wilkes-Barre, PA
 replace msa=7560 if msa==7561 /* observed until 1970 */
 replace  area_name="Scranton-Wilkes-Barre, PA" if msa==7560
 *Durham, NC => Raleigh-Durham, NC
 replace msa=6640 if msa==6641 /* observed until 1960 */
 replace  area_name="Raleigh-Durham, NC" if msa==6640
 *Ogden => Salt Lake City-Ogden, UT
 replace msa=7160 if msa==7161 /* observed in 1960 and 1950 */
 replace  area_name="Salt Lake City-Ogden, UT" if msa==7160
 *Fall River, MA/RI => Providence-Fall River-Pawtuckett, MA
 replace msa=6480 if msa==6481 /* observed in 1990 and 1980 */
 replace  area_name="Providence-Fall River-Pawtuckett, MA" if msa==6480
 *Springfield, OH => Dayton-Springfield, OH
 replace msa=2000 if msa==2001 /* miss 1970 and 1960 */ 
 replace  area_name="Dayton-Springfield, OH" if msa==2000
 *New Britain, CT => Hartford-Bristol-Middletown-New Britian, CT
 replace msa=3280 if msa==3283 /* observed in 1990, 1980 and 1960 */
 replace  area_name="Hartford-Bristol-Middletown-New Britian, CT" if msa==3280
 *Bay City, MI => Saginaw-Bay City-Midland, MI
 replace msa=6960 if msa==6961 /* observed in 1980, 1960 and 1950 */
 replace  area_name="Saginaw-Bay City-Midland, MI" if msa==6960
 *Winston-Salem, NC => Greensboro-Winston Salem-High Point, NC
 replace msa=3120 if msa==3121 /* observed until 1960 */
 replace  area_name="Greensboro-Winston Salem-High Point, NC" if msa==3120
 *Norfolk-VA Beach-Portsmouth => Norfolk-VA Beach-Newport News, VA
 replace msa=5720 if msa==5722 /* observed in 1980 and 1960 */
 replace  area_name="Norfolk-VA Beach-Newport News, VA" if msa==5720
 *Newport News-hampton => Norfolk-VA Beach-Newport News, VA
 replace msa=5720 if msa==5721 /* miss 1990, 1950 and 1940 */
 replace  area_name="Norfolk-VA Beach-Newport News, VA" if msa==5720
 *Fort Worth-Arlington, TX => Dallas-Fort Worth, TX
 replace msa=1920 if msa==1921 /* it's okay because Dallas-Fort Worth msa includes Arlington */
 replace  area_name="Dallas-Fort Worth, TX" if msa==1920
 *Pawtuckett-Woonsocket-Attleboro, RI/MA => Providence-Fall River-Pawtucket, MA/RI
 replace msa=6480 if msa==6482 
 replace  area_name="Providence-Fall River-Pawtucket, MA/RI" if msa==6480
 *Vallejo-Fairfield-Napa, CA => San Francisco-Oakland-Vallejo, CA
 replace msa=7360 if msa==7362 /* only 1990 and 1980 */
 replace  area_name="San Francisco-Oakland-Vallejo, CA" if msa==7360
 *Rock Hill, SC => Charlotte-Gastonia-Rock Hill, NC/SC
 replace msa=1520 if msa==1521 /* observed in 1980 */
 replace  area_name="Charlotte-Gastonia-Rock Hill, NC/SC" if msa==1520
 *Petersburg-Colonial He., VA => Richmond-Petersburg, VA
 replace msa=6760 if msa==6761 /* observed in 1980 */
 replace  area_name="Richmond-Petersburg, VA" if msa==6760
 *New Haven, CT => New Haven-Meriden, CT
 replace msa=5480 if msa==5482  
 replace  area_name="New Haven-Meriden, CT" if msa==5480
 *Middletown, CT => Hartford-Bristol-Middleton-New Britain, CT
 replace msa=3280 if msa==3282
 replace  area_name="Hartford-Bristol-Middleton-New Britain, CT" if msa==3280

 **Baum-Snow operations**
 * New-York case : he considers Nassau, Bergen, Jersey City, Middlesex and Newark as part of NY
  *Nassau Co., NY => New York, NY-Northeastern NJ
  replace msa=5600 if msa==5601
  *Bergen-Passaic, NJ => New York, NY-Northeastern NJ
  replace msa=5600 if msa==5602 
  *Jersey City, NJ => New York, NY-Northeastern NJ
  replace msa=5600 if msa==5603 
  *Middlesex-Somerset-Hunterdon, NJ => New York, NY-Northeastern NJ
  replace msa=5600 if msa==5604 
  *Newark, NJ => New York, NY-Northeastern NJ
  replace msa=5600 if msa==5605  
 replace  area_name="New York, NY-Northeastern NJ" if msa==5600
 *Gary-Hammond-East Chicago, IN => Chicago-Gary-Lake IL
 replace msa=1600 if msa==1602
 replace area_name="Chicago-Gary-Lake IL" if msa==1600 
 *Anderson, SC => Greenville-Spartenburg-Anderson, SC
 replace msa=3160 if msa==3161 /* because they are close to each other and it only observed in 1990 and 1980 */
 replace area_name="Greenville-Spartenburg-Anderson, SC" if msa==3160
 *Poughkeepsie, NY => Dutchess County, NY
 replace msa=2281 if msa==6460 /* because they are near geographically */
 replace area_name="Dutchess County, NY" if msa==2281
 *Anderson, IN => Indianapolis, IN
 replace msa = 3480 if msa==400 /* they are close to each other and it only observed in 1990 and 1980 */
 replace area_name="Indianapolis, IN" if msa==3480
 *Aurora-Elgin, IL => Chicago-Gary-Lake IL
 replace msa = 1600 if msa==1601 /* only observed in 1990 */
 replace area_name="Chicago-Gary-Lake IL" if msa==1600 
 *Lorain-Elyra, OH => Cleveland, OH
 replace msa = 1680 if msa==4440 
 replace area_name="Cleveland, OH" if msa==1680 
 *Monmouth-etc. NJ => New York, NY-Northeastern NJ
 replace msa = 5600 if msa==5190 /* only observed in 1990 */
 replace area_name="New York, NY-Northeastern NJ" if msa==5600 
 *Muskegon MI => Grand Rapids, MI
 replace msa = 3000 if msa==5320 /* only observed in 1980 and 1960 */
 replace area_name="Grand Rapids, MI" if msa==3000 
 *Pascagoula-Moss Point, MS => Biloxi-Gulfport, MS
 replace msa = 920 if msa==6030 /* only observed in 1990 and 1980 */
 replace area_name="Biloxi-Gulfport, MS" if msa==920 
 *Battle Creek, MI => Kalamazoo
 replace msa=3720 if msa==780 /* only observed in 1990 and 1980 */
 replace area_name="Kalamazoo" if msa==3720  
 *Bradenton, FL => Kalamazoo-Portage, MI
 replace msa = 7510 if msa==1140 /* only observed in 1990 and 1980 */
 replace area_name="Kalamazoo-Portage, MI" if msa==7510  
 *Boulder-longmont, CO => Denver-Boulder-Longmont, CO
 replace msa=2080 if msa==2081 /* only observed in 1990 */
 replace area_name="Denver-Boulder-Longmont, CO" if msa==2080  
 *Vancouver, WA => Portland-Vancouver, OR
 replace msa=6440 if msa==6441 /* only observed in 1990 */
 replace area_name="Portland-Vancouver, OR" if msa==6440  
 *Brazoria, TX => Houston-Brazoria, TX
 replace msa=3360 if msa==3361 /* only observed in 1990 */
 replace area_name="Houston-Brazoria, TX" if msa==3360  
 *Niagara falls, NY => Buffalo-Niagara falls, NY
 replace msa=1280 if msa==1281 /* only observed in 1990 */
 replace area_name="Buffalo-Niagara falls, NY" if msa==1280  
 *Oakland, CA => San Francisco-Oakland-Vallejo, CA
 replace msa=7360 if msa==7361 /* only observed in 1990 */
 replace area_name="San Francisco-Oakland-Vallejo, CA" if msa==7360   
 *Beaver County, PA => Pittsburgh-Beaver Valley, PA 
 replace msa = 6280 if msa==6281 
 replace area_name="Pittsburgh-Beaver Valley, PA" if msa==6280   
 *Joliet, IL => Chicago, IL
 replace msa=1600 if msa==1603 /* close to Chicago and as far from Chicago as Aurora and Elgin are */
 replace area_name="Chicago, IL" if msa==1600    
end

capture program drop create_indexes
program define create_indexes

********** Restricts the sample **********
* restric the sample to married (we do not consider singles)
keep if marst==1 
* restric age 
keep if age>=35 & age<=44
*keep only spouses and household
drop if relate>2
* create college variable to indicate if the individual is graduated
gen college=1 if educ>6 
replace college=0 if college==.

* create identifier for each household (state + county + household id + year of interview) in order to associate married couples
tostring statefip, generate(state)
tostring countyfip, generate(county)
tostring serial, generate(hhid)
tostring year , generate(y)
gen id = state + county + hhid 
drop state county hhid y
sort id

********** Create proportion **********
*Education
* m : proportion of male college graduates
* f : proportion of female college graduates
* r : proportion of couples where both spouses are college graduates
gen n=1
egen pop_msa = sum(n),  by(msa ) 
egen gend_msa = sum(n),  by(msa sex) /* number of men and women in each msa */ 
egen grad_msa = sum(college) , by(msa sex) /* number of graduated men and women in each msa */
gen grad_male = grad_msa / gend_msa if sex==1 /* proportion of male college graduates in each msa */
gen grad_female = grad_msa / gend_msa if sex==2 /* proportion of female college graduates in each msa */
egen m= max(grad_male),  by(msa)
egen f= max(grad_female),  by(msa)
drop grad_male grad_female
* create a variable that notice if both spouses are graduated
egen check_grad_mar = sum(college), by(id)
bys id : gen grad_mar = 1 if check_grad_mar==2
replace grad_mar=0 if missing(grad_mar)

keep year serial statefip countyfip msa area_name n m f grad_mar pop_msa
duplicates drop   /* drop the partner to analyze at couple level */
* number of couples per msa
egen nbr_mar = sum(n) , by(msa)
* proportion of grad married couple per msa
egen nbr_grad_mar = sum(grad_mar) , by(msa)
gen r = nbr_grad_mar / nbr_mar
 
* msa level analysis
keep year msa area_name m f r pop_msa
duplicates drop  /* msa level */
sort msa 
***Condition that must hold : max(0, m+f-1) <= r <= min (m, f) ***
bys msa : gen x_educ = m+f-1
bys msa : replace x_educ = 0 if x_educ<0
bys msa : gen y_educ = m if m<f
bys msa : replace y_educ = f if y_educ==.
bys msa : gen condition_educ = 1 if x_educ <= r & r <= y_educ
drop if condition_educ==.

********** Assortativeness **********
*Positive Assortative matching
bys msa year : gen PAM_educ = 1 if r >= (f*m) /* if 1, the proportion of couples with equal education is larger than what would obtain under random matching */
*Indexes for education assortative matching
 *Separable Extreme Value index
 bys msa year : gen I_sev_educ = log( (r *(1 + r - m - f) ) / ((f - r) * (m-r)) ) 
 *Correlation index
 bys msa year : gen I_corr_educ = (r - (m * f)) / sqrt( m*f * (1 - m)*(1 - f)) /* correlation between husband’s and wife’s educations */
 *Chi-2 criterion
 bys msa year : gen Chi_educ = (I_corr_educ)^2 /* distance between observed matching patterns and what would obtain under random matching */
 *Minimum Distance
 bys msa year : gen I_MD_educ = (r - (m*f) )/ (f - (m*f))

***Label***
label var m "proportion of male college graduates"
label var f "proportion of female college graduates"
label var r "proportion of couples college graduates"
label var x_educ "max(0, m+f-1)"
label var y_educ "min(m, f)"
label var PAM_educ "Education Positive Assortative Matching"
label var I_sev_educ "Separable Extreme Value Index"
label var I_corr_educ "Correlation Index"
label var Chi_educ "Chi-deux Index"
label var I_MD_educ "Minimum Distance Index"
 
end

capture program drop merge_highways
program define merge_highways

*** Merge with recoded MSA in order to get highways informations ***
merge m:1 msa year using "$data/temp/msa_recoded_baum_snow.dta"
drop if _merge==2
drop _merge
save "$output_file" , replace

end

**1950**
global input_file "$data/source/IPUMS USA/1950 1pc 00015/usa_00015.dta"
globa output_file "$data/temp/ipums_highways_am_educ_msa_1950.dta"
 * macros
 msa_recode
 create_indexes
 merge_highways
**1960**
global input_file "$data/source/IPUMS USA/1960 5pc 00016/usa_00016.dta"
globa output_file "$data/temp/ipums_highways_am_educ_msa_1960.dta"
 * macros
 msa_recode
 create_indexes
 merge_highways
**1970**
global input_file "$data/source/IPUMS USA/1970 1pc metro 00017/usa_00017.dta"
globa output_file "$data/temp/ipums_highways_am_educ_msa_1970.dta"
 * macros
 msa_recode
 create_indexes
 merge_highways
**1980**
global input_file "$data/source/IPUMS USA/1980 1pc metro 00024/usa_00024.dta"
globa output_file "$data/temp/ipums_highways_am_educ_msa_1980.dta"
 * macros
 msa_recode
 create_indexes
 merge_highways 
**1990**
global input_file "$data/source/IPUMS USA/1990 1pc metro 00023/usa_00023.dta"
globa output_file "$data/temp/ipums_highways_am_educ_msa_1990.dta"
 * macros
 msa_recode
 create_indexes
 merge_highways 
**2000**
global input_file "$data/source/IPUMS USA/2000 5pc 00022/usa_00022.dta"
globa output_file "$data/temp/ipums_highways_am_educ_msa_2000.dta"
 * macros
 msa_recode
 create_indexes
 merge_highways
   
**** Append Data ****
 use "$data/temp/ipums_highways_am_educ_msa_1950.dta", clear
 append using "$data/temp/ipums_highways_am_educ_msa_1960.dta"
 append using "$data/temp/ipums_highways_am_educ_msa_1970.dta"
 append using "$data/temp/ipums_highways_am_educ_msa_1980.dta"
 append using "$data/temp/ipums_highways_am_educ_msa_1990.dta"
 append using "$data/temp/ipums_highways_am_educ_msa_2000.dta"
save "$data/final/ipums_highways_am_educ_msa.dta", replace
 erase "$data/temp/ipums_highways_am_educ_msa_1950.dta"
 erase "$data/temp/ipums_highways_am_educ_msa_1960.dta"
 erase "$data/temp/ipums_highways_am_educ_msa_1970.dta"
 erase "$data/temp/ipums_highways_am_educ_msa_1980.dta"
 erase "$data/temp/ipums_highways_am_educ_msa_1990.dta"
 erase "$data/temp/ipums_highways_am_educ_msa_2000.dta"




 


