#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_Arguments_inspect_and_to_s < Test::Unit::TestCase

	include CLASP

	def test_no_arguments

		argv	=	[]
		args	=	Arguments.new argv

		assert_equal %Q<[]>, args.flags.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\[\].*>/, args.flags.inspect

		assert_equal %Q<[]>, args.options.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\[\].*>/, args.options.inspect

		assert_equal %Q<[]>, args.values.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\[\].*>/, args.values.inspect
	end

	def test_one_value

		argv	=	[ 'val1' ]
		args	=	Arguments.new argv

		assert_equal %Q<[]>, args.flags.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\[\].*>/, args.flags.inspect

		assert_equal %Q<[]>, args.options.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\[\].*>/, args.options.inspect

		assert_equal %Q<["val1"]>, args.values.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\["val1"\].*>/, args.values.inspect
	end

	def test_three_values

		argv	=	[ 'val1', 'val2', 'val3' ]
		args	=	Arguments.new argv

		assert_equal %Q<[]>, args.flags.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\[\].*>/, args.flags.inspect

		assert_equal %Q<[]>, args.options.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\[\].*>/, args.options.inspect

		assert_equal %Q<["val1", "val2", "val3"]>, args.values.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\["val1", "val2", "val3"\].*>/, args.values.inspect
	end

	def test_one_flag

		argv	=	[ '-f' ]
		args	=	Arguments.new argv

		assert_equal %Q<["-f"]>, args.flags.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\[#<CLASP::Arguments::FlagArgument:0x.*-f.*>\].*>/, args.flags.inspect

		assert_equal %Q<[]>, args.options.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\[\].*>/, args.options.inspect

		assert_equal %Q<[]>, args.values.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\[\].*>/, args.values.inspect
	end

	def test_two_flags

		argv	=	[ '-f', '-g' ]
		args	=	Arguments.new argv

		assert_equal %Q<["-f", "-g"]>, args.flags.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\[#<CLASP::Arguments::FlagArgument:0x.*-f.*-g.*>\].*>/, args.flags.inspect

		assert_equal %Q<[]>, args.options.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\[\].*>/, args.options.inspect

		assert_equal %Q<[]>, args.values.to_s
		assert_match /#<Array:0x[0-9a-fA-Z]+\s+\[\].*>/, args.values.inspect
	end
end


