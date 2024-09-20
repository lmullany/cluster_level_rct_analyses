* do file to create data set of demo
clear
use "../data/Birth Size_WIDE_Feb 2024.dta"

keep studyid liveborn_ib ab_facalloc weight_hc_bb_com2  btweigthtime_hc_ el_hc mo_age mo_parity bmi ba_landown ba_educ_r2 ba_occu_r sp_preterm ch_sex ba_moht1 GA_PREGOUT
* let's rename them
rename liveborn livebirth
rename ab_facalloc facility_trt
rename weight_hc_bb_com2 weight
rename btweigthtime_hc_ weight_time_met
rename el_hc cluster_label
rename mo_age mother_age
rename mo_parity mother_parity
rename ba_landown land_ownership
rename ba_educ_r2 education
rename ba_occu_r occupation
rename sp_preterm preterm
rename ch_sex sex
rename ba_moht1 mother_height
rename GA_PREGOUT gest_age

* replace weight to grams (from kg)
replace weight = weight*1000
recode sex 2=0

label var sex "sex of baby/fetus"
label var gest_age "gestational age at outcome"
label var mother_height "height of mother (cm)"
label var studyid "study id"
label var facility_trt "facility treatment/allocation group"
label var weight "weight of baby in grams"
label var weight_time_met "weight measurement time met"
label var mother_age "age of mother"
label var bmi "body mass index of mother"
label var mother_parity "parity of mother"
label var education "highest level of education attained"
label var livebirth "baby was born alive"
label var preterm "baby was born preterm"
label var cluster_label "cluster label/name"
label var occupation "reported occupation"
label var land_ownership "household owns land"

label drop ab_facalloc
label define alloc 0 "NON-ENP" 1 "ENP"
replace facility_trt = 0 if facility_trt==2
label values facility_trt alloc


label copy ba_occu_r occ
label drop ba_occu_r
label values occupation occ

label copy ba_educ_r2 edu
label drop ba_educ_r2
label values education edu

label copy el_hc clust
label drop el_hc
label value cluster_label clust

label copy ba_landown land
label drop ba_landown
label values land_ownership land

* make sure that nutrition intervention is 1, not 0!

mi unset, asis
xtset, clear

save "../data/baby_level_cluster_rct_data.dta", replace
