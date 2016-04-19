#! /usr/bin/ruby

$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')

require 'clasp'

Aliases = [

	CLASP.Flag('--version', :alias => '-v', :help => 'shows the program version and quits'),

	CLASP.Option('--verbosity', :help => 'the verbosity', values: [ 'silent', 'quiet', 'succinct', 'chatty', 'verbose' ]),
	CLASP.Option('--length', :alias => '-l', :help => 'specifies the length'),
	CLASP.Flag('--verbosity=succinct', aliases: [ '--succinct', '-s' ]
	CLASP.Flag('--verbosity=verbose', alias: '--verbose'),
]

Arguments	=	CLASP::Arguments.new(ARGV, Aliases)

puts
puts '*' * 40
puts 'usage:'
CLASP.show_usage(Aliases)

puts
puts '*' * 40
puts 'version:'
#CLASP.show_version Aliases, version: '1.2.3.4'
#CLASP.show_version Aliases, version_major: 1, version_minor: 2
CLASP.show_version Aliases, version: [ 1, 2, 3 ]


