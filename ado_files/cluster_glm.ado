capture program drop cluster_glm

program define cluster_glm, eclass properties(mi)
    syntax varlist(min=1 numeric), cluster(varname) trt(varname) [family(string),Level(real 95)]
    marksample touse
    tokenize `varlist'
    quietly {
        preserve
        if "`family'" == "binomial" {
            glm `varlist', family(`family') link(log)
            predict prob if e(sample)==1, xb
            replace prob = exp(prob)
            collapse (sum) expected = prob observed = `1', by(`trt' `cluster')
            gen cluster_y = observed/expected          
            qui ttest cluster_y, by(`trt') reverse
            noi t_test_binary_ci, level(`level')
            matrix b = (log(r(mu_1)) - log(r(mu_2))), log(r(mu_2))
            matrix colnames b = `trt' _cons
            matrix rownames b = y1
            scalar V = r(sd_1)^2/(r(N_1)*r(mu_1)^2) + r(sd_2)^2/(r(N_2)*r(mu_2)^2)
            scalar consV = r(sd_2)^2/(r(N_2)*r(mu_2)^2)
            matrix V = V, consV \ consV, -1*consV
            matrix rownames V = `trt' _cons
            matrix colnames V = `trt' _cons
            if "`2'" == "" local title = "Binary Outcome, No Adjustment"
            else local title = "Binary Outcome, Adjusted for Covariate(s)"
            
        } 
        else {
            glm `varlist', family(`family')
            predict resid if e(sample), working
            collapse (mean) cluster_y = resid, by(`trt' `cluster')
            noi regress cluster_y `trt', level(`level')
            matrix b = e(b)
            matrix V = e(V)
            if "`2'" == "" local title = "Continuous Outcome, No Adjustment"
            else local title = "Continuous Outcome, Adjusted for Covariate(s)"
        }
        
        local n = _N
        local df_m = 1
        local df_r = `n' - 2
        restore
    }

    ereturn post b V, esample(`touse')
    ereturn local cmd ="glm"
    ereturn scalar N = `n'
    ereturn local title = "`title'"
    ereturn scalar df_m = `df_m'
    ereturn scalar df_r = `df_r'


end