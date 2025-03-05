#! /usr/bin/ruby

$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')

require 'clasp'

Specifications = [

  CLASP.Flag('--version', alias: '-v', help: 'shows the program version and quits'),

  CLASP.Option('--verbosity', help: 'the verbosity', values: [ 'silent', 'quiet', 'succinct', 'chatty', 'verbose' ]),
  CLASP.Option('--length', alias: '-l', help: 'specifies the length'),
  CLASP.Flag('--verbosity=succinct', aliases: [ '--succinct', '-s' ]),
  CLASP.Flag('--verbosity=verbose', alias: '--verbose'),
]

Arguments = CLASP::Arguments.new(ARGV, Specifications)

puts
puts '*' * 40
puts 'usage:'
puts
CLASP.show_usage(Specifications)
puts '*' * 40

puts 'version:'
puts
CLASP.show_version Specifications, version: [ 1, 2, 3 ]
puts '*' * 40

