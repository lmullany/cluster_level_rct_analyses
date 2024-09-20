//Table 4a. Effects of Enhanced Nutrition Package on Pregnancy Outcomes
 use "C:\Users\yunhee\Documents\ENAT DATA ANALYSIS\Final Dataset_May 31 2023\Enroll_ELF_BIRTH_keydata OCT 2023_6A6D_US_GA.dta"


*Known Pregnancy Outcome (n)
use "C:\Users\yunhee\Documents\ENAT DATA ANALYSIS\Final Dataset_May 31 2023\Enroll_ELF_BIRTH_keydata OCT 2023_6A6D_US_GA.dta"
ta mb_liveborn ab_facalloc

* Live births (n) 
use "C:\Users\yunhee\Documents\ENAT DATA ANALYSIS\Final Dataset_May 31 2023\Birth Size_WIDE_Feb 2024.dta"

ta liveborn_ib ab_facalloc
//PRIMARY OUTCOMES

//Newborn weight (<72 hrs)e, mean (SD), g 
bys  ab_facalloc: sum weight_hc_bb_com2 if btweigthtime_hc_==1 & liveborn_ib==1

drop resid
xi: regress weight_hc_bb_com2 if btweigthtime_hc_==1 & liveborn_ib==1
predict resid, residuals
preserve
collapse (mean) resid if btweigthtime_hc_==1 & liveborn_ib==1, by(ab_facalloc el_hc)
list in 1/12
ttest resid, by(ab_facalloc) level (97.5)
restore

 drop resid
xi: regress weight_hc_bb_com2 mo_age mo_parity bmi ba_landown i.ba_educ_r2 i.ba_occu_r if btweigthtime_hc_==1 & liveborn_ib==1
predict resid, residuals
preserve
collapse (mean) resid weight_hc_bb_com2 if btweigthtime_hc_==1 & liveborn_ib==1, by(ab_facalloc el_hc)
list in 1/12
ttest resid, by(ab_facalloc) level (97.5)
restore


//Newborn length (<72 hrs) f, mean (SD), cm
bys ab_facalloc: sum ln_hc_bb_com2 if btlntime_hc_==1 & liveborn_ib==1
drop resid
xi: regress ln_hc_bb_com2  if btlntime_hc_==1 & liveborn_ib==1
predict resid, residuals
preserve
collapse (mean) resid ln_hc_bb_com2 if btlntime_hc_==1 & liveborn_ib==1, by(ab_facalloc el_hc)
list in 1/12
ttest resid, by(ab_facalloc) (97.5)
restore

 drop resid
xi: regress ln_hc_bb_com2 mo_age mo_parity bmi ba_landown i.ba_educ_r2 i.ba_occu_r if btlntime_hc_==1 & liveborn_ib==1
predict resid, residuals
preserve
collapse (mean) resid ln_hc_bb_com2 if btlntime_hc_==1 & liveborn_ib==1, by(ab_facalloc el_hc)
list in 1/12
ttest resid, by(ab_facalloc) (97.5)
restore

//SECONDARY OUTCOMES
//Gestational age, mean (SD), wks
use "C:\Users\yunhee\Documents\ENAT DATA ANALYSIS\Final Dataset_May 31 2023\Enroll_ELF_BIRTH_keydata OCT 2023_6A6D_US_GA.dta"
 drop resid
xi: regress GA_PREGOUT if mb_liveborn!=.
predict resid, residuals
preserve
collapse (mean) resid GA_PREGOUT if mb_liveborn!=., by(ab_facalloc el_hc)
list in 1/12
ttest resid, by(ab_facalloc)
restore

 drop resid
xi: regress GA_PREGOUT mo_age mo_parity bmi ba_landown i.ba_educ_r2 i.ba_occu_r if mb_liveborn!=.
predict resid, residuals
preserve
collapse (mean) resid GA_PREGOUT if mb_liveborn!=., by(ab_facalloc el_hc)
list in 1/12
ttest resid, by(ab_facalloc)
restore


//Preterm deliveries, n/N (%)
use "C:\Users\yunhee\Documents\ENAT DATA ANALYSIS\Final Dataset_May 31 2023\Enroll_ELF_BIRTH_keydata OCT 2023_6A6D_US_GA.dta"
 preserve
 glm  sp_preterm_del if mb_liveborn!=0 & sp_preterm_del!=., fam(bin) link(log)
 predict pred, xb
 replace pred = exp(pred)
 collapse (sum) expected = pred observed=sp_preterm_del if mb_liveborn!=0 & sp_preterm_del!=., by(el_hc ab_facalloc)
 gen residual_ratio = observed/expected
 ttest residual_ratio, by(ab_facalloc)
 t_test_binary_ci
 
   preserve
 glm  sp_preterm_del mo_age mo_parity ba_landown bmi i.ba_educ_r2 i.ba_occu_r if mb_liveborn!=0 & sp_preterm_del!=., fam(bin) link(log)
 predict pred, xb
 replace pred = exp(pred)
 collapse (sum) expected = pred observed=sp_preterm_del if mb_liveborn!=0 & sp_preterm_del!=., by(el_hc ab_facalloc)
 gen residual_ratio = observed/expected
 ttest residual_ratio, by(ab_facalloc)
 t_test_binary_ci

//Preterm livebirths, n/N (%)
use "C:\Users\yunhee\Documents\ENAT DATA ANALYSIS\Final Dataset_May 31 2023\Birth Size_WIDE_Feb 2024.dta"
 preserve
 glm sp_preterm if liveborn_ib==1 & sp_preterm!=., fam(bin) link(log)
 predict pred, xb
 replace pred = exp(pred)
 collapse (sum) expected = pred observed=sp_preterm if liveborn_ib==1 & sp_preterm!=., by(el_hc ab_facalloc)
 gen residual_ratio = observed/expected
 ttest residual_ratio, by(ab_facalloc)
 t_test_binary_ci 
 
  preserve
 glm sp_preterm mo_age mo_parity ba_landown bmi i.ba_educ_r2 i.ba_occu_r  if liveborn_ib==1 & sp_preterm!=., fam(bin) link(log)
 predict pred, xb
 replace pred = exp(pred)
 collapse (sum) expected = pred observed=sp_preterm if liveborn_ib==1 & sp_preterm!=., by(el_hc ab_facalloc)
 gen residual_ratio = observed/expected
 ttest residual_ratio, by(ab_facalloc)
  t_test_binary_ci

//Small for gestational age, n/N (%)
ta SGA ab_facalloc if liveborn_ib==1 & btweigthtime_hc_==1, chi col 
 preserve
 glm SGA if btweigthtime_hc_==1  & liveborn_ib==1 & SGA!=., fam(bin) link(log)
 predict pred, xb
 replace pred = exp(pred)
 collapse (sum) expected = pred observed=SGA if btweigthtime_hc_==1  & liveborn_ib==1 & SGA!=., by(el_hc ab_facalloc)
 gen residual_ratio = observed/expected
 ttest residual_ratio, by(ab_facalloc)
   t_test_binary_ci
   
     preserve
 glm SGA mo_age mo_parity ba_landown bmi i.ba_educ_r2 i.ba_occu_r  if btweigthtime_hc_==1  & liveborn_ib==1 & SGA!=., fam(bin) link(log)
 predict pred, xb
 replace pred = exp(pred)
 collapse (sum) expected = pred observed=SGA if btweigthtime_hc_==1  & liveborn_ib==1 & SGA!=., by(el_hc ab_facalloc)
 gen residual_ratio = observed/expected
 ttest residual_ratio, by(ab_facalloc)
  t_test_binary_ci

//Low birthweight (<2500g), n/N (%)
tab lbw ab_facalloc if btweigthtime_hc_==1  & liveborn_ib==1, col
 preserve
 glm lbw if btweigthtime_hc_==1  & liveborn_ib==1 & lbw!=., fam(bin) link(log)
 predict pred, xb
 replace pred = exp(pred)
 collapse (sum) expected = pred observed=lbw if btweigthtime_hc_==1  & liveborn_ib==1 & lbw!=., by(el_hc ab_facalloc)
 gen residual_ratio = observed/expected
 ttest residual_ratio, by(ab_facalloc)
 t_test_binary_ci

  preserve
 glm lbw mo_age mo_parity ba_landown bmi i.ba_educ_r2 i.ba_occu_r  if btweigthtime_hc_==1  & liveborn_ib==1 & lbw!=., fam(bin) link(log)
 predict pred, xb
 replace pred = exp(pred)
 collapse (sum) expected = pred observed=lbw if btweigthtime_hc_==1  & liveborn_ib==1 & lbw!=., by(el_hc ab_facalloc)
 gen residual_ratio = observed/expected
 ttest residual_ratio, by(ab_facalloc)
 t_test_binary_ci

 
//Stillbirths, n/N (rate per 1000 births)
ta stillbirth_ib_r ab_facalloc

 preserve
 glm  stillbirth_ib_r, fam(bin) link(log)
 predict pred, xb
 replace pred = exp(pred)
 collapse (sum) expected = pred observed=stillbirth_ib_r, by(el_hc ab_facalloc)
 gen residual_ratio = observed/expected
 ttest residual_ratio, by(ab_facalloc)
 t_test_binary_ci
 
    preserve
 glm stillbirth_ib_r mo_age mo_parity ba_landown bmi i.ba_educ_r2 i.ba_occu_r, fam(bin) link(log)
 predict pred, xb
 replace pred = exp(pred)
 collapse (sum) expected = pred observed=stillbirth_ib_r, by(el_hc ab_facalloc)
 gen residual_ratio = observed/expected
 ttest residual_ratio, by(ab_facalloc)
  t_test_binary_ci

//Newborn weight for age z-scoree, mean (SD)
bys ab_facalloc:  sum waz if liveborn_ib==1 & btweigthtime_hc_==1 

drop resid
xi: regress waz if liveborn_ib==1 & btweigthtime_hc_==1 
predict resid, residuals
preserve
collapse (mean) resid waz if  liveborn_ib==1 & btweigthtime_hc_==1, by(ab_facalloc el_hc)
list in 1/12
ttest resid, by(ab_facalloc)
restore

  drop resid
xi: regress waz mo_age mo_parity bmi ba_landown i.ba_educ_r2 i.ba_occu_r if liveborn_ib==1 & btweigthtime_hc_==1 
predict resid, residuals
preserve
collapse (mean) resid waz if  liveborn_ib==1 & btweigthtime_hc_==1, by(ab_facalloc el_hc)
list in 1/12
ttest resid, by(ab_facalloc)
restore

//Newborn length for age z-scoref, mean (SD)
  bys ab_facalloc:  sum laz if liveborn_ib==1 & btlntime_hc_==1 
 drop resid
xi: regress laz  if liveborn_ib==1 & btlntime_hc_==1 
predict resid, residuals
preserve
collapse (mean) resid laz if liveborn_ib==1 & btlntime_hc_==1, by(ab_facalloc el_hc)
list in 1/12
ttest resid, by(ab_facalloc)
restore
  
   drop resid
xi: regress laz mo_age mo_parity bmi ba_landown i.ba_educ_r2 i.ba_occu_r if liveborn_ib==1 & btlntime_hc_==1 
predict resid, residuals
preserve
collapse (mean) resid laz if liveborn_ib==1 & btlntime_hc_==1, by(ab_facalloc el_hc)
list in 1/12
ttest resid, by(ab_facalloc)
restore


//Newborn head circumferenceh, mean (SD), cm
 bys ab_facalloc: sum hcz if liveborn_ib==1 & btlntime_hc_==1
 drop resid
xi: regress hcz if liveborn_ib==1 & btlntime_hc_==1
predict resid, residuals
preserve
collapse (mean) resid hcz if  liveborn_ib==1 & btlntime_hc_==1, by(ab_facalloc el_hc)
list in 1/12
ttest resid, by(ab_facalloc)
restore

 drop resid
xi: regress hcz mo_age mo_parity bmi ba_landown i.ba_educ_r2 i.ba_occu_r if liveborn_ib==1 &btlntime_hc_==1
predict resid, residuals
preserve
collapse (mean) resid hcz if  liveborn_ib==1 & btlntime_hc_==1, by(ab_facalloc el_hc)
list in 1/12
ttest resid, by(ab_facalloc)
restore




