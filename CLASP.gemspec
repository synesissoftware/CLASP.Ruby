# ######################################################################### #
# File:         CLASP.gemspec
#
# Purpose:      Gemspec for CLASP.Ruby library
#
# Created:      22nd June 2015
# Updated:      11th June 2016
#
# ######################################################################### #


$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'clasp'

Gem::Specification.new do |spec|

	spec.name			=	'clasp-ruby'
	spec.version		=	CLASP::VERSION
	spec.date			=	Date.today.to_s
	spec.summary		=	'CLASP.Ruby'
	spec.description	=	<<END_DESC
Command-Line Argument Sorting and Parsing library that provides a powerful
abstraction of command-line interpretation facilities. CLASP.Ruby is a Ruby port of the popular CLASP (C/C++) library, and provides declarative specification of command-line flags and options, aliasing, flag combination, UNIX de-facto standard flag processing, and a number of utility functions for expressing usage and version information.
END_DESC
	spec.authors		=	[ 'Matt Wilson' ]
	spec.email			=	'matthew@synesis.com.au'
	spec.homepage		=	'http://github.com/synesissoftware/CLASP.Ruby'
	spec.license		=	'BSD 3-Clause'
	spec.files			=	Dir[ 'Rakefile', '{bin,examples,lib,man,spec,test}/**/*', 'README*', 'LICENSE*' ] & `git ls-files -z`.split("\0")
end

