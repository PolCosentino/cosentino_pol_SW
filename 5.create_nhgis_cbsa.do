/* 5.create_nhgis_cbsa.do

Make nhgis_cbsa.dta for 1950-1990 and 1940-2010 by creating rings and variables. These two database will be extended to multiple spatial definition for Descriptives statistics and Econometrics analysis.
Spatial definitions mainly come from Santamaria Moreno-Maldonado (2021) : delimited the downtown and suburb by using the cumulative share of the metropolitan population who lives in the nearest locations (rings of population around the city center): 30% of population for the city and 50% of population for the suburb area of the city.
It also creates segregation index for education (graduates vs non-graduates) and race (black vs white).

Data used :
 - nhgis_tract_norm2010_lee_lin.dta
 - cbsa_hgw.dta

2 macro :
 - create_variables : creates all variable that will be useful for Descriptives statistics and Econometrics analysis.
 - merge_hgw : assign highways information using statefips and countyfips 
 
Necessary progams: 
 - 1.load_nhgis_data.do
 - 2.normalization_tract_boundaries_1970-2010.do
 - 2.normalization_tract_boundaries_1940-1960.do
 - 3.merge_nhgis_census_tract_to_cbsa_lee.do
 - 4.msa_to_cbsa.do
  
Output file :
  - nhgis_cbsa_1940_2010_def1.dta 
  - nhgis_cbsa_1940_2010_def2.dta 
  - nhgis_cbsa_1940_2010_def3.dta 
  - nhgis_cbsa_1940_2010_def4.dta 
  - nhgis_cbsa_1940_2010_def5.dta 
  - nhgis_cbsa_1940_2010_def6.dta 
 
 Updated by Pol, 12/08/2021 */

*global home "C:/Users/cbosquet/Dropbox/Recherche/artseghighway" /* Clement */
*global data "C:/Users/cbosquet/Desktop/Recherche/artseghighway/data" /* Clement */

global home "/Users/pololebo/Dropbox/artseghighway" /* Pol */
global data "/Users/pololebo/Desktop/Scolarité/Master/M1 - économie du développement/Stage/artseghighway/data" /* Pol */

set more off

* definition of the macro 
capture program drop create_variables
program define create_variables
 
 * rename variables
 rename b18ab tr_blck
 rename b18aa tr_white
 rename b69ac tr_grad
 rename b7b003 tr_other
 rename av0aa tr_pop
 
 * keep usefull variables
 keep geo2010 year tr_pop tr_blck tr_white tr_other tr_grad rings cbsa d2cbd 
 
 * problem: several tract population are lower than the sum of white, black and other race or there are tr_pop | tr_white | tr_black | tr_other missings 
 * I delete tract without any information about white and black because they will be not useful later 
 drop if tr_white==. & tr_blck==.
 * Now we can consider that if tr_black or tr_other are missing, that is because there were not none-white people 
 replace tr_other = tr_pop - tr_blck - tr_white if tr_blck>=0 & tr_other==.
 replace tr_blck = tr_pop - tr_other - tr_white if tr_other>=0 & tr_blck==. 
 * Several tr_pop are missing but there is information about white, black and other (we can found them)
 replace tr_pop=0 if tr_pop==.
 *Negative tr_other because tr_blck + tr_white > tr_pop
 replace tr_other=0 if tr_other<0
 * I propose to replace tr_pop by the sum of tr_black & tr_white & tr_other to minimize bias
 replace tr_pop= tr_white + tr_blck + tr_other if tr_pop < tr_blck + tr_white + tr_other
 
 * sum tracts pop at Downtown / suburb level in order to analyse highway's influence at CBSA level
 collapse (sum) white=tr_white black=tr_blck other=tr_other grad=tr_grad pop=tr_pop, by(year cbsa rings)

 * Create Indexes for racial segregation and educational segregation
  * found the non graduates by rings_i, cbsa and year
  bys rings cbsa year : gen non_grad = pop - grad
  * total pop, white, black, graduates and non-graduates by cbsa and by year
  egen cbsa_pop = sum(pop), by(cbsa year)
  egen cbsa_white = sum(white), by(cbsa year)
  egen cbsa_black = sum(black), by(cbsa year)
  egen cbsa_grad = sum(grad), by(cbsa year)
  egen cbsa_non_grad = sum(non_grad), by(cbsa year)
  egen cbsa_other = sum(other), by(cbsa year)
  * share of total pop , black, white and other living in rings_i per cbsa and year
  gen share_pop = pop / cbsa_pop
  gen share_white = white / cbsa_white
  gen share_black = black / cbsa_black
  gen share_other = black / cbsa_other
  * share of graduates and non-graduates living in ring_i per cbsa per year
  gen share_grad = grad / cbsa_grad
  gen share_non_grad = non_grad / cbsa_non_grad
  * absolute value of the difference between share of white living in rings_i and share of black living in rings_i
  gen abs_diff_race = abs(share_white - share_black)
  * absolute value of the difference between share of graduates living in rings_i and share of non-graduates living in rings_i
  gen abs_diff_educ = abs(share_grad - share_non_grad)
  * sum of the absolute value of the difference by CBSA and by year 
  egen sum_abs_diff_race = sum(abs_diff_race) , by(cbsa year)
  egen sum_abs_diff_educ = sum(abs_diff_educ) , by(cbsa year)
  * Dissimilarity Index assigned at CBSA level by year 
  gen D_race = 1/2 * (sum_abs_diff_race) 
  gen D_educ = 1/2 * (sum_abs_diff_educ) 
  * Interaction Index
  egen B_race = sum( (black / cbsa_black) * (white/pop) ) , by(cbsa year)
  egen B_educ = sum( (grad / cbsa_grad) * (non_grad/pop) ) , by(cbsa year)
  * Isolation Index
  egen Iso_race = sum( (black / cbsa_black) * (black/pop) ) , by(cbsa year)
  egen Iso_educ = sum( (grad / cbsa_grad) * (grad/pop) ) , by(cbsa year)
  * Entropy Index : measures the spatial distribution of multiple groups simultaneously
  bys cbsa year : gen H_hat = (- (cbsa_white/cbsa_pop)* log(cbsa_white/cbsa_pop)) + (- (cbsa_black/cbsa_pop)* log(cbsa_black/cbsa_pop)) + (- (cbsa_other/cbsa_pop)* log(cbsa_other/cbsa_pop))
  bys cbsa year rings : gen h = (- (white/pop)* log(white/pop)) + (- (black/pop)* log(black/pop)) + (- (other/pop)* log(other/pop)) 
  bys cbsa year rings : gen h_wght = (pop/cbsa_pop)*h
  egen H_bar = sum(h_wght)  , by(cbsa year)
  bys cbsa year : gen H = (H_hat - H_bar )/ H_hat
  drop H_hat H_bar h h_wght
  
  
 * when cbsa has a number of rings inferior of desired number of rings, the Dissimilarity Index is false or will not be correctly computed
 egen N_rings = count(rings), by (cbsa year)
 * drop the cbsa without correct number of rings
 drop if  N_rings!= $right_rings
 
 * Others variables : share of population_i within rings_i (P(pop_i | rings_i))
 gen share_white_r = white / pop
 gen share_black_r = black / pop
 gen share_other_r = other / pop
 gen share_grad_r = grad / pop
 gen share_non_grad_r = non_grad / pop
 
* Label variables
 label variable cbsa_pop  "Total population within CBSA"
 label variable cbsa_white  "White population within CBSA"
 label variable cbsa_black  "Black population within CBSA"
 label variable cbsa_other  "Other population within CBSA"
 label variable share_pop "Share of total population living in rings i"
 label variable share_white "Share of White living in rings i"
 label variable share_black "Share of Black living in rings i"
 label variable share_other "Share of Other living in rings i"
 label variable share_grad "Share of Graduates living in rings i"
 label variable share_non_grad "Share of Non-Graduates living in rings i"
 label variable white "White population per rings i"
 label variable black "Black population per rings i"
 label variable pop "Total population per rings i"
 label variable other "Other population per rings i"
 label variable grad "Total of graduates (+ 4 years of educ) per rings i"
 label variable non_grad "Total of person non-graduated per rings i"
 label variable share_white_r "Share of White within rings i"
 label variable share_black_r "Share of Black within rings i"
 label variable share_grad_r "Share of Graduated within rings i"
 label variable D_educ "Dissimilarity Index for educational segregation"
 label variable D_race "Dissimilarity Index for racial segregation" 
 label variable B_educ "Interaction Index for educational segregation"
 label variable B_race "Interaction Index for racial segregation"
 label variable Iso_educ "Isolation Index for educational segregation"
 label variable Iso_race "Isolation Index for racial segregation"
 label variable H "Entropy Index for racial segregation at City Level"

 
 *drop var
 drop sum_abs_diff_race sum_abs_diff_educ N_rings abs_diff_educ abs_diff_race
 *reshape
 reshape wide white black other grad pop non_grad share_pop share_white share_black share_other share_grad share_non_grad share_white_r share_black_r share_other_r share_grad_r share_non_grad_r, i(cbsa year D_educ D_race) j(rings) 

end

capture program drop merge_hgw
program define merge_hgw

 * assign highways information at cbsa level
 merge m:1 year cbsa using  "$data/temp/cbsa_hgw.dta"
 drop if _merge==2
 drop _merge
 * save for descriptive statistic and econometrics analysis
save "$output", replace 
end

* Definition 1 : cbsa divided in 2 zones according to 1990 distance from CBD
set more off
* Load nhgis_tract_norm2010_lee_lin_hgw.dta 
use "$data/temp/nhgis_tract_norm2010_lee_lin.dta",clear
* Define the suburb / downtown with ring definition (Santamaria)
 * sum of tracta population to get total population per cbsa and year
 egen pop = sum(av0aa), by(cbsa year)  
 * share of each tract in cbsa
 gen share = av0aa / pop
 sort year cbsa d2cbd 
 * create a cumulative variable of population from nearest to farthest
 bysort year cbsa : gen cum_share = sum(share)  
 * define the downtown as the area in 1990 which contains 10% of cbsa population
 gen rings = 1 if cum_share<=0.1 & year==1990
 * find the max distance to CBD for each downtown
 egen max_downtown = max(d2cbd) if rings==1, by(cbsa)
 egen max_dist = max(max_downtown), by(cbsa) 
 drop max_downtown
 replace rings=1 if d2cbd<=max_dist
 replace rings=2 if d2cbd>max_dist
 
global right_rings "2" 
global output "$data/final/nhgis_cbsa_1940_2010_def1.dta"
*macros
create_variables
merge_hgw

* Definition 2 : cbsa divided in 3 zones according to 1990 distance from CBD
set more off
* Load nhgis_tract_norm2010_lee_lin_hgw.dta 
use "$data/temp/nhgis_tract_norm2010_lee_lin.dta",clear
 * sum of tracta population to get total population per cbsa and year
 egen pop = sum(av0aa), by(cbsa year)  
 * share of each tract in cbsa
 gen share = av0aa / pop
 sort year cbsa d2cbd 
 * create a cumulative variable of population from nearest to farthest
 bysort year cbsa : gen cum_share = sum(share)  
 * define the downtown as the area in 1990 which contains 10% of cbsa population, and 2 suburb
 gen rings = 1 if cum_share<=0.1 & year==1990
 replace rings = 3 if cum_share>0.6 & year==1990
 * find the max distance to CBD for each rings
 egen max_dist_1 = max(d2cbd) if rings==1, by(cbsa)
 egen min_dist_3 = min(d2cbd) if rings==3 , by(cbsa)
 egen max_dist_ring1 = max(max_dist_1), by(cbsa) 
 egen min_dist_ring3 = min(min_dist_3), by(cbsa) 
 drop max_dist_1 min_dist_3
 replace rings=1 if d2cbd<=max_dist_ring1 
 replace rings=2 if d2cbd>max_dist_ring1 & d2cbd<=min_dist_ring3
 replace rings=3 if d2cbd>min_dist_ring3
 
global right_rings "3" 
global output "$data/final/nhgis_cbsa_1940_2010_def2.dta"
* macros
create_variables
merge_hgw

* Definition 3 : cbsa divided in 4 zones according to 1990 distance from CBD
set more off
* Load nhgis_tract_norm2010_lee_lin_hgw.dta 
use "$data/temp/nhgis_tract_norm2010_lee_lin.dta",clear
 * sum of tracta population to get total population per cbsa and year
 egen pop = sum(av0aa), by(cbsa year)  
 * share of each tract in cbsa
 gen share = av0aa / pop
 sort year cbsa d2cbd 
 * create a cumulative variable of population from nearest to farthest
 bysort year cbsa : gen cum_share = sum(share)  
 * define the downtown as the area in 1990 which contains 10% of cbsa population and 3 suburbs
 gen rings = 1 if cum_share<=0.1 & year==1990
 replace rings = 2 if cum_share>0.1 & cum_share<=0.4 & year==1990
 replace rings = 3 if cum_share>0.4 & cum_share<=0.7 & year==1990
 replace rings = 4 if cum_share>0.7 & year==1990
 * find the max distance to CBD for each rings
 egen max_dist_1 = max(d2cbd) if rings==1, by(cbsa)
 egen max_dist_2 = max(d2cbd) if rings==2 , by(cbsa)
 egen max_dist_3 = max(d2cbd) if rings==3 , by(cbsa)
 egen max_dist_ring1 = max(max_dist_1), by(cbsa)
 egen max_dist_ring2 = max(max_dist_2), by(cbsa)
 egen max_dist_ring3 = max(max_dist_3), by(cbsa)
 drop max_dist_1 max_dist_2 max_dist_3
 replace rings=1 if d2cbd<=max_dist_ring1 
 replace rings=2 if d2cbd>max_dist_ring1 & d2cbd<=max_dist_ring2
 replace rings=3 if d2cbd>max_dist_ring2 & d2cbd<=max_dist_ring3
 replace rings=4 if d2cbd>max_dist_ring3
 
global right_rings "4" 
global output "$data/final/nhgis_cbsa_1940_2010_def3.dta"
* macros
create_variables
merge_hgw

* Definition 4 : cbsa divided into decile, moving in time, according to distance from CBD
set more off
* Load nhgis_tract_norm2010_lee_lin_hgw.dta 
use "$data/temp/nhgis_tract_norm2010_lee_lin.dta",clear
 * sum of tracta population to get total population per cbsa and year
 egen pop = sum(av0aa), by(cbsa year)  
 * share of each tract in cbsa
 gen share = av0aa / pop
 sort year cbsa d2cbd 
 * create a cumulative variable of population from nearest to farthest
 bysort year cbsa : gen cum_share = sum(share) 
 * create rings each 10% of cumulative share
 gen rings = 1 if cum_share<=0.1 
 replace rings = 2 if cum_share>0.1 & cum_share<=0.2
 replace rings = 3 if cum_share>0.2 & cum_share<=0.3
 replace rings = 4 if cum_share>0.3 & cum_share<=0.4
 replace rings = 5 if cum_share>0.4 & cum_share<=0.5
 replace rings = 6 if cum_share>0.5 & cum_share<=0.6
 replace rings = 7 if cum_share>0.6 & cum_share<=0.7
 replace rings = 8 if cum_share>0.7 & cum_share<=0.8
 replace rings = 9 if cum_share>0.8 & cum_share<=0.9
 replace rings = 10 if cum_share>0.9 
 
global right_rings "10" 
global output "$data/final/nhgis_cbsa_1940_2010_def4.dta"
* macros
create_variables
merge_hgw

* Definition 5 : cbsa divided in 2 zones with distance to CBD moving in time
set more off
* Load nhgis_tract_norm2010_lee_lin_hgw.dta 
use "$data/temp/nhgis_tract_norm2010_lee_lin.dta",clear
 * sum of tracta population to get total population per cbsa and year
 egen pop = sum(av0aa), by(cbsa year)  
 * share of each tract in cbsa
 gen share = av0aa / pop
 sort year cbsa d2cbd 
 * create a cumulative variable of population from nearest to farthest
 bysort year cbsa : gen cum_share = sum(share) 
 * create rings 
 gen rings = 1 if cum_share<=0.1
 replace rings = 2 if rings==.
 
global right_rings "2" 
global output "$data/final/nhgis_cbsa_1940_2010_def5.dta"
* macros
create_variables
merge_hgw

* Definition 6 : cbsa divided in 3 zones with distance to CBD moving in time
set more off
* Load nhgis_tract_norm2010_lee_lin_hgw.dta 
use "$data/temp/nhgis_tract_norm2010_lee_lin.dta",clear
 * sum of tracta population to get total population per cbsa and year
 egen pop = sum(av0aa), by(cbsa year)  
 * share of each tract in cbsa
 gen share = av0aa / pop
 sort year cbsa d2cbd 
 * create a cumulative variable of population from nearest to farthest
 bysort year cbsa : gen cum_share = sum(share) 
 * create rings 
 gen rings = 1 if cum_share<=0.1
 replace rings = 2 if cum_share>0.1 & cum_share<=0.6
 replace rings = 3 if cum_share>0.6 
 
global right_rings "3" 
global output "$data/final/nhgis_cbsa_1940_2010_def6.dta"
* macros
create_variables
merge_hgw

