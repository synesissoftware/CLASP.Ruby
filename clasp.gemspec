# ######################################################################### #
# File:         clasp.gemspec
#
# Purpose:      Gemspec for CLASP library
#
# Created:      22nd June 2015
# Updated:      22nd June 2015
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
# ######################################################################### #


$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'clasp'

Gem::Specification.new do |gs|

	gs.name			=	'clasp'
	gs.version		=	Clasp::VERSION
	gs.date			=	Date.today.to_s
	gs.summary		=	'CLASP'
	gs.description	=	'CLASP Ruby library'
	gs.authors		=	[ 'Matt Wilson' ]
	gs.email		=	'matthew@synesis.com.au'
	gs.homepage		=	'http://synesis.com.au/software'
	gs.license		=	'Modified BSD'
	gs.files		=	Dir[ 'Rakefile', '{bin,examples,lib,man,spec,test}/**/*', 'README*', 'LICENSE*' ] & `git ls-files -z`.split("\0")
end

