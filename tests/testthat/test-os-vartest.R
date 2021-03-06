context("os-vartest")

test_that("output from infer_os_var_test matches the expected result", {
  k <- infer_os_var_test(mtcars, mpg, 0.3)
  expect_equal(k$n, 32)
  expect_equal(k$sd, 0.3)
  expect_equal(k$sigma, 6.0269)
  expect_equal(k$se, 1.0654)
  expect_equal(round(k$chi, 2), 12511.64)
  expect_equal(k$df, 31)
  expect_equal(k$p_lower, 1)
  expect_equal(k$p_upper, 0)
  expect_equal(k$p_two, 0)
  expect_equal(k$xbar, 20.0906)
  expect_equal(k$c_lwr, 3.8737)
  expect_equal(k$c_upr, 10.6527)
  expect_equal(k$conf, 0.95)
  expect_equivalent(k$var_name, "mpg")
  expect_equivalent(k$type, "both")
})


test_that("infer_os_var_test returns appropriate errors", {
  expect_error(
    infer_os_var_test(hsb, race, 0.3),
    "x must be numeric"
  )
  expect_error(
    infer_os_var_test(mtcars, mpg, "0.3"),
    "sd must be numeric"
  )
  expect_error(
    infer_os_var_test(mtcars, mpg, 0.3, "0.95"),
    "confint must be numeric"
  )
})


test_that("output from one sample variance test is as expected when alternative is less", {
  x <- cat("                            One-Sample Statistics
-----------------------------------------------------------------------------
 Variable    Obs     Mean      Std. Err.    Std. Dev.    [95% Conf. Interval]
-----------------------------------------------------------------------------
   mpg       32     20.0906     1.0654       6.0269        3.8737    10.6526
-----------------------------------------------------------------------------

            Lower Tail Test
            ---------------
           Ho: sd(mpg) >= 5
            Ha: sd(mpg) < 5

    Chi-Square Test for Variance
-------------------------------------
 Variable       c       DF      Sig
-------------------------------------
   mpg       45.041     31     0.9506
-------------------------------------")

  expect_equivalent(print(infer_os_var_test(mtcars, mpg, 5, alternative = "less")), x)
})

test_that("output from one sample variance test is as expected when alternative is greater", {
  x <- cat("                            One-Sample Statistics
-----------------------------------------------------------------------------
 Variable    Obs     Mean      Std. Err.    Std. Dev.    [95% Conf. Interval]
-----------------------------------------------------------------------------
   mpg       32     20.0906     1.0654       6.0269        3.8737    10.6526
-----------------------------------------------------------------------------

            Upper Tail Test
            ---------------
           Ho: sd(mpg) <= 5
            Ha: sd(mpg) > 5

    Chi-Square Test for Variance
-------------------------------------
 Variable       c       DF      Sig
-------------------------------------
   mpg       45.041     31     0.0494
-------------------------------------")

  expect_equivalent(print(infer_os_var_test(mtcars, mpg, 5, alternative = "greater")), x)
})

test_that("output from one sample variance test is as expected when alternative is both", {
  x <- cat("                            One-Sample Statistics
-----------------------------------------------------------------------------
 Variable    Obs     Mean      Std. Err.    Std. Dev.    [95% Conf. Interval]
-----------------------------------------------------------------------------
   mpg       32     20.0906     1.0654       6.0269        3.8737    10.6526
-----------------------------------------------------------------------------

             Two Tail Test
            ---------------
            Ho: sd(mpg) = 5
           Ha: sd(mpg) != 5

    Chi-Square Test for Variance
-------------------------------------
 Variable       c       DF      Sig
-------------------------------------
   mpg       45.041     31     0.0989
-------------------------------------")

  expect_equivalent(print(infer_os_var_test(mtcars, mpg, 5, alternative = "both")), x)
})

test_that("output from one sample variance test is as expected when alternative is all", {
  x <- cat("                            One-Sample Statistics
-----------------------------------------------------------------------------
 Variable    Obs     Mean      Std. Err.    Std. Dev.    [95% Conf. Interval]
-----------------------------------------------------------------------------
   mpg       32     20.0906     1.0654       6.0269        3.8737    10.6526
-----------------------------------------------------------------------------

                                Ho: sd(mpg) = 5

         Ha: sd < 5                Ha: sd != 5                 Ha: sd > 5
        c = 45.0412                c = 45.0412                c = 45.0412
     Pr(C < c) = 0.9506       2 * Pr(C > c) = 0.0989       Pr(C > c) = 0.0494")

  expect_equivalent(print(infer_os_var_test(mtcars, mpg, 5, alternative = "all")), x)
})
