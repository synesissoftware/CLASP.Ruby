# ######################################################################## #
# File:     clasp-ruby.gemspec
#
# Purpose:  Gemspec for CLASP.Ruby library
#
# Created:  22nd June 2015
# Updated:  28th August 2026
#
# ######################################################################## #


$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'clasp/version'


PROJECT_URL = 'https://github.com/synesissoftware/CLASP.Ruby'


Gem::Specification.new do |spec|

  spec.name         = 'clasp-ruby'
  spec.summary      = 'Command-Line Argument Sorting and Parsing, for Ruby'
  spec.version      = CLASP::VERSION
  spec.description  = <<END_DESC
Command-Line Argument Sorting and Parsing library that provides a powerful abstraction of command-line interpretation facilities.

CLASP.Ruby is a Ruby port of the popular CLASP (C/C++) library, and provides declarative specification of command-line flags and options, aliasing, flag combination, UNIX de-facto standard flag processing, and a number of utility functions for expressing usage and version information.
END_DESC

  spec.authors      = [
    'Matt Wilson',
  ]
  spec.email        = [
    'matthew@synesis.com.au',
  ]
  spec.homepage     = PROJECT_URL
  spec.license      = 'BSD-3-Clause'

  spec.required_ruby_version = [ '>= 1.9.3' ]

  spec.metadata = {
    'bug_tracker_uri' => "#{PROJECT_URL}/issues",
    'changelog_uri' => "#{PROJECT_URL}/blob/master/CHANGES.md",
    'homepage_uri' => PROJECT_URL,
    'source_code_uri' => PROJECT_URL,
  }

  spec.files = Dir[
    'Rakefile',
    '{bin,examples,lib,man,spec,test}/**/*',
    'AUTHORS*',
    'CHANGES*',
    'CONTRIBUTING*',
    'EXAMPLES*',
    'FAQ*',
    'INSTALL*',
    'LICENSE*',
    'NEWS*',
    'README*',
    'SECURITY*',
    'TODO*',
  ] & `git ls-files -z`.split("\0")
  spec.files -= [
    '.ruby-version',
    'Gemfile.lock',
  ]

  spec.add_development_dependency "xqsr3", [ '>= 0.39.5', '< 1.0' ]
end


# ############################## end of file ############################# #
