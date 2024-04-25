#' Prettify tokenized output
#'
#' Turns a single character column into features
#' while separating with delimiter.
#'
#' @param tbl A data.frame that has feature column to be prettified.
#' @param col <[`data-masked`][rlang::args_data_masking]>
#' Column containing features to be prettified.
#' @param into Character vector that is used as column names of
#' features.
#' @param col_select Character or integer vector that will be kept
#' in prettified features.
#' @returns A data.frame.
#' @export
prettify2 <- function(tbl,
                      col = "feature",
                      into = gibasa::get_dict_features("ipa"),
                      col_select = seq_along(into)) {
  if (is.numeric(col_select) && max(col_select) <= length(into)) {
    col_select <- which(seq_along(into) %in% col_select, arr.ind = TRUE)
  } else {
    col_select <- which(into %in% col_select, arr.ind = TRUE)
  }
  if (rlang::is_empty(col_select)) {
    rlang::abort("Invalid columns have been selected.")
  }

  col <- rlang::enquo(col)
  blank <- c("*", "NA", "")

  features <-
    commataTest(
      paste0(dplyr::pull(tbl, {{ col }}), collapse = "\n"),
      col_select,
      nrow(tbl)
    ) %>%
    dplyr::mutate(dplyr::across(
      dplyr::where(is.character), ~ dplyr::if_else(. %in% blank, NA, .)
    ))
  colnames(features) <- into[col_select]

  dplyr::bind_cols(dplyr::select(tbl, -!!col), features)
}
