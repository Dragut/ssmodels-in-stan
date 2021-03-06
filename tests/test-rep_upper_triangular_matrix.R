#function: rep_upper_triangular_matrix
context("rep_upper_triangular_matrix")

test_rep_upper_triangular_matrix <- function(x, m, n, diag, expected) {
  .data <- list(x = x, m = m, n = n, diag = diag)
  modfit <- test_stan_function("rep_upper_triangular_matrix", data = .data)
  output <- rstan::extract(modfit, "output")[[1]]
  dim(output) <- dim(output)[2:3]
  expect_equal(output, expected)
}

rep_upper_triangular_matrix_params <-
  list(list(x = 1, m = 2, n = 2, diag = 1,
            expected = matrix(c(1, 1,
                                0, 1), byrow = TRUE, 2, 2)),
       list(x = 1, m = 2, n = 2, diag = 0,
            expected = matrix(c(0, 1,
                                0, 0), byrow = TRUE, 2, 2)),
       list(x = 2, m = 2, n = 2, diag = 1,
            expected = matrix(c(2, 2,
                                0, 2), byrow = TRUE, 2, 2)),
       list(x = 1, m = 3, n = 2, diag = 1,
            expected = matrix(c(1, 1,
                                0, 1,
                                0, 0), byrow = TRUE, 3, 2)),
       list(x = 1, m = 2, n = 3, diag = 1,
            expected = matrix(c(1, 1, 1,
                                0, 1, 1), byrow = TRUE, 2, 3)),
       list(x = 1, m = 2, n = 3, diag = 0,
            expected = matrix(c(0, 1, 1,
                                0, 0, 1), byrow = TRUE, 2, 3)),
       list(x = 1, m = 1, n = 1, diag = 1,
            expected = matrix(1, 1, 1)),
       list(x = 1, m = 1, n = 1, diag = 0,
            expected = matrix(0, 1, 1))
  )

for (.x in rep_upper_triangular_matrix_params) {
  test_that(sprintf("rep_upper_triangular_matrix works with x = %d, m = %d, n = %d, diag = %d \n",
                    .x$x, .x$m, .x$n, .x$diag), {
    invoke(test_rep_upper_triangular_matrix, .x)
  })
}
