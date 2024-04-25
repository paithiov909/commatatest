
<!-- README.md is generated from README.Rmd. Please edit that file -->

# commatatest

<!-- badges: start -->
<!-- badges: end -->

This R package is proof of concept for rewriting `prettify` function
using [commata](https://github.com/furfurylic/commata).

Currently, `prettify` uses `readr::read_delim` function of which parsing
in-memory data is limited
(<https://github.com/tidyverse/vroom/issues/460>).

The following simple benchmark shows that `prettify2` (wrapping commata)
is faster than `prettify`, even though it is not multithreaded.

Since `prettify` provides no way to guess the column type, using the
readr package may be overkill.

``` r
library(commatatest)

vec <- sample(gibasa::ginga, size = 5 * 1e3, replace = TRUE)

df <- gibasa::tokenize(
  data.frame(
    doc_id = seq_along(vec),
    text = vec
  )
)
nrow(df)
#> [1] 228034

microbenchmark::microbenchmark(
  current = commatatest::prettify(df, col_select = c("POS1", "Yomi1")),
  current_lim_threads = withr::with_options(list(readr.num_threads = 1), commatatest::prettify(df, col_select = c("POS1", "Yomi1"))),
  commata = commatatest::prettify2(df, col_select = c("POS1", "Yomi1")),
  check = "equal",
  times = 10
)
#> Unit: milliseconds
#>                 expr      min       lq     mean   median       uq      max
#>              current 284.0976 288.3105 307.6061 294.8477 342.9661 349.0926
#>  current_lim_threads 302.1819 307.4640 310.8363 309.6352 314.3722 319.2559
#>              commata 144.6344 147.0566 150.2238 148.0365 154.0453 160.8546
#>  neval
#>     10
#>     10
#>     10
```
