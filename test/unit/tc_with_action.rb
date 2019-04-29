#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')

require 'clasp'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

class Test_WithAction < Test::Unit::TestCase

	def test_flag_with_action

		debug = false

		specifications	=	[

			CLASP.Flag('--debug', alias: '-d') { debug = true }
		]
		argv	=	[]
		args	=	CLASP.parse argv, specifications

		assert_equal 0, args.flags.size
		assert_equal 0, args.options.size
		assert_equal 0, args.values.size

		assert_false debug

		argv2	=	[ '--debug' ]
		args2	=	CLASP.parse argv2, specifications

		assert_equal 1, args2.flags.size
		assert_equal 0, args2.options.size
		assert_equal 0, args2.values.size

		assert_false debug

		if ix = args2.flags.index('--debug')

			flag = args2.flags[ix]

			flag.argument_specification.action.call(flag, flag.argument_specification)
		end

		assert_true debug
	end
end


