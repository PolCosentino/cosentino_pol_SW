/* 0.master.do

Master do-file for artseghighway

updated by Pol, 29/06/2021
*/

*global home "C:/Users/cbosquet/Dropbox/Recherche/artseghighway" /* Clement */

global home "/Users/pololebo/Dropbox/artseghighway" /* Pol */
global myprog "$home/prog"

** NHGIS data**
 *loading nhgis data and save then in .dta format
do "$myprog/1.load_nhgis_data.do" 
 *converting tract boundaries to 2010 definition
do "$myprog/2.normalization_tract_boundaries_1970-2010.do" /* crosswalk from LTDB */
do "$myprog/2.normalization_tract_boundaries_1940-1960.do" /* crosswalk from Lee and Lin (2018) */
 *merging NHGIS data with LEE 2018 to recover distances from centroids between tract and CBD, and CBSA
do "$myprog/3.merge_nhgis_census_tract_to_cbsa_lee.do" 
 *creating a database with cbsa code and highways information from Baum-Snow data
do "$myprog/4.msa_to_cbsa.do"
 *creating spatial definition, assign higways informations and create databases for descriptive statistic and econometrics analysis
do "$myprog/5.create_nhgis_cbsa.do"
 *Descriptive Statistic of NHGIS data from 1940 to 2010 of all CBSAs
do "$myprog/6.stat_desc_nhgis_cbsa_1940_2010.do"
 *Descriptive Statistic of NHGIS data from 1940 to 2010 at tract level
do "$myprog/6.stat_desc_nhgis_tract_1940_2010.do" 
 *Descriptive Statistic of NHGIS data from 1940 to 2010 of Top 12 CBSAs
do "$myprog/6.stat_desc_nhgis_top_12_cbsa_1940_2010.do"

** IPUMs data**
 *recoding msa code in Baum-Snow (2007) data
do "$myprog/1.recode_msa_baum_snow.do" 
 *creating indexes of assortative matching for race and education at MSA and US level
do "$myprog/2.create_ipums_highways_am_educ_msa.do"
do "$myprog/2.create_ipums_highways_am_race_msa.do"  
do "$myprog/2.create_ipums_highways_am_educ_us.do" 
do "$myprog/2.create_ipums_highways_am_race_us.do" 
 *creating graphics to see the trends of assortative matching for race and education
do "$myprog/3.stat_desc_ipums_index.do" 
