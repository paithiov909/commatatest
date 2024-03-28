
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
#> [1] 232195

microbenchmark::microbenchmark(
  current = commatatest::prettify(df, col_select = c("POS1", "Yomi1")),
  current_lim_threads = withr::with_options(list(readr.num_threads = 1), commatatest::prettify(df, col_select = c("POS1", "Yomi1"))),
  commata = commatatest::prettify2(df, col_select = c("POS1", "Yomi1")),
  check = "equal",
  times = 10
)
#> Unit: milliseconds
#>                 expr      min       lq     mean   median       uq      max
#>              current 241.2317 244.9016 249.1675 248.1399 251.4151 260.1156
#>  current_lim_threads 257.3847 262.3324 271.0654 263.4570 272.6364 320.2063
#>              commata 100.1397 104.3287 115.0418 107.6954 116.3270 164.2477
#>  neval
#>     10
#>     10
#>     10
```
