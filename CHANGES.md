# **CLASP.Ruby** Changes

## 0.22.0.1 - 22nd August 2020

* merging branches, to clear up last two changes


## 25th May 2020

* CHANGES.md : improved markup


## 0.22.0 - 29th April 2019

* ``#action`` attribute for flag and option specifications (which is used in **libCLImate.Ruby**, and can be used by any application)


## 0.21.0 - 28th April 2019

* added typed values for options


## 0.20.3 - 19th April 2019

* fix inconsistency in handling `default_value` behaviour


## 0.20.2 - 19th April 2019

* restoring Ruby 1.9.3 compatibility


## 0.20.1.1 - 20th April 2019

* documentation improvements


## 0.20.1 - 19th April 2019

* fixed (ultimate) resolution of option argument specification
* fixed defect in `CLASP::Arguments::OptionArgument#==()`


## 0.20.0 - 19th April 2019

* now uses `CLASP::OptionSpecification#default_value` (if non-nil) when option is specified without value (e.g. `"myprog --opt= -f1 -f2"`, `"myprog --opt"`)
* `CLASP.show_usage()` now indicates default value in list of known values for option, and recognises the `:default_indicator` option for changing the indicator from default of `(default)`


## 0.19.1.1 - 19th April 2019

* documentation improvements
* preparatory refactoring


## 0.19.1 - 19th April 2019

* added missing `argument_specification` attribute to `CLASP::Arguments::FlagArgument` and `CLASP::Arguments::OptionArgument`, along with deprecated backwards-compatible `argument_alias`


## 0.19.0.1 - 19th April 2019

* fixed some documentation typos


## 0.19.0 - 13th April 2019

* added `CLASP::Arguments.load_specifications()`, which allows to load argument-specifications from `Hash` or from YAML
* `CLASP::Arguments.load()` now implemented in terms of `CLASP::Arguments.load_specifications()`
* `CLASP::FlagSpecification` and `CLASP::OptionSpecification` classes now compare against name (`String`) in `==()`


## 0.18.0 - 10th April 2019

* changed `*Alias` classes to `*Specification`
* `CLASP::Arguments#aliases` attribute is now changed to `#specifications`, and a [DEPRECATED] `#aliases` added


## 0.17.0 - 10th April 2019

* added `CLASP::Arguments.load()`, which allows to load argument-specifications from `Hash` or from YAML


## 0.16.1 - 10th April 2019

* minor adjustment to test case such that the library now compatible with Ruby 1.9.3+


<!-- ########################### end of file ########################### -->

