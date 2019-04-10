#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'test/unit'

class Test_Specifications_1 < Test::Unit::TestCase

	def test_option_with_two_flag_aliases

		aliases	=	[

			CLASP.Flag('--action=list', alias: '-l'),
            CLASP.Flag('--action=change', alias: '-c'),
			CLASP.Option('--action', alias: '-a'),
		]

		# With no arguments
		begin

			argv = []
			args = CLASP::Arguments.new argv, aliases

			assert_equal 0, args.flags.size
			assert_equal 0, args.options.size
			assert_equal 0, args.values.size
		end

		# With option
		begin

			argv = %w{ --action=action1 }
			args = CLASP::Arguments.new argv, aliases

			assert_equal 0, args.flags.size
			assert_equal 1, args.options.size
			assert_equal 0, args.values.size

			assert_equal '--action', args.options[0].name
			assert_equal 'action1', args.options[0].value
		end

		# With option alias
		begin

			argv = %w{ -a action2 }
			args = CLASP::Arguments.new argv, aliases

			assert_equal 0, args.flags.size
			assert_equal 1, args.options.size
			assert_equal 0, args.values.size

			assert_equal '--action', args.options[0].name
			assert_equal 'action2', args.options[0].value
		end

		# With flag alias
		begin

			argv = %w{ -c }
			args = CLASP::Arguments.new argv, aliases

			assert_equal 0, args.flags.size
			assert_equal 1, args.options.size
			assert_equal 0, args.values.size

			assert_equal '--action', args.options[0].name
			assert_equal 'change', args.options[0].value
		end

	end
end

