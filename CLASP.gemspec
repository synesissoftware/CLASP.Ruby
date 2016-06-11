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
	spec.description	=	'CLASP.Ruby library'
	spec.authors		=	[ 'Matt Wilson' ]
	spec.email			=	'matthew@synesis.com.au'
	spec.homepage		=	'http://github.com/synesissoftware/CLASP.Ruby'
	spec.license		=	'BSD 3-Clause'
	spec.files			=	Dir[ 'Rakefile', '{bin,examples,lib,man,spec,test}/**/*', 'README*', 'LICENSE*' ] & `git ls-files -z`.split("\0")
end

