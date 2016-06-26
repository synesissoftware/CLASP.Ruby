#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_Arguments_4 < Test::Unit::TestCase

	def test_ARGV_rewrite_1

		aliases	=	nil
		argv	=	[ 'val1', '-f1', 'val2', '--' ]
		argv_c	=	argv.dup
		args	=	CLASP::Arguments.new argv, aliases

		assert_equal 1, args.flags.size
		assert_equal Hash.new, args.flags[0].extras

		assert_equal 0, args.options.size

		assert_equal 2, args.values.size

		assert_same argv, args.argv
		assert_equal 2, argv.size
		assert_equal 'val1', argv[0]
		assert_equal 'val2', argv[1]

		assert_equal args.argv_original_copy, argv_c
		assert_equal argv_c, args.argv_original_copy
	end

	def test_ARGV_rewrite_2

		aliases	=	nil
		argv	=	[ 'val1', '-f1', 'val2', '--' ]
		argv_c	=	argv.dup
		args	=	CLASP::Arguments.new argv, aliases, mutate_argv: false

		assert_equal 1, args.flags.size
		assert_equal Hash.new, args.flags[0].extras

		assert_equal 0, args.options.size

		assert_equal 2, args.values.size

		assert_same argv, args.argv
		assert_equal 4, argv.size
		assert_equal 'val1', argv[0]
		assert_equal '-f1', argv[1]
		assert_equal 'val2', argv[2]
		assert_equal '--', argv[3]

		assert_equal args.argv_original_copy, argv_c
		assert_equal argv_c, args.argv_original_copy
	end
end



