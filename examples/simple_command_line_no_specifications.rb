#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'clasp'

argv = %w{ --show-all=true infile -c outfile }

args = CLASP::Arguments.new(argv)

puts args.flags.size             # => 1
puts args.flags[0]               # => -c
puts args.flags[0].name          # => -c
puts args.flags[0].inspect       # => #<CLASP::Arguments::FlagArgument:0x007f87e18d4530 @arg="-c", @given_index=2, @given_name="-c", @argument_alias=nil, @given_hyphens=1, @given_label="c", @name="-c", @extras={}>

puts args.options.size           # => 1
puts args.options[0]             # => --show-all=true
puts args.options[0].name        # => --show-all
puts args.options[0].value       # => true
puts args.options[0].inspect     # => #<CLASP::Arguments::OptionArgument:0x007f87e18d4940 @arg="--show-all=true", @given_index=0, @given_name="--show-all", @argument_alias=nil, @given_hyphens=2, @given_label="show-all", @value="true", @name="--show-all", @extras={}>

puts args.values.size            # => 2
puts args.values[0]              # => infile
puts args.values[0].given_index  # => 1
puts args.values[1]              # => outfile
puts args.values[1].given_index  # => 3

# ############################## end of file ############################# #


