#! /usr/bin/ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_Arguments_2 < Test::Unit::TestCase

	def test_combined_flags_0

		aliases	=	[
		]
		args	=	CLASP::Arguments.new [ '-abc' ], aliases

		assert_equal 1, args.flags.size
		assert_equal '-abc', args.flags[0].name
		assert_equal '-abc', args.flags[0].to_s
		assert_equal 'abc', args.flags[0].given_label
		assert_equal 1, args.flags[0].given_hyphens
		assert_nil args.flags[0].argument_alias

		assert_equal 0, args.options.size

		assert_equal 0, args.values.size
	end

	def test_combined_flags_1

		aliases	=	[
			CLASP.Flag('--a', alias: '-a'),
			CLASP.Flag('--b', alias: '-b'),
			CLASP.Flag('--c', alias: '-c'),
		]
		args	=	CLASP::Arguments.new [ '-abc' ], aliases

		assert_equal 3, args.flags.size
		assert_equal '--a', args.flags[0].name
		assert_equal '--a', args.flags[0].to_s
		assert_equal 'abc', args.flags[0].given_label
		assert_equal 1, args.flags[0].given_hyphens
		assert_equal aliases[0], args.flags[0].argument_alias
		assert_equal '--b', args.flags[1].name
		assert_equal '--b', args.flags[1].to_s
		assert_equal 'abc', args.flags[1].given_label
		assert_equal 1, args.flags[1].given_hyphens
		assert_equal aliases[1], args.flags[1].argument_alias
		assert_equal '--c', args.flags[2].name
		assert_equal '--c', args.flags[2].to_s
		assert_equal 'abc', args.flags[2].given_label
		assert_equal 1, args.flags[2].given_hyphens
		assert_equal aliases[2], args.flags[2].argument_alias

		assert_equal 0, args.options.size

		assert_equal 0, args.values.size
	end
end


