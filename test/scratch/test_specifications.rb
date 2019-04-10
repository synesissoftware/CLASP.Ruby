#! /usr/bin/ruby

$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')

require 'clasp'

Specifications = [

	CLASP.Flag('--help', help: 'shows this help and quits'),
	CLASP.Flag('--version', alias: '-v', help: 'shows this version and quits'),
	CLASP.Alias('--version', aliases: [ '-ver', '-V' ]),

	CLASP.Option('--directory', alias: '-d', help: 'a directory within which to process'),
	CLASP.Option('--patterns', alias: '-p', help: "one or more patterns against which the entries will be matched, separated by '|' or the platform-specific separator - ':' UNIX, ';' Windows"),

	CLASP.Option('--case-sensitive', alias: '-c', help: 'determines whether case sensitive', values_range: %W{ yes no true false }, default_value: false),
	CLASP.Alias('--case-sensitive=false', alias: '-I'),
]

Arguments	=	CLASP::Arguments.new(ARGV, Specifications)
Flags		=	Arguments.flags
Options		=	Arguments.options
Values		=	Arguments.values

if Flags.include? '--help'

	CLASP.show_usage Specifications, exit: 0
end

Flags.each do |f|

	puts f.inspect
end

Options.each do |o|

	puts o.inspect
end

