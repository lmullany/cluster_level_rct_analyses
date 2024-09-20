program define mi_pooled, rclass
	version 16.1
	syntax varlist(min=2 max=3 numeric)
	tokenize `varlist'
	
	* summarize the first variable, which is the list of betas
	qui sum `1'
	* the pooled estimate is just mean of the betas
	tempname pe
	scalar `pe' = r(mean)
	* the between imputation variance is the variance of these betas
	tempname bv
	scalar `bv' = r(Var)
	
	* summarize the second variable, which is the list of variances
	qui sum `2'
	* the within imputation variance is the mean of the variances
	tempname wv
	scalar `wv' = r(mean)
	
	* the total variance is the within imputation variance plus the 
	* between imputation variance  + the between
	* imputation variance divided by the number of observation)
	tempname tv
	scalar `tv' = `wv' + `bv' + `bv'/`=_N'
	
	* degrees of freedom:
	tempname r
	scalar `r' = (`bv' + `bv'/`=_N')/`wv'
	tempname _df
	scalar `_df' = (`=_N'-1)*(1+1/`r')^2
	
	* 
	if "`3'"!="" {
	    qui sum `3'
		tempname v_complete
		scalar `v_complete' = r(min)
		tempname gam
		scalar `gam'= (1 + 1/`=_N')*`bv'/`tv'
		tempname v_obs
		scalar `v_obs' = `v_complete'*(`v_complete'+1)*(1-`gam')/(`v_complete' + 3)
		scalar `_df' = (1/`_df' + 1/`v_obs')^-1
	}
	
	* return these scalars
	return scalar b=`pe'
	return scalar V=`tv'
	return scalar wv = `wv'
	return scalar bv = `bv'
	return scalar m = `=_N'
	return scalar deg_freedom = `_df'

end
