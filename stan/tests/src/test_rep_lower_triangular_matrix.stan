functions {
  #include ssm.stan
}
data {
  real x;
  int m;
  int n;
  int diag;
}
model {}
generated quantities {
  matrix[m, n] output;
  output = rep_lower_triangular_matrix(x, m, n, diag);
}
