#!/usr/bin/ruby

#############################################################################
# File:         examples/cr-example.rb
#
# Purpose:      COMPLETE_ME
#
# Created:      11 06 2016
# Updated:      11 06 2016
#
# Author:       Matthew Wilson
#
#############################################################################

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'clasp'

PROGRAM_VERSION = '0.1.2'

Specifications = [

	CLASP.Flag('--all', alias: '-a', help: 'processes all item types'),
	CLASP.Flag('-c', help: 'count the processed items'),
	CLASP.Option('--opt1', alias: '-o', help: 'an option of some kind', values_range: %w{ val1, val2 }),
	CLASP.Option('--opt1=val1', alias: '-v'),

	# see next section for why these two are here
	CLASP::Flag.Help,
	CLASP::Flag.Version,
]

Args = CLASP::Arguments.new(ARGV, Specifications)

Args.flags.each do |f|

	case f.name
	when CLASP::Flag.Help.name

		CLASP.show_usage(Specifications, exit: 0, values: '<input-file> <output-file>')
	when CLASP::Flag.Version.name

		CLASP.show_version(Specifications, exit: 0, version: PROGRAM_VERSION)
	when '--all'

		;
	end
end

puts Args.flags.size
puts Args.flags[0].name
puts Args.flags[1].name
puts

puts Args.options.size
puts Args.options[0].name
puts Args.options[0].value
puts

puts Args.values.size
puts Args.values[0]
puts Args.values[1]
puts
