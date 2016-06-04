#! /usr/bin/ruby

$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')

require 'clasp'

Aliases = [

	CLASP.Flag('--version', alias: '-v', help: 'shows the program version and quits'),

	CLASP.Option('--verbosity', help: 'the verbosity', values: [ 'silent', 'quiet', 'succinct', 'chatty', 'verbose' ]),
	CLASP.Option('--length', alias: '-l', help: 'specifies the length'),
	CLASP.Flag('--verbosity=succinct', aliases: [ '--succinct', '-s' ]),
	CLASP.Flag('--verbosity=verbose', aliases: [ '--verbose', '-v' ]),
]

Arguments	=	CLASP::Arguments.new(ARGV, Aliases)

puts
puts '*' * 40
puts 'usage:'
puts
CLASP.show_usage(Aliases)
puts '*' * 40

puts 'version:'
puts
CLASP.show_version Aliases, version: [ 1, 2, 3 ]
puts '*' * 40

