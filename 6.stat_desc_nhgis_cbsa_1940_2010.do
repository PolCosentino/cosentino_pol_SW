/* 6.stat_desc_nhgis_cbsa_1940_2010.do

This program does descriptive statistics with nhgis_final data using several spatial definition.
 
Data used : 
  - nhgis_cbsa_1940_2010_def1.dta
  - nhgis_cbsa_1940_2010_def2.dta
  - nhgis_cbsa_1940_2010_def3.dta
  - nhgis_cbsa_1940_2010_def4.dta
  - nhgis_cbsa_1940_2010_def5.dta
  - nhgis_cbsa_1940_2010_def6.dta

Necessary progams: 
 - 1.load_nhgis_data.do
 - 2.normalization_tract_boundaries_1970-2010.do
 - 2.normalization_tract_boundaries_1940-1960.do
 - 3.merge_nhgis_census_tract_to_cbsa_lee.do
 - 4.msa_to_cbsa.do
 - 5.create_nhgis_cbsa.do
 
Output file :
  -  graphics

Updated by Pol, 09/08/2021 */
clear
set more off

*global home "C:/Users/cbosquet/Dropbox/Recherche/artseghighway" /* Clement */
*global data "C:/Users/cbosquet/Desktop/Recherche/artseghighway/data" /* Clement */
*global graph_nhgis "C:/Users/cbosquet/Dropbox/artseghighway/graph_nhgis" /* Clement */

global home "/Users/pololebo/Dropbox/artseghighway" /* Pol */
global data "/Users/pololebo/Desktop/Scolarité/Master/M1 - économie du développement/Stage/artseghighway/data" /* Pol */
global graph_nhgis "/Users/pololebo/Dropbox/artseghighway/graph_nhgis" /* Pol */

global myprog "$home/prog"
global def1 "$graph_nhgis/def_1"
global def2 "$graph_nhgis/def_2" 
global def3 "$graph_nhgis/def_3" 
global def4 "$graph_nhgis/def_4" 
global def5 "$graph_nhgis/def_5"
global def6 "$graph_nhgis/def_6"

 
** Definition 1 : cbsa divided in 2 zones according to 1990 distance from CBD **
 * Graphic :  share of population within downtown / suburb
 use "$data/final/nhgis_cbsa_1940_2010_def1.dta" , clear
 collapse (mean) share_pop1 share_pop2 , by(year) 
 *reshape wide share_pop, i(year) j(rings) 
 twoway line share_pop* year, sort ///
 legend(order(2 "suburb" 1 "city center")) xtitle("Year") ///
 ytitle("Share") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def1/Trends_nhgis_share_pop_def1.png", as(png) replace
 
 * Graphic : Share of black, white and other within cc and suburb
 use "$data/final/nhgis_cbsa_1940_2010_def1.dta" , clear
 collapse (mean) share_black_r1 share_black_r2 share_white_r1 share_white_r2 share_other_r1 share_other_r2 , by(year) 
 *reshape wide share_black_r share_white_r share_other_r, i(year) j(rings) 
 twoway line share_black_r1 share_white_r1 share_other_r1 year, sort ///
 legend(order(3 "other" 2 "white"  1 "black")) xtitle("Year") ///
 ytitle("Share within city center") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def1/Trends_nhgis_share_within_cc_def1.gph", replace  
 twoway line share_black_r2 share_white_r2 share_other_r2 year, sort ///
 legend(order(3 "other" 2 "white"  1 "black")) xtitle("Year") ///
 ytitle("Share within suburb") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def1/Trends_nhgis_share_within_sub_def1.gph", replace
graph combine "$def1/Trends_nhgis_share_within_cc_def1.gph" "$def1/Trends_nhgis_share_within_sub_def1.gph"
graph export "$def1/Trends_nhgis_share_within_def1.png", as(png) replace
 
 * Graphic : Share of Black and White living in rings
 use "$data/final/nhgis_cbsa_1940_2010_def1.dta" , clear
 collapse (mean) share_black1 share_black2, by(year) 
 *reshape wide share_black, i(year) j(rings) 
 twoway line share_black1 share_black2 year, sort ///
 legend(order(2 "suburb" 1 "city center")) xtitle("Year") ///
 ytitle("Share, Black") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def1/Trends_nhgis_share_black_def1.gph", replace
 use "$data/final/nhgis_cbsa_1940_2010_def1.dta" , clear
 collapse (mean) share_white* , by(year ) 
 *reshape wide share_white, i(year) j(rings) 
 twoway line share_white1 share_white2 year, sort ///
 legend(order(2 "suburb" 1 "city center")) xtitle("Year") ///
 ytitle("Share, White") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def1/Trends_nhgis_share_white_def1.gph", replace
graph combine "$def1/Trends_nhgis_share_black_def1.gph" "$def1/Trends_nhgis_share_white_def1.gph"
graph export "$def1/Trends_nhgis_share_allocation_def1.png", as(png) replace
 
 * Graphic : Share of Graduated within rings
 use "$data/final/nhgis_cbsa_1940_2010_def1.dta" , clear
 collapse (mean) share_grad_r1 share_grad_r2 , by(year) 
 *reshape wide share_grad_r, i(year) j(rings) 
 twoway line share_grad_r1 share_grad_r2 year, sort ///
 legend(order(2 "suburb" 1 "city center"))  xtitle("Year") ///
 ytitle("Share") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def1/Trends_nhgis_share_grad_r_def1.png", as(png) replace
 
 * Graphic : Share of Graduated living in rings
 use "$data/final/nhgis_cbsa_1940_2010_def1.dta" , clear
 collapse (mean) share_grad1 share_grad2 , by(year ) 
 *reshape wide share_grad, i(year) j(rings) 
 twoway line share_grad1 share_grad2 year, sort ///
 legend(order(2 "suburb" 1 "city center")) xtitle("Year") ///
 ytitle("Share") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def1/Trends_nhgis_share_grad_def1.png", as(png) replace
 
 * Graphic : the evolution of Dissimilarity index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def1.dta" , clear
 drop if cbsa_black<1000
 collapse (mean) D_race D_educ [w=cbsa_pop] , by(year) 
 line D_race year, sort ///
 legend(order( 1 "Mean of Racial Dissimilarity Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def1/Trends_nhgis_D_race_def1.gph", replace
 line D_educ year, sort ///
 legend(order( 1 "Mean of Educational Dissimilarity Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def1/Trends_nhgis_D_educ_def1.gph", replace
 graph combine "$def1/Trends_nhgis_D_race_def1.gph" "$def1/Trends_nhgis_D_educ_def1.gph" 
graph export "$def1/dissimilarity_weight_def1.png", as(png) replace

 * Graphic : the evolution of Isolation index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def1.dta" , clear
 collapse (mean) Iso_race Iso_educ [w=cbsa_pop], by(year) 
 line Iso_race year, sort ///
 legend(order( 1 "Mean of Racial Isolation Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def1/Trends_nhgis_isolation_race_def1.gph", replace
 line Iso_educ year, sort ///
 legend(order( 1 "Mean of Educational Isolation Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def1/Trends_nhgis_isolation_educ_def1.gph", replace
 graph combine "$def1/Trends_nhgis_isolation_race_def1.gph" "$def1/Trends_nhgis_isolation_educ_def1.gph"
graph export "$def1/isolation_weight_def1.png", as(png) replace

* Graphic : the evolution of Interaction index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def1.dta" , clear
 collapse (mean) B_race B_educ [w=cbsa_pop], by(year) 
 line B_race year, sort ///
 legend(order( 1 "Mean of Racial Interaction Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def1/Trends_nhgis_interaction_race_def1.gph", replace
 line B_educ year, sort ///
 legend(order( 1 "Mean of Educational Interaction Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def1/Trends_nhgis_interaction_educ_def1.gph", replace
 graph combine "$def1/Trends_nhgis_interaction_race_def1.gph" "$def1/Trends_nhgis_interaction_educ_def1.gph"
graph export "$def1/interaction_weight_def1.png", as(png) replace

* Graphic : the evolution of Entropy index for racial segregation
 use "$data/final/nhgis_cbsa_1940_2010_def1.dta" , clear
 collapse (mean) H [w=cbsa_pop], by(year) 
 line H year, sort ///
 legend(order( 1 "Mean of Entropy Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def1/entropy_weight_def1.png", as(png) replace

** Definition 2 : cbsa divided in 3 zones according to 1990 distance from CBD **
 * Graphic :  share of population within downtown / suburb1 / suburb2
 use "$data/final/nhgis_cbsa_1940_2010_def2.dta" , clear
 collapse (mean) share_pop1 share_pop2 share_pop3 , by(year ) 
 *reshape wide share_pop, i(year) j(rings) 
 twoway line share_pop1 share_pop2 share_pop3 year, sort ///
 legend(order(3 "suburb2" 2 "suburb1" 1 "city center")) xtitle("Year") ///
 ytitle("Share") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def2/Trends_nhgis_share_pop_def2.png", as(png) replace
 
 * Graphic : Share of black, white and other within cc, suburb1 and suburb2
 use "$data/final/nhgis_cbsa_1940_2010_def2.dta" , clear
 collapse (mean) share_black_r1 share_black_r2 share_black_r3 share_white_r1 share_white_r2 share_white_r3 share_other_r1 share_other_r2 share_other_r3  , by(year ) 
 *reshape wide share_black_r share_white_r share_other_r, i(year) j(rings)
 * city center
 twoway line share_black_r1 share_white_r1 share_other_r1 year, sort ///
 legend(order(3 "other" 2 "white"  1 "black")) xtitle("Year") ///
 ytitle("Share within city center") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def2/Trends_nhgis_share_within_cc_def2.gph", replace  
 * first suburb
 twoway line share_black_r2 share_white_r2 share_other_r2 year, sort ///
 legend(order(3 "other" 2 "white"  1 "black")) xtitle("Year") ///
 ytitle("Share within suburb1") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def2/Trends_nhgis_share_within_sub1_def2.gph", replace
 * second suburb
 twoway line share_black_r3 share_white_r3 share_other_r3 year, sort ///
 legend(order(3 "other" 2 "white"  1 "black")) xtitle("Year") ///
 ytitle("Share within suburb2") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def2/Trends_nhgis_share_within_sub2_def2.gph", replace
graph combine "$def2/Trends_nhgis_share_within_cc_def2.gph" "$def2/Trends_nhgis_share_within_sub1_def2.gph" "$def2/Trends_nhgis_share_within_sub2_def2.gph"
graph export "$def2/Trends_nhgis_share_within_def2.png", as(png) replace
 
 * Graphic : Share of Black and White living in rings
 * Black
 use "$data/final/nhgis_cbsa_1940_2010_def2.dta" , clear
 collapse (mean) share_black1 share_black2 share_black3, by(year ) 
 *reshape wide share_black, i(year) j(rings) 
 twoway line share_black1 share_black2 share_black3 year, sort ///
 legend(order(3 "suburb2" 2 "suburb1" 1 "city center")) xtitle("Year") ///
 ytitle("Share, Black") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def2/Trends_nhgis_share_black_def2.gph", replace
 * White
 use "$data/final/nhgis_cbsa_1940_2010_def2.dta" , clear
 collapse (mean) share_white1 share_white2 share_white3 , by(year ) 
 *reshape wide share_white, i(year) j(rings) 
 twoway line share_white1 share_white2 share_white3 year, sort ///
 legend(order(3 "suburb2" 2 "suburb1" 1 "city center")) xtitle("Year") ///
 ytitle("Share, White") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def2/Trends_nhgis_share_white_def2.gph", replace
graph combine "$def2/Trends_nhgis_share_black_def2.gph" "$def2/Trends_nhgis_share_white_def2.gph"
graph export "$def2/Trends_nhgis_share_allocation_def2.png", as(png) replace
 
 * Graphic : Share of Graduated within rings
 use "$data/final/nhgis_cbsa_1940_2010_def2.dta" , clear
 collapse (mean) share_grad_r1 share_grad_r2 share_grad_r3, by(year ) 
 *reshape wide share_grad_r, i(year) j(rings) 
 twoway line share_grad_r1 share_grad_r2 share_grad_r3 year, sort ///
 legend(order(3 "suburb2" 2 "suburb1" 1 "city center"))  xtitle("Year") ///
 ytitle("Share") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def2/Trends_nhgis_share_grad_r_def2.png", as(png) replace
 
 * Graphic : Share of Graduated living in rings
 use "$data/final/nhgis_cbsa_1940_2010_def2.dta" , clear
 collapse (mean) share_grad1 share_grad2 share_grad3 , by(year ) 
 *reshape wide share_grad, i(year) j(rings) 
 twoway line share_grad1 share_grad2 share_grad3 year, sort ///
 legend(order(3 "suburb2" 2 "suburb1" 1 "city center")) xtitle("Year") ///
 ytitle("Share") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def2/Trends_nhgis_share_grad_def2.png", as(png) replace
 
 * Graphic : the evolution of Dissimilarity index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def2.dta" , clear
 drop if cbsa_black<1000
 collapse (mean) D_race D_educ [w=cbsa_pop] , by(year) 
 line D_race year, sort ///
 legend(order( 1 "Mean of Racial Dissimilarity Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def2/Trends_nhgis_D_race_def2.gph", replace
 line D_educ year, sort ///
 legend(order( 1 "Mean of Educational Dissimilarity Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def2/Trends_nhgis_D_educ_def2.gph", replace
 graph combine "$def2/Trends_nhgis_D_race_def2.gph" "$def2/Trends_nhgis_D_educ_def2.gph" 
graph export "$def2/dissimilarity_weight_def2.png", as(png) replace

 * Graphic : the evolution of Isolation index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def2.dta" , clear
 collapse (mean) Iso_race Iso_educ [w=cbsa_pop], by(year) 
 line Iso_race year, sort ///
 legend(order( 1 "Mean of Racial Isolation Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def2/Trends_nhgis_isolation_race_def2.gph", replace
 line Iso_educ year, sort ///
 legend(order( 1 "Mean of Educational Isolation Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def2/Trends_nhgis_isolation_educ_def2.gph", replace
 graph combine "$def2/Trends_nhgis_isolation_race_def2.gph" "$def2/Trends_nhgis_isolation_educ_def2.gph"
graph export "$def2/isolation_weight_def2.png", as(png) replace

* Graphic : the evolution of Interaction index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def2.dta" , clear
 collapse (mean) B_race B_educ [w=cbsa_pop], by(year) 
 line B_race year, sort ///
 legend(order( 1 "Mean of Racial Interaction Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def2/Trends_nhgis_interaction_race_def2.gph", replace
 line B_educ year, sort ///
 legend(order( 1 "Mean of Educational Interaction Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def2/Trends_nhgis_interaction_educ_def2.gph", replace
 graph combine "$def2/Trends_nhgis_interaction_race_def2.gph" "$def2/Trends_nhgis_interaction_educ_def2.gph"
graph export "$def2/interaction_weight_def2.png", as(png) replace

* Graphic : the evolution of Entropy index for racial segregation
 use "$data/final/nhgis_cbsa_1940_2010_def2.dta" , clear
 collapse (mean) H [w=cbsa_pop], by(year) 
 line H year, sort ///
 legend(order( 1 "Mean of Entropy Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def2/entropy_weight_def2.png", as(png) replace
 
** Definition 3 : cbsa divided in 4 zones according to 1990 distance from CBD **
 * Graphic :  share of population within ring 1 / ring 2 / ring 3 / ring 4
 use "$data/final/nhgis_cbsa_1940_2010_def3.dta" , clear
 collapse (mean) share_pop1 share_pop2 share_pop3 share_pop4 , by(year ) 
 *reshape wide share_pop, i(year) j(rings) 
 twoway line share_pop1 share_pop2 share_pop3 share_pop4 year, sort ///
 legend(order(4 "ring 4" 3 "ring 3" 2 "ring 2" 1 "ring 1")) xtitle("Year") ///
 ytitle("Share") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def3/Trends_nhgis_share_pop_def3.png", as(png) replace
 
 * Graphic : Share of black, white and other within cc, suburb1 and suburb2
 use "$data/final/nhgis_cbsa_1940_2010_def3.dta" , clear
 collapse (mean) share_black_r1 share_black_r2 share_black_r3 share_black_r4 share_white_r1 share_white_r2 share_white_r3 share_white_r4 share_other_r1 share_other_r2 share_other_r3 share_other_r4  , by(year ) 
 *reshape wide share_black_r share_white_r share_other_r, i(year) j(rings)
 * ring 1
 twoway line share_black_r1 share_white_r1 share_other_r1 year, sort ///
 legend(order(3 "other" 2 "white"  1 "black")) xtitle("Year") ///
 ytitle("Share within ring 1") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def3/Trends_nhgis_share_within_ring1_def3.gph", replace 
 * ring 2
 twoway line share_black_r2 share_white_r2 share_other_r2 year, sort ///
 legend(order(3 "other" 2 "white"  1 "black")) xtitle("Year") ///
 ytitle("Share within ring 2") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def3/Trends_nhgis_share_within_ring2_def3.gph", replace
 * ring 3
 twoway line share_black_r3 share_white_r3 share_other_r3 year, sort ///
 legend(order(3 "other" 2 "white"  1 "black")) xtitle("Year") ///
 ytitle("Share within ring 3") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def3/Trends_nhgis_share_within_ring3_def3.gph", replace
 * ring 4
 twoway line share_black_r4 share_white_r4 share_other_r4 year, sort ///
 legend(order(3 "other" 2 "white"  1 "black")) xtitle("Year") ///
 ytitle("Share within ring 4") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def3/Trends_nhgis_share_within_ring4_def3.gph", replace
graph combine "$def3/Trends_nhgis_share_within_ring1_def3.gph" "$def3/Trends_nhgis_share_within_ring2_def3.gph" "$def3/Trends_nhgis_share_within_ring3_def3.gph" "$def3/Trends_nhgis_share_within_ring4_def3.gph"
graph export "$def3/Trends_nhgis_share_within_def3.png", as(png) replace
 
 * Graphic : Share of Black and White living in rings
 * Black
 use "$data/final/nhgis_cbsa_1940_2010_def3.dta" , clear
 collapse (mean) share_black1 share_black2 share_black3 share_black4 , by(year ) 
 *reshape wide share_black, i(year) j(rings) 
 twoway line share_black1 share_black2 share_black3 share_black4 year, sort ///
 legend(order(4 "ring 4" 3 "ring 3" 2 "ring 2" 1 "ring 1")) xtitle("Year") ///
 ytitle("Share, Black") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def3/Trends_nhgis_share_black_def3.gph", replace
 * White
 use "$data/final/nhgis_cbsa_1940_2010_def3.dta" , clear
 collapse (mean) share_white1 share_white2 share_white3 share_white4 , by(year ) 
 *reshape wide share_white, i(year) j(rings) 
 twoway line share_white1 share_white2 share_white3 share_white4 year, sort ///
 legend(order(4 "ring 4" 3 "ring 3" 2 "ring 2" 1 "ring 1")) xtitle("Year") ///
 ytitle("Share, White") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def3/Trends_nhgis_share_white_def3.gph", replace
graph combine "$def3/Trends_nhgis_share_black_def3.gph" "$def3/Trends_nhgis_share_white_def3.gph"
graph export "$def3/Trends_nhgis_share_allocation_def3.png", as(png) replace
 
 * Graphic : Share of Graduated within rings
 use "$data/final/nhgis_cbsa_1940_2010_def3.dta" , clear
 collapse (mean) share_grad_r1 share_grad_r2 share_grad_r3 share_grad_r4 , by(year ) 
 *reshape wide share_grad_r, i(year) j(rings) 
 twoway line share_grad_r1 share_grad_r2 share_grad_r3 share_grad_r4 year, sort ///
 legend(order(4 "ring 4" 3 "ring 3" 2 "ring 2" 1 "ring 1"))  xtitle("Year") ///
 ytitle("Share") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def3/Trends_nhgis_share_grad_r_def3.png", as(png) replace
 
 * Graphic : Share of Graduated living in rings
 use "$data/final/nhgis_cbsa_1940_2010_def3.dta" , clear
 collapse (mean) share_grad1 share_grad2 share_grad3 share_grad4 , by(year ) 
 *reshape wide share_grad, i(year) j(rings) 
 twoway line share_grad1 share_grad2 share_grad3 share_grad4 year, sort ///
 legend(order(4 "ring 4" 3 "ring 3" 2 "ring 2" 1 "ring 1")) xtitle("Year") ///
 ytitle("Share") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def3/Trends_nhgis_share_grad_def3.png", as(png) replace
 
 * Graphic : the evolution of Dissimilarity index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def3.dta" , clear
 drop if cbsa_black<1000
 collapse (mean) D_race D_educ [w=cbsa_pop] , by(year) 
 line D_race year, sort ///
 legend(order( 1 "Mean of Racial Dissimilarity Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def3/Trends_nhgis_D_race_def3.gph", replace
 line D_educ year, sort ///
 legend(order( 1 "Mean of Educational Dissimilarity Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def3/Trends_nhgis_D_educ_def3.gph", replace
 graph combine "$def3/Trends_nhgis_D_race_def3.gph" "$def3/Trends_nhgis_D_educ_def3.gph" 
graph export "$def3/dissimilarity_weight_def3.png", as(png) replace

 * Graphic : the evolution of Isolation index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def3.dta" , clear
 collapse (mean) Iso_race Iso_educ [w=cbsa_pop], by(year) 
 line Iso_race year, sort ///
 legend(order( 1 "Mean of Racial Isolation Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def3/Trends_nhgis_isolation_race_def3.gph", replace
 line Iso_educ year, sort ///
 legend(order( 1 "Mean of Educational Isolation Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def3/Trends_nhgis_isolation_educ_def3.gph", replace
 graph combine "$def3/Trends_nhgis_isolation_race_def3.gph" "$def3/Trends_nhgis_isolation_educ_def3.gph"
graph export "$def3/isolation_weight_def3.png", as(png) replace

* Graphic : the evolution of Interaction index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def3.dta" , clear
 collapse (mean) B_race B_educ [w=cbsa_pop], by(year) 
 line B_race year, sort ///
 legend(order( 1 "Mean of Racial Interaction Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def3/Trends_nhgis_interaction_race_def3.gph", replace
 line B_educ year, sort ///
 legend(order( 1 "Mean of Educational Interaction Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def3/Trends_nhgis_interaction_educ_def3.gph", replace
 graph combine "$def3/Trends_nhgis_interaction_race_def3.gph" "$def3/Trends_nhgis_interaction_educ_def3.gph"
graph export "$def3/interaction_weight_def3.png", as(png) replace

* Graphic : the evolution of Entropy index for racial segregation
 use "$data/final/nhgis_cbsa_1940_2010_def3.dta" , clear
 collapse (mean) H [w=cbsa_pop], by(year) 
 line H year, sort ///
 legend(order( 1 "Mean of Entropy Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def3/entropy_weight_def3.png", as(png) replace

** Definition 4 : cbsa divided into decile zones with distance to CBD moving in time **
 * Graphic : the evolution of Dissimilarity index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def4.dta" , clear
 drop if cbsa_black<1000
 collapse (mean) D_race D_educ [w=cbsa_pop] , by(year) 
 line D_race year, sort ///
 legend(order( 1 "Mean of Racial Dissimilarity Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def4/Trends_nhgis_D_race_def4.gph", replace
 line D_educ year, sort ///
 legend(order( 1 "Mean of Educational Dissimilarity Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def4/Trends_nhgis_D_educ_def4.gph", replace
 graph combine "$def4/Trends_nhgis_D_race_def4.gph" "$def4/Trends_nhgis_D_educ_def4.gph" 
graph export "$def4/dissimilarity_weight_def4.png", as(png) replace

 * Graphic : the evolution of Isolation index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def4.dta" , clear
 collapse (mean) Iso_race Iso_educ [w=cbsa_pop], by(year) 
 line Iso_race year, sort ///
 legend(order( 1 "Mean of Racial Isolation Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def4/Trends_nhgis_isolation_race_def4.gph", replace
 line Iso_educ year, sort ///
 legend(order( 1 "Mean of Educational Isolation Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def4/Trends_nhgis_isolation_educ_def4.gph", replace
 graph combine "$def4/Trends_nhgis_isolation_race_def4.gph" "$def4/Trends_nhgis_isolation_educ_def4.gph"
graph export "$def4/isolation_weight_def4.png", as(png) replace

* Graphic : the evolution of Interaction index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def4.dta" , clear
 collapse (mean) B_race B_educ [w=cbsa_pop], by(year) 
 line B_race year, sort ///
 legend(order( 1 "Mean of Racial Interaction Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def4/Trends_nhgis_interaction_race_def4.gph", replace
 line B_educ year, sort ///
 legend(order( 1 "Mean of Educational Interaction Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def4/Trends_nhgis_interaction_educ_def4.gph", replace
 graph combine "$def4/Trends_nhgis_interaction_race_def4.gph" "$def4/Trends_nhgis_interaction_educ_def4.gph"
graph export "$def4/interaction_weight_def4.png", as(png) replace

* Graphic : the evolution of Entropy index for racial segregation
 use "$data/final/nhgis_cbsa_1940_2010_def4.dta" , clear
 collapse (mean) H [w=cbsa_pop], by(year) 
 line H year, sort ///
 legend(order( 1 "Mean of Entropy Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def4/entropy_weight_def4.png", as(png) replace

** Definition 5 : cbsa divided in 2 zones with distance to CBD moving in time **
 * Graphic : the evolution of Dissimilarity index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def5.dta" , clear
 drop if cbsa_black<1000
 collapse (mean) D_race D_educ [w=cbsa_pop] , by(year) 
 line D_race year, sort ///
 legend(order( 1 "Mean of Racial Dissimilarity Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def5/Trends_nhgis_D_race_def5.gph", replace
 line D_educ year, sort ///
 legend(order( 1 "Mean of Educational Dissimilarity Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def5/Trends_nhgis_D_educ_def5.gph", replace
 graph combine "$def5/Trends_nhgis_D_race_def5.gph" "$def5/Trends_nhgis_D_educ_def5.gph" 
graph export "$def5/dissimilarity_weight_def5.png", as(png) replace

 * Graphic : the evolution of Isolation index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def5.dta" , clear
 collapse (mean) Iso_race Iso_educ [w=cbsa_pop], by(year) 
 line Iso_race year, sort ///
 legend(order( 1 "Mean of Racial Isolation Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def5/Trends_nhgis_isolation_race_def5.gph", replace
 line Iso_educ year, sort ///
 legend(order( 1 "Mean of Educational Isolation Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def5/Trends_nhgis_isolation_educ_def5.gph", replace
 graph combine "$def5/Trends_nhgis_isolation_race_def5.gph" "$def5/Trends_nhgis_isolation_educ_def5.gph"
graph export "$def5/isolation_weight_def5.png", as(png) replace

* Graphic : the evolution of Interaction index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def5.dta" , clear
 collapse (mean) B_race B_educ [w=cbsa_pop], by(year) 
 line B_race year, sort ///
 legend(order( 1 "Mean of Racial Interaction Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def5/Trends_nhgis_interaction_race_def5.gph", replace
 line B_educ year, sort ///
 legend(order( 1 "Mean of Educational Interaction Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def5/Trends_nhgis_interaction_educ_def5.gph", replace
 graph combine "$def5/Trends_nhgis_interaction_race_def5.gph" "$def5/Trends_nhgis_interaction_educ_def5.gph"
graph export "$def5/interaction_weight_def5.png", as(png) replace

* Graphic : the evolution of Entropy index for racial segregation
 use "$data/final/nhgis_cbsa_1940_2010_def5.dta" , clear
 collapse (mean) H [w=cbsa_pop], by(year) 
 line H year, sort ///
 legend(order( 1 "Mean of Entropy Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def5/entropy_weight_def5.png", as(png) replace

** Definition 6 : cbsa divided in 3 zones with distance to CBD moving in time **
 * Graphic : the evolution of Dissimilarity index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def6.dta" , clear
 drop if cbsa_black<1000
 collapse (mean) D_race D_educ [w=cbsa_pop] , by(year) 
 line D_race year, sort ///
 legend(order( 1 "Mean of Racial Dissimilarity Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def6/Trends_nhgis_D_race_def6.gph", replace
 line D_educ year, sort ///
 legend(order( 1 "Mean of Educational Dissimilarity Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def6/Trends_nhgis_D_educ_def6.gph", replace
 graph combine "$def6/Trends_nhgis_D_race_def6.gph" "$def6/Trends_nhgis_D_educ_def6.gph" 
graph export "$def6/dissimilarity_weight_def6.png", as(png) replace

 * Graphic : the evolution of Isolation index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def6.dta" , clear
 collapse (mean) Iso_race Iso_educ [w=cbsa_pop], by(year) 
 line Iso_race year, sort ///
 legend(order( 1 "Mean of Racial Isolation Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def6/Trends_nhgis_isolation_race_def6.gph", replace
 line Iso_educ year, sort ///
 legend(order( 1 "Mean of Educational Isolation Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def6/Trends_nhgis_isolation_educ_def6.gph", replace
 graph combine "$def6/Trends_nhgis_isolation_race_def6.gph" "$def6/Trends_nhgis_isolation_educ_def6.gph"
graph export "$def6/isolation_weight_def6.png", as(png) replace

* Graphic : the evolution of Interaction index for racial and educational segregation
 use "$data/final/nhgis_cbsa_1940_2010_def6.dta" , clear
 collapse (mean) B_race B_educ [w=cbsa_pop], by(year) 
 line B_race year, sort ///
 legend(order( 1 "Mean of Racial Interaction Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def6/Trends_nhgis_interaction_race_def6.gph", replace
 line B_educ year, sort ///
 legend(order( 1 "Mean of Educational Interaction Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
 graph save "$def6/Trends_nhgis_interaction_educ_def6.gph", replace
 graph combine "$def6/Trends_nhgis_interaction_race_def6.gph" "$def6/Trends_nhgis_interaction_educ_def6.gph"
graph export "$def6/interaction_weight_def6.png", as(png) replace

* Graphic : the evolution of Entropy index for racial segregation
 use "$data/final/nhgis_cbsa_1940_2010_def6.dta" , clear
 collapse (mean) H [w=cbsa_pop], by(year) 
 line H year, sort ///
 legend(order( 1 "Mean of Entropy Index ")) xtitle("Year") ///
 ytitle("") xline(0, lcolor(gs10) lpattern(dash)) 
graph export "$def6/entropy_weight_def6.png", as(png) replace



