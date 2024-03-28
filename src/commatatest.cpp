#include <Rcpp.h>

#include "commata/field_scanners.hpp"
#include "commata/parse_csv.hpp"
#include "commata/table_scanner.hpp"

using commata::table_scanner;
using commata::make_field_translator;
using commata::parse_csv;
using commata::replace_if_skipped;

using namespace Rcpp;

// [[Rcpp::export]]
Rcpp::DataFrame commataTest(const std::string contents,
                            std::vector<std::size_t> col_select,
                            std::size_t nrow) {

  std::vector<std::string> col;
  col.reserve(nrow);

  std::vector<std::vector<std::string>> parsed_cols;
  table_scanner scanner(0);

  for (std::size_t i = 0; i < col_select.size(); i++) {
    parsed_cols.push_back(col);
  }
  for (std::size_t i = 0; i < col_select.size(); i++) {
    scanner.set_field_scanner(
      col_select[i] - 1,
      make_field_translator(parsed_cols[i], replace_if_skipped<std::string>("*"))
    );
  }
  parse_csv(contents, std::move(scanner));

  return Rcpp::wrap(parsed_cols);
}
