capture program drop t_test_binary_ci

program define t_test_binary_ci
  syntax, [Level(real 95)]
  * get the estimate of relative risk, which is the ratio of the means (of cluster-level means) in group 1 and
  * the means (of cluster-level means) of group 2
  scalar est =  r(mu_1)/r(mu_2)
 
  * approx 95% CI:
  * first get the variance (V) and use the t distribution, with appropriate degress of freedom
  * to get a mulitiplicative risk factor
  scalar V = r(sd_1)^2/(r(N_1)*r(mu_1)^2) + r(sd_2)^2/(r(N_2)*r(mu_2)^2)
  local alpha = (100-`level')/100
  scalar err_factor = exp(invt(r(df_t), `alpha'/2)*sqrt(V))

  * get the lower bound as the estimate mutiplied by this factor, while the 
  * upper bound is the estimate divided by this factor
  scalar lower = est*err_factor
  scalar upper = est/err_factor

  di "{hline 40}"
  di "Est" _col(16) "`level' %CI"
  di "{hline 40}"

  di %4.3f est _col(14) "( " %4.3f lower " - " %4.3f upper " )"
  di "{hline 40}"

end