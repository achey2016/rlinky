context("Connect and disconnect functions")
test_that("access_enedis returns a response", {
  expect_that(access_enedis(), is_a("response"))
})
test_that("access_enedis returns the content of a temporary file", {
  testfile <- tempfile()
  cat("test", file = testfile)
  tfr <- access_enedis(paste("file://", testfile, sep = ""))
  expect_that(tfr, is_a("response"))
  expect_equal(httr::content(tfr, "text"), "test")
})
test_that("access_enedis stops when the page is not available", {
  expect_error(access_enedis("http://httpbin.org/status/404"))
})
test_that("connect_enedis returns a response", {
  expect_that(connect_enedis(), is_a("response"))
})

test_that("connect_enedis returns the content of a specially crafted file", {
  testfile <- tempfile()
  testcontent <- "<html><body>MODE CONNECTE</body></html>"
  cat(testcontent, file = testfile)
  tfr <- connect_enedis(paste("file://", testfile, sep = ""))
  expect_that(tfr, is_a("response"))
  expect_equal(httr::content(tfr, "text"), testcontent)
})
test_that("disconnect_enedis returns a response", {
  expect_that(disconnect_enedis(), is_a("response"))
})
