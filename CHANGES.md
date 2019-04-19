# **CLASP.Ruby** Changes

## 0.19.1 19th April 2019

* + added missing argument_specification attribute to CLASP::Arguments::FlagArgument and CLASP::Arguments::OptionArgument, along with deprecated backwards-compatible argument_alias

## 0.19.0.1 - 19th April 2019

* ~ fixed some documentation typos

## 0.19.0 - 13th April 2019

* + added CLASP::Arguments.load_specifications(), which allows to load argument-specifications from Hash or from YAML
* ~ CLASP::Arguments.load() now implemented in terms of CLASP::Arguments.load_specifications()
* + CLASP::FlagSpecification and CLASP::OptionSpecification classes now compare against name (String) in ==()

## 0.18.0 - 10th April 2019

* ~ changed *Alias classes to *Specification
* ~ CLASP::Arguments#aliases attribute is now changed to #specifications, and a [DEPRECATED] #aliases added

## 0.17.0 - 10th April 2019

* + added CLASP::Arguments.load(), which allows to load argument-specifications from Hash or from YAML

## 0.16.1 - 10th April 2019

* ~ minor adjustment to test case such that the library now compatible with Ruby 1.9.3+


