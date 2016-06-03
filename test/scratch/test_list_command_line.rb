#! /usr/bin/ruby

$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')

require 'clasp'

Aliases = [

	CLASP.Flag('--help', help: 'shows this help and quits'),
	CLASP.Flag('--version', alias: '-v', help: 'shows this version and quits'),

	CLASP.Option('--verbosity', aliases: %w{ -V --verbose }),
]

Args = CLASP::Arguments.new(ARGV, Aliases)

puts
puts "flags #{Args.flags.size}:"
Args.flags.each do |flag|

	puts "\t#{flag}\t[#{flag.given_index}, #{flag.given_name}, #{flag.argument_alias}, #{flag.given_hyphens}, #{flag.given_label}, #{flag.name}]"
end

puts
puts "options #{Args.options.size}:"
Args.options.each do |option|

	puts "\t#{option}\t[#{option.given_index}, #{option.given_name}, #{option.argument_alias}, #{option.given_hyphens}, #{option.given_label}, #{option.name}, #{option.value}]"
end

puts
puts "values #{Args.values.size}:"
Args.values.each do |value|

	puts "\t#{value}"
end

