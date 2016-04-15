#! /usr/bin/ruby

$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')

require 'clasp'

Aliases = [

	Clasp.Flag('--version', :alias => '-v', :help => 'shows the program version and quits'),

	Clasp.Option('--verbosity', :help => 'the verbosity', values: [ 'silent', 'quiet', 'succinct', 'chatty', 'verbose' ]),
	Clasp.Option('--length', :alias => '-l', :help => 'specifies the length'),
	Clasp.Flag('--verbosity=succinct', alias: '--succinct'),
	Clasp.Flag('--verbosity=succinct', alias: '-s'),
	Clasp.Flag('--verbosity=verbose', aliases: [ '--verbose', '-v' ]),
]

Arguments	=	Clasp::Arguments.new(ARGV, Aliases)

#Arguments.show_version(

Clasp::show_usage(Aliases)

