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


Gem::Specification.new do |gs|

	gs.name			=	'clasp'
	gs.version		=	'0.4.3'
	gs.date			=	'2015-06-22'
	gs.summary		=	'CLASP'
	gs.description	=	'CLASP Ruby library'
	gs.authors		=	[ 'Matt Wilson' ]
	gs.email		=	'matthew@synesis.com.au'
	gs.homepage		=	'http://synesis.com.au/software'
	gs.license		=	'Modified BSD'
	gs.files		=	[
							'lib/clasp.rb',
							'lib/clasp/aliases.rb',
							'lib/clasp/arguments.rb',
							'lib/clasp/clasp.rb',
							'lib/clasp/version.rb',
							'test/scratch/test_aliases.rb',
							'test/scratch/test_list_command_line.rb',
							'test/scratch/test_usage.rb',
							'test/unit/test_all.rb',
							'test/unit/test_arguments_1.rb',
							'test/unit/test_arguments_2.rb',
							'test/unit/test_arguments_3.rb',
							'test/unit/test_ARGV_rewrite.rb',
							'test/unit/test_defaults_1.rb',
	]
end

