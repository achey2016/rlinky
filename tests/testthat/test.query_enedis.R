context("Query functions")
test_that("change_dates returns a list", {
  expect_that(change_dates(), is_a("list"))
})
test_that("change_dates returns one month before 2017-10-10", {
  new_form <- change_dates(end_date = as.Date("2017-10-10"))
  expect_that(new_form[["input"]], is_a("list"))
  expect_that(new_form[["input"]][[2]], is_a("character"))
  expect_equal(as.Date(new_form[["input"]][[2]], format = "%d/%m/%Y"),
               as.Date("2017-10-10"))
  expect_that(new_form[["input"]][[1]], is_a("character"))
  expect_equal(as.Date(new_form[["input"]][[1]], format = "%d/%m/%Y"),
               as.Date("2017-09-10"))
})
test_that("query_daily_month returns data", {
  connect_enedis()
  this_month_data <- query_daily_month(end_date = as.Date("2018-12-31"))
  disconnect_enedis()
  expect_that(this_month_data, is_a("list"))
  expect_that(this_month_data$etat, is_a("list"))
  expect_equal(this_month_data$etat$valeur, "termine")
  expect_that(this_month_data$graphe, is_a("list"))
  expect_equal(this_month_data$graphe$periode$dateFin, "31/12/2018")
  expect_that(this_month_data$graphe$data, is_a("data.frame"))
})
