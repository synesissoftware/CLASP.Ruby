# ######################################################################### #
# File:         clasp.gemspec
#
# Purpose:      Gemspec for CLASP library
#
# Created:      22nd June 2015
# Updated:      10th June 2016
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
	spec.description	=	'CLASP Ruby library'
	spec.authors		=	[ 'Matt Wilson' ]
	spec.email			=	'matthew@synesis.com.au'
	spec.homepage		=	'http://synesis.com.au/software'
	spec.license		=	'Modified BSD'
	spec.files			=	Dir[ 'Rakefile', '{bin,examples,lib,man,spec,test}/**/*', 'README*', 'LICENSE*' ] & `git ls-files -z`.split("\0")
end

