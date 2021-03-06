functions {
  #include ssm.stan
}
data {
  int<lower = 1> n;
  int<lower = 1> p;
  vector<lower = 0., upper = 1.>[p] y[n];
  vector<lower = 0., upper = 0.25>[p] sigma_eps[n];
  int p_t[n];
  int y_idx[n, p];
  vector<lower = 0.>[1] a1;
  cov_matrix[1] P1;

  real<lower = 0.> zeta;
  real<lower = 0.> sigma_delta;
}
transformed data {
  // system matrices
  matrix[1, 1] T[1];
  matrix[p, 1] Z[1];
  matrix[p, p] H[n];
  matrix[1, 1] R[1];
  vector[1] c[1];
  int filter_sz;
  T[1] = rep_matrix(1., 1, 1);
  Z[1] = rep_matrix(1., p, 1);
  R[1] = rep_matrix(1., 1, 1);
  c[1] = rep_vector(0., 1);
  for (t in 1:n) {
    H[t] = diag_matrix(sigma_eps[t] .* sigma_eps[t]);
  }
  # Calculates the size of the vectors returned by ssm_filter
  filter_sz = ssm_filter_size(1, p);
}
parameters {
  real<lower = 0.> sigma_eta;
  vector[p - 1] delta;
}
transformed parameters {
  vector[p] d[1];
  matrix[1, 1] Q[1];
  d[1, 1] = 0.;
  d[1, 2:p] = delta;
  Q[1] = rep_matrix(pow(sigma_eta, 2), 1, 1);
}
model {
  delta ~ normal(0., sigma_delta);
  sigma_eta ~ cauchy(0., zeta);
  target += ssm_miss_lp(y, d, Z, H,
                        c, T, R, Q, a1, P1,
                        p_t, y_idx);
}
generated quantities {
  vector[1] alpha[n];
  vector[1] alpha_mean[n];
  vector[filter_sz] filtered[n];
  filtered = ssm_filter_miss(y, d, Z, H, c, T, R, Q, a1, P1, p_t, y_idx);
  alpha_mean = ssm_smooth_states_mean(filtered, Z, c, T, R, Q);
  alpha = ssm_simsmo_states_miss_rng(filtered, d, Z, H, c, T, R, Q,
                                     a1, P1, p_t, y_idx);
}
