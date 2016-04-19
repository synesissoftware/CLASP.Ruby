#! /usr/bin/ruby

$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')

require 'clasp'

Aliases = [

	CLASP.Flag('--version', :alias => '-v', :help => 'shows the program version and quits'),

	CLASP.Flag('--verbosity=verbose', aliases: [ '--verbose', '-v' ]),
]

Arguments	=	CLASP::Arguments.new(ARGV, Aliases)

CLASP.show_usage(Aliases)

