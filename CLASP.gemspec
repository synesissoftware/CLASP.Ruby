# ######################################################################### #
# File:         clasp.gemspec
#
# Purpose:      Gemspec for CLASP library
#
# Created:      22nd June 2015
# Updated:      11th June 2016
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
# ######################################################################### #


$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'clasp'

Gem::Specification.new do |spec|

	spec.name			=	'clasp'
	spec.version		=	CLASP::VERSION
	spec.date			=	Date.today.to_s
	spec.summary		=	'CLASP'
	spec.description	=	<<END_DESC
Command-Line Argument Sorting and Parsing library that provides a powerful
abstraction of command-line interpretation facilities. CLASP.Ruby is a Ruby port of the popular CLASP (C/C++) library, and provides declarative specification of command-line flags and options, aliasing, flag combination, UNIX de-facto standard flag processing, and a number of utility functions for expressing usage and version information.
END_DESC
	spec.authors		=	[ 'Matt Wilson' ]
	spec.email			=	'matthew@synesis.com.au'
	spec.homepage		=	'http://synesis.com.au/software'
	spec.license		=	'Modified BSD'
	spec.files			=	Dir[ 'Rakefile', '{bin,examples,lib,man,spec,test}/**/*', 'README*', 'LICENSE*' ] & `git ls-files -z`.split("\0")
end

