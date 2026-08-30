# CLASP.Ruby - Changes <!-- omit in toc -->


## 0.23.4 - 30th August 2026

* corrected shared project URL metadata in **clasp-ruby.gemspec**;


## 0.23.3 - 27th August 2026

* renamed **CLASP.gemspec** to **clasp-ruby.gemspec** so the filename stem matches `spec.name`;
* **clasp-ruby.gemspec**: `required_ruby_version` is the range `>= 1.9.3` (dropped `< 4`); **Gemfile.lock** and **.ruby-version** excluded from `spec.files`; `spec.summary` matches the README tagline; packaged **AUTHORS**, **CHANGES**, **CONTRIBUTING**, **EXAMPLES**, **FAQ**, **INSTALL**, **NEWS**, **SECURITY**, **TODO**;
* **Gemfile** sets `lockfile false` when Bundler supports it; stop tracking **Gemfile.lock**;
* CI uses `bundler-cache: false` and explicit `bundle install`; **Warnings** job on Ruby **3.4**; `gem build clasp-ruby.gemspec`;
* updated **run_all_unit_tests.sh** (from https://github.com/synesissoftware/misc-dev-scripts) to skip **tput** when **$TERM** is unset or stdout is not a TTY;
* **README.md**: tagline before badges; dropped Downloads / GitHub-release badges; Dependencies (Efferent / Afferent);
* **EXAMPLES.md** example links are repo-relative (`./examples/…`); catalogued remaining example programs;
* library source **Home:** URLs now use `https`;


## 0.23.2 - 15th August 2026

* added `# frozen_string_literal: true` to all **lib/** sources;


## 0.23.1 - 6th March 2025

* warnings;
* dependencies updated;
* layout (to 2-space indents);


## 0.23.0.2 - 20th January 2024

* simplifying tests using heredocs;
* minor documentation improvements;
* canonicalised all whitespace (to SPACEs not TABs);


## 0.23.0.1 - 1st December 2023

* added attribute `CLASP::Arguments#double_slash_index`;
* updated dependencies;


## 0.22.1 - 26th June 2022

* updated dependencies;


## 0.22.0.1 - 22nd August 2020

* merging branches, to clear up last two changes;
* improved **CHANGES.md** markup (25th May 2020);


## 0.22.0 - 29th April 2019

* `#action` attribute for flag and option specifications (which is used in **libCLImate.Ruby**, and can be used by any application);


## 0.21.0 - 28th April 2019

* added typed values for options;


## 0.20.3 - 19th April 2019

* fix inconsistency in handling `default_value` behaviour;


## 0.20.2 - 19th April 2019

* restoring Ruby 1.9.3 compatibility;


## 0.20.1.1 - 20th April 2019

* documentation improvements;


## 0.20.1 - 19th April 2019

* fixed (ultimate) resolution of option argument specification;
* fixed defect in `CLASP::Arguments::OptionArgument#==()`;


## 0.20.0 - 19th April 2019

* now uses `CLASP::OptionSpecification#default_value` (if non-nil) when option is specified without value (e.g. `"myprog --opt= -f1 -f2"`, `"myprog --opt"`);
* `CLASP.show_usage()` now indicates default value in list of known values for option, and recognises the `:default_indicator` option for changing the indicator from default of `(default)`;


## 0.19.1.1 - 19th April 2019

* documentation improvements;
* preparatory refactoring;


## 0.19.1 - 19th April 2019

* added missing `argument_specification` attribute to `CLASP::Arguments::FlagArgument` and `CLASP::Arguments::OptionArgument`, along with deprecated backwards-compatible `argument_alias`;


## 0.19.0.1 - 19th April 2019

* fixed some documentation typos;


## 0.19.0 - 13th April 2019

* added `CLASP::Arguments.load_specifications()`, which allows to load argument-specifications from `Hash` or from YAML;
* `CLASP::Arguments.load()` now implemented in terms of `CLASP::Arguments.load_specifications()`;
* `CLASP::FlagSpecification` and `CLASP::OptionSpecification` classes now compare against name (`String`) in `==()`;


## 0.18.2 - 12th April 2019

* documentation improvements;


## 0.18.1 - 11th April 2019

* completed [aA]lias(|es) => [sS]pecification(|s);


## 0.18.0 - 10th April 2019

* changed `*Alias` classes to `*Specification`;
* `CLASP::Arguments#aliases` attribute is now changed to `#specifications`, and a [DEPRECATED] `#aliases` added;


## 0.17.0 - 10th April 2019

* added `CLASP::Arguments.load()`, which allows to load argument-specifications from `Hash` or from YAML;


## 0.16.1 - 10th April 2019

* minor adjustment to test case such that the library now compatible with Ruby 1.9.3+;


## 0.16.0 - 19th March 2019

* added #program_name attribute and #find_flag() and #find_option() methods to CLASP::Arguments class; + added examples;


## 0.15.2 - 19th March 2019

* fixed subtle defect (due to overloading of term 'options');


## 0.15.1 - 19th March 2019

* tagged release;


## 0.15.0 - 27th February 2019

* removed the ImmutableArray class, and associated unit-tests; ~ changed the 'flags', 'options', 'values' arrays to frozen Array instances;


## 0.14.5 - 27th February 2019

* fixed a freeze vulnerability;


## 0.14.3 - 8th January 2019

* fix;


## 0.14.1.1 - 19th October 2018

* dependencies;


## 0.14.1 - 1st October 2018

* 0.14;


## 0.13.4 - 1st October 2018

* minor mods;


## 0.13.3 - 2nd March 2018

* merge;


## 0.13.2 - 1st March 2018

* fixed defect in CLASP.show_usage() and CLASP.show_version() parameter checking, which failed to permit new CLASP::Alias type in aliases array;


## 0.13.1 - 7th February 2018

* fix;


## 0.12.2 - 7th February 2018

* tagged release;


## 0.12.1 - 1st January 2018

* added required_message;


## 0.11.4 - 1st January 2018

* more tests, prior to adding support for required? attribute;


## 0.11.3 - 1st January 2018

* minor improvements to documentation for Flag() & Option() creator methods;


## 0.11.2 - 22nd June 2017

* fixed debug-visible warnings;


## 0.11.1 - 1st January 2018

* tagged release;


## 0.10.3 - 1st January 2018

* tagged release;


## 0.10.2 - 11th June 2016

* added generate_rdoc.rb;


## 0.10.1 - 10th June 2016

* Clasp module alias now moved to separate file, therefore separate require;


## 0.9.2 - 9th June 2016

* added build_gem.sh;


## 0.9.1 - 4th June 2016

* merge;


## 0.7.8 - 4th June 2016

* changed syntax form of options to opt: from :opt =>;


## 0.7.7 - 3rd June 2016

* layout;


## 0.7.5 - 5th February 2018

* tagged release;


## 0.7.4 - 5th February 2018

* tagged release;


## 0.7.3 - 5th February 2018

* tagged release;


## 0.7.2 - 5th February 2018

* tagged release;


## 0.7.1 - 5th February 2018

* tagged release;


## 0.6.10 - 5th February 2018

* merge;


## 0.6.9 - 5th February 2018

* tagged release;


## 0.6.8 - 5th February 2018

* tagged release;


## 0.6.7 - 5th February 2018

* tagged release;


## 0.6.5 - 5th February 2018

* tagged release;


<!-- ########################### end of file ########################### -->
